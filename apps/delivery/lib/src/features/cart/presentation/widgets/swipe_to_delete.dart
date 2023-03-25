import 'package:flutter/material.dart';

import 'package:delivery/l10n/l10n.dart';

class SwipeToDeleteOverlay extends StatefulWidget {
  const SwipeToDeleteOverlay({super.key});

  static void showOverlay(BuildContext context) {
    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) => const SwipeToDeleteOverlay(),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  @override
  _SwipeToDeleteOverlayState createState() => _SwipeToDeleteOverlayState();
}

class _SwipeToDeleteOverlayState extends State<SwipeToDeleteOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _fadeInController;
  late final AnimationController _fadeOutController;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _fadeOutAnimation;

  @override
  void initState() {
    super.initState();
    _fadeInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeOutController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeInController,
        curve: Curves.easeIn,
      ),
    );
    _fadeOutAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeOutController,
        curve: Curves.easeOut,
      ),
    );
    _fadeInController.forward();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _fadeOutController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _fadeOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(Alignment.center.x, Alignment.center.y + 0.5),
      children: [
        AnimatedBuilder(
          animation: _fadeInAnimation,
          builder: (BuildContext context, Widget? child) {
            return Opacity(
              opacity: _fadeInAnimation.value,
              child: AnimatedBuilder(
                animation: _fadeOutAnimation,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: _fadeOutAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: ShapeDecoration(
                        shape: const StadiumBorder(),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        context.l10n.swipeToDelete,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
