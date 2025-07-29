import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel();

  // 密码登陆
  final pwdFormKey = GlobalKey<FormState>();

  // 邮箱登陆
  final emailFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailCodeController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailCodeController.dispose();
    super.dispose();
  }
}
