import 'package:delivery/src/core/utils/flutter_scroll_to_top/scroll_wrapper.dart';
import 'package:flutter/material.dart';

class SizeExpandedSection extends StatefulWidget {
  final Widget child;
  final bool expand;
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final PromptAnimation animType;
  const SizeExpandedSection(
      {required this.expand,
      required this.child,
      required this.animType,
      required this.curve,
      required this.duration,
      required this.alignment,
      Key? key})
      : super(key: key);

  @override
  _SizeExpandedSectionState createState() => _SizeExpandedSectionState();
}

class _SizeExpandedSectionState extends State<SizeExpandedSection> with SingleTickerProviderStateMixin {
  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
  }

  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: widget.duration);
    animation = CurvedAnimation(
      parent: expandController,
      curve: widget.curve,
    );
    if (widget.expand) _runExpandCheck();
  }

  void _runExpandCheck() {
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(SizeExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animType == PromptAnimation.fade) {
      return FadeTransition(
        opacity: animation,
        child: widget.child,
      );
    } else if (widget.animType == PromptAnimation.scale) {
      return ScaleTransition(
        scale: animation,
        child: widget.child,
      );
    } else if (widget.animType == PromptAnimation.size) {
      return SizeTransition(
        sizeFactor: animation,
        child: Row(
          children: [
            Expanded(child: Align(alignment: widget.alignment, child: widget.child)),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
