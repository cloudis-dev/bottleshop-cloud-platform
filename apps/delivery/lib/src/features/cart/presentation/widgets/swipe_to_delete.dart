import 'package:flutter/material.dart';

class SwipeToDeleteOverlay extends StatefulWidget {
  // final String text;

  const SwipeToDeleteOverlay({
    Key? key,
  }) : super(key: key);

  @override
  _SwipeToDeleteOverlayState createState() => _SwipeToDeleteOverlayState();
}

class _SwipeToDeleteOverlayState extends State<SwipeToDeleteOverlay> {
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showOverlay = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Visibility(
        visible: _showOverlay,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Text('<swipe-to-delete>',
                style: Theme.of(context).textTheme.bodyLarge
                // TextStyle(
                //   color: Colors.white,
                //   fontSize: 24.0,
                //   fontWeight: FontWeight.bold,
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
