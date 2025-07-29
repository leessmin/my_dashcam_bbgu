import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/data/repositories/loginRegisterRepository/login_register_repository.dart';
import 'package:my_dashcam/data/repositories/loginRegisterRepository/models/request.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:toastification/toastification.dart';

class RegisterViewModel extends ChangeNotifier {
  RegisterViewModel({required this.loginRegisterRepository});

  final LoginRegisterRepository loginRegisterRepository;

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rePasswordController = TextEditingController();
  final emailCodeController = TextEditingController();

  // 注册
  void registerHandle(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      final username = usernameController.text;
      final email = emailController.text;
      final password = passwordController.text;
      final emailCode = emailCodeController.text;
      final res = await loginRegisterRepository.register(
        RegisterRequest(
          username: username,
          email: email,
          password: password,
          code: emailCode,
        ),
      );

      if (res?.code == 200) {
        toastification.show(
          title: Text(res?.data ?? ""),
          autoCloseDuration: Duration(seconds: 3),
        );
        if (context.mounted) {
          context.push(Routes.login);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    emailCodeController.dispose();
    super.dispose();
  }
}
