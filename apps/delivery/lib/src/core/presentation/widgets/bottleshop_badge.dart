import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class BottleshopBadge extends StatelessWidget {
  final Widget child;
  final String? badgeText;
  final bool showBadge;
  final badges.BadgePosition position;
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
    return badges.Badge(
      //alignment: alignment,
      ignorePointer: true,
      showBadge: showBadge,
      badgeAnimation: const badges.BadgeAnimation.scale(),
      badgeContent: badgeText != null
          ? Text(
              badgeText!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(color: Colors.white),
            )
          : null,
      badgeStyle: const badges.BadgeStyle(elevation: 0),
      position: position,
      child: child,
    );
  }
}
