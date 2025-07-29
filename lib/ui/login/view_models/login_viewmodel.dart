import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/data/models/response.dart';
import 'package:my_dashcam/data/repositories/device/device_repository.dart';
import 'package:my_dashcam/data/repositories/device/models/response.dart';
import 'package:my_dashcam/data/repositories/loginRegister/login_register_repository.dart';
import 'package:my_dashcam/data/repositories/loginRegister/models/request.dart';
import 'package:my_dashcam/data/repositories/loginRegister/models/response.dart';
import 'package:my_dashcam/routing/routes.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({
    required this.deviceRepository,
    required this.loginRegisterRepository,
  });

  final DeviceRepository deviceRepository;
  final LoginRegisterRepository loginRegisterRepository;

  // 密码登陆
  final pwdFormKey = GlobalKey<FormState>();

  // 邮箱登陆
  final emailFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailCodeController = TextEditingController();

  /// 登陆
  /// [tab] 类型，0密码登陆 1邮箱验证码登陆
  void loginHandle(int tab, BuildContext context) async {
    final email = emailController.text;

    // 请求回调
    Future<Response<LoginResponse>> Function(
      Response<DeviceRegisterResponse?>?,
    )?
    fn;

    if (tab == 0) {
      if (!pwdFormKey.currentState!.validate()) {
        return;
      }
      fn = (deviceInfo) async {
        final password = passwordController.text;
        final result = await loginRegisterRepository.loginPassword(
          LoginPasswordRequest(
            email: email,
            password: password,
            deviceId: deviceInfo!.data!.id,
          ),
        );
        return result;
      };
    } else {
      // NOTE: tab == 1, 防止出现fn==null的情况，所以使用else
      if (!emailFormKey.currentState!.validate()) {
        return;
      }
      fn = (deviceInfo) async {
        final emailCode = emailCodeController.text;
        final result = await loginRegisterRepository.loginEmailCode(
          LoginEmailCodedRequest(
            email: email,
            code: emailCode,
            deviceId: deviceInfo!.data!.id,
          ),
        );
        return result;
      };
    }

    final deviceRes = await deviceRepository.registerDevice();
    final result = await fn(deviceRes);
    if (result.code == 200 && context.mounted) {
      context.push(Routes.home);
    }
  }

  /// 跳过登陆
  void skipLogin(BuildContext context) {
    loginRegisterRepository.skipLogin();
    context.push(Routes.home);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailCodeController.dispose();
    super.dispose();
  }
}
