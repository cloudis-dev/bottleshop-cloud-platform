import 'package:flutter/material.dart';

class BottleshopSectionHeading extends StatelessWidget {
  final Widget? leading;
  final String label;
  final List<Widget>? trailingWidgets;
  const BottleshopSectionHeading({
    Key? key,
    this.leading,
    required this.label,
    this.trailingWidgets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        leading: leading,
        title: Text(
          label,
          style: Theme.of(context).textTheme.headline6,
        ),
        trailing: trailingWidgets != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: trailingWidgets!,
              )
            : null,
      ),
    );
  }
}
