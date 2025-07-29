import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/email_code_input.dart';
import 'package:my_dashcam/ui/core/ui/password_input.dart';
import 'package:my_dashcam/ui/login/view_models/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

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
                          "登陆",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(height: 10),
                        TabBar(
                          controller: _tabController,
                          labelColor: getCatppuccinByCtx(context).lavender,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 3,
                              color: getCatppuccinByCtx(context).lavender,
                            ),
                          ),
                          tabs: [Text("密码登陆"), Text("邮箱登陆")],
                        ),
                        SizedBox(height: 25),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            physics: NeverScrollableScrollPhysics(), // 禁止拖动
                            children: [
                              _passwordLogin(context),
                              _emailLogin(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            widget.viewModel.skipLogin(context);
                          },
                          child: Text(
                            "什么?不想注册?那就匿名使用叭",
                            style: TextStyle(
                              color: getCatppuccinByCtx(context).overlay2,
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

  // 密码登陆
  Widget _passwordLogin(BuildContext context) {
    final viewModel = widget.viewModel;

    return Form(
      key: viewModel.pwdFormKey,
      child: Column(
        children: [
          SizedBox(height: 10),
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
          _registerButon(context),
          SizedBox(height: 20),
          _loginButton(),
        ],
      ),
    );
  }

  // 邮箱登陆
  Widget _emailLogin(BuildContext context) {
    final viewModel = widget.viewModel;

    return Form(
      key: viewModel.emailFormKey,
      child: Column(
        children: [
          SizedBox(height: 10),
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
          EmailCodeInput(
            controller: viewModel.emailCodeController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "请输入邮箱验证码";
              }
              return null;
            },
            getEmail: () => viewModel.emailController.text,
          ),
          SizedBox(height: 20),
          _registerButon(context),
          SizedBox(height: 20),
          _loginButton(),
        ],
      ),
    );
  }

  // 登陆按钮
  Widget _loginButton() {
    final viewModel = widget.viewModel;

    return Center(
      child: InkWell(
        onTap: () {
          viewModel.loginHandle(_tabController.index, context);
          debugPrint("点击了登陆");
        },
        borderRadius: BorderRadius.circular(50),
        child: Ink(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: getCatppuccinByCtx(context).lavender,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              "登陆",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 注册按钮
  Widget _registerButon(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            context.push(Routes.register);
          },
          child: Text(
            "还没有账号?注册一个",
            style: TextStyle(color: getCatppuccinByCtx(context).overlay2),
          ),
        ),
      ],
    );
  }
}
