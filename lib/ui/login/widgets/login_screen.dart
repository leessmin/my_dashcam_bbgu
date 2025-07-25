import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/login/widgets/email_code_input.dart';
import 'package:my_dashcam/ui/login/widgets/password_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
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
                            children: [_passwordLogin(), _emailLogin()],
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
                            debugPrint("点击了注册");
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
  Widget _passwordLogin() {
    return Column(
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
        _registerButon(),
        SizedBox(height: 20),
        Center(
          child: InkWell(
            onTap: () {
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
        ),
      ],
    );
  }

  // 邮箱登陆
  Widget _emailLogin() {
    return Column(
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
        EmailCodeInput(),
        SizedBox(height: 20),
        _registerButon(),
        SizedBox(height: 20),
        Center(
          child: InkWell(
            onTap: () {
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
        ),
      ],
    );
  }

  // 注册按钮
  Widget _registerButon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            debugPrint("点击了注册");
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
