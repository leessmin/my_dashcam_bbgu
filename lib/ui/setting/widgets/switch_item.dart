import 'package:flutter/material.dart';

class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String label;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                SizedBox(width: 4,),
                Text(
                  label,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],
    );
  }
}
