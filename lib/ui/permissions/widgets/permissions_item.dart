import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';

class PermissionsItem extends StatelessWidget {
  const PermissionsItem({
    super.key,
    required this.permissionsText,
    required this.isPermissions,
    required this.onTap,
  });

  final String permissionsText;
  final bool isPermissions;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(permissionsText),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        isPermissions ? "拥有" : "未拥有",
                        style: TextStyle(
                          color: isPermissions
                              ? getCatppuccinByCtx(context).green
                              : getCatppuccinByCtx(context).red,
                          fontSize: Theme.of(
                            context,
                          ).textTheme.labelMedium?.fontSize,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
