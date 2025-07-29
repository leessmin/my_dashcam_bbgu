import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/email_code_input.dart';
import 'package:my_dashcam/ui/core/ui/password_input.dart';
import 'package:my_dashcam/ui/register/view_models/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, required this.viewModel});

  final RegisterViewModel viewModel;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return Scaffold(
      resizeToAvoidBottomInset: false, // 禁止键盘挤压布局
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            heightFactor: 4,
            child: Text(
              "行车记录仪",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 35,
                fontWeight: FontWeight.w800,
                color: getCatppuccinByCtx(context).lavender,
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "注册",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 25),
                        Expanded(
                          child: Form(
                            key: viewModel.formKey,
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: viewModel.usernameController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "用户名",
                                  ),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        value.length < 2) {
                                      return '用户名长度必须大于2';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: viewModel.emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "邮箱",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '请输入邮箱地址';
                                    }
                                    if (!RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    ).hasMatch(value)) {
                                      return '请输入有效的邮箱地址';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                PasswordInput(
                                  controller: viewModel.passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "请输入密码";
                                    }
                                    if (value.length < 6) {
                                      return "密码长度不能小于6位";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                PasswordInput(
                                  labelText: "再次确认密码",
                                  controller: viewModel.rePasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "请再次输入密码";
                                    }
                                    if (value !=
                                        viewModel.passwordController.text) {
                                      return "两次密码输入不一致";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20),
                                EmailCodeInput(
                                  getEmail: () {
                                    return viewModel.emailController.text;
                                  },
                                  controller: viewModel.emailCodeController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "请输入邮箱验证码";
                                    }
                                    return null;
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        context.push(Routes.login);
                                      },
                                      child: Text(
                                        "已有账号,去登陆...",
                                        style: TextStyle(
                                          color: getCatppuccinByCtx(
                                            context,
                                          ).overlay2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      viewModel.registerHandle(context);
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: Ink(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: getCatppuccinByCtx(
                                          context,
                                        ).lavender,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "注册",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 25,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
