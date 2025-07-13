import 'package:button_group/button_group.dart';
import 'package:button_group/data_item.dart';
import 'package:flutter/material.dart';
import 'package:my_dashcam/ui/core/themes/catppuccin.dart';

class SelectItem<T> extends StatelessWidget {
  const SelectItem({
    super.key,
    required this.title,
    required this.label,
    required this.dataItem,
    required this.currentData,
    required this.onSelect,
  });

  final String title;
  final String label;
  final List<DataItem<T>> dataItem;
  final T currentData;
  final void Function(T) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 8),
        ButtonGroup(
          dataItem: dataItem,
          currentData: currentData,
          onSelect: onSelect,
          buttonBackgroundColor: getCatppuccinByCtx(context).lavender,
          currentButtonBackgroundColor: getCatppuccinByCtx(context).mauve,
        ),
        Divider(color: Theme.of(context).dividerColor),
      ],
    );
  }
}
