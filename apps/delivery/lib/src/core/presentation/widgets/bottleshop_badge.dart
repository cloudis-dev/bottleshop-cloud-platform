import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class BottleshopBadge extends StatelessWidget {
  final Widget child;
  final String? badgeText;
  final bool showBadge;
  final BadgePosition position;

  const BottleshopBadge({
    Key? key,
    required this.child,
    required this.badgeText,
    required this.showBadge,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Badge(
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
