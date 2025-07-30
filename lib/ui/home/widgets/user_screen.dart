import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_dashcam/routing/routes.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/home/view_models/user_viewmodel.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.viewModel});

  final UserViewModel viewModel;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final uiState = widget.viewModel.uiState;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _userInfoCard(
              username: uiState.username,
              email: uiState.email,
              onBack: () async {
                await widget.viewModel.logout();
                if (context.mounted) {
                  context.push(Routes.login);
                }
              },
            ),
            SizedBox(height: 10),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text(
                      "我的设备",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Divider(),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        padding: EdgeInsets.all(10),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          _deviceCard(deviceName: 'Redmi K30', version: '15', display: 'bliss_phoenix-userdebug 15 AP3A.241105.008 111'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 用户信息栏
  Widget _userInfoCard({
    required String username,
    required String email,
    required void Function() onBack,
  }) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.account_circle, size: 56),
            title: Text(
              username,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(email),
            ),
            trailing: TextButton(
              onPressed: onBack,
              child: Text(
                "退出",
                style: TextStyle(color: getCatppuccinByCtx(context).red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 设备卡片
  Widget _deviceCard({
    required String deviceName,
    required String version,
    required String display,
  }) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(deviceName, style: Theme.of(context).textTheme.titleMedium),
            Text(
              "Android$version",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                display,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
