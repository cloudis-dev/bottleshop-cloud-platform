import 'package:flutter/material.dart';

class AuthFormTemplate extends StatelessWidget {
  final Widget child;
  final bool hasElevation;

  const AuthFormTemplate({
    Key? key,
    required this.child,
    this.hasElevation = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: hasElevation ? 15.0 : 0.0,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: child,
      ),
    );
  }
}
