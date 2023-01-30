import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BottleshopBadge extends StatelessWidget {
  final Widget child;
  final String? badgeText;
  final bool showBadge;
  final BadgePosition position;
  final Alignment alignment;

  const BottleshopBadge({
    Key? key,
    required this.child,
    required this.badgeText,
    required this.showBadge,
    required this.position,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
      alignment: alignment,
      ignorePointer: true,
      showBadge: showBadge,
      animationType: BadgeAnimationType.scale,
      badgeContent: badgeText != null
          ? Text(
              badgeText!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            )
          : null,
      elevation: 0,
      position: position,
      child: child,
    );
  }
}
