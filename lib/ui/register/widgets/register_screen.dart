import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/email_code_input.dart';
import 'package:my_dashcam/ui/core/ui/password_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
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
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "邮箱",
                                ),
                              ),
                              SizedBox(height: 20),
                              PasswordInput(),
                              SizedBox(height: 20),
                              PasswordInput(labelText: "再次确认密码"),
                              SizedBox(height: 20),
                              EmailCodeInput(),
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
                                    debugPrint("点击了注册");
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
