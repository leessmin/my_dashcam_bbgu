import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';
import 'package:my_dashcam/ui/core/ui/default_child_app_bar.dart';
import 'package:my_dashcam/ui/permissions/view_models/permissions_viewmodel.dart';
import 'package:my_dashcam/ui/permissions/widgets/permissions_item.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key, required this.viewmodel});

  final PermissionsViewModel viewmodel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultChildAppBar(context, title: "权限"),
      body: ListenableBuilder(
        listenable: Listenable.merge([viewmodel]),
        builder: (context, _) {
          final uiStatus = viewmodel.uiStatus;
          if (uiStatus == null) {
            return Center();
          }
          return ListView(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("权限状态", style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    uiStatus.isAllReady() ? "完美" : "存在无法使用的权限",
                    style: TextStyle(
                      color: uiStatus.isAllReady()
                          ? getCatppuccinByCtx(context).green
                          : getCatppuccinByCtx(context).red,
                      fontSize: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.fontSize,
                    ),
                  ),
                ],
              ),
              Divider(color: Theme.of(context).dividerColor),
              SizedBox(height: 20),
              PermissionsItem(
                permissionsText: "摄像头权限",
                isPermissions: uiStatus.camera,
                onTap: () {
                  viewmodel.requireCamera();
                },
              ),
              PermissionsItem(
                permissionsText: "麦克风权限",
                isPermissions: uiStatus.microphone,
                onTap: () {
                  viewmodel.requireMicrophone();
                },
              ),
              PermissionsItem(
                permissionsText: "定位服务权限",
                isPermissions: uiStatus.location,
                onTap: () {
                  viewmodel.requireLocation();
                },
              ),
              PermissionsItem(
                permissionsText: "通知权限",
                isPermissions: uiStatus.notification,
                onTap: () {
                  viewmodel.requireNotification();
                },
              ),
              PermissionsItem(
                permissionsText: "允许后台运行",
                isPermissions: uiStatus.ignoreBatteryOptimizations,
                onTap: () {
                  viewmodel.requireIgnoreBattery();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
