// import 'package:flutter/material.dart';

// import 'package:delivery/l10n/l10n.dart';

// class SwipeToDeleteOverlay extends StatefulWidget {
//   const SwipeToDeleteOverlay({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _SwipeToDeleteOverlayState createState() => _SwipeToDeleteOverlayState();
// }

// class _SwipeToDeleteOverlayState extends State<SwipeToDeleteOverlay> {
//   bool _showOverlay = true;

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Future.delayed(const Duration(milliseconds: 5000), () {
//       if (mounted) {
//         setState(() {
//           _showOverlay = false;
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: _showOverlay,
//       child: Container(
//         margin: const EdgeInsets.all(12),
//         padding: const EdgeInsets.all(12),
//         decoration: ShapeDecoration(
//           shape: const StadiumBorder(),
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//         child: Text(
//           context.l10n.swipeToDelete,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:delivery/l10n/l10n.dart';

class SwipeToDeleteOverlay extends StatefulWidget {
  const SwipeToDeleteOverlay({
    Key? key,
  }) : super(key: key);

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
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, 1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment(Alignment.center.x, Alignment.center.y + 0.5),
      children: [
        IgnorePointer(
          ignoring: _animationController.status == AnimationStatus.reverse ||
              _animationController.status == AnimationStatus.forward,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (BuildContext context, Widget? child) {
              return FractionalTranslation(
                translation: _slideAnimation.value,
                child: child,
              );
            },
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
          ),
        ),
      ],
    );
  }
}
