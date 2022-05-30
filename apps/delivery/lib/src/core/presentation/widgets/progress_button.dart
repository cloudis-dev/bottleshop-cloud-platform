// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'package:delivery/src/config/constants.dart';
import 'package:flutter/material.dart';

enum ButtonState { idle, loading, success, fail }

class ProgressButton extends StatefulWidget {
  final Map<ButtonState, Widget> stateWidgets;
  final Map<ButtonState?, Color?> stateColors;
  final Function? onPressed;
  final Function? onAnimationEnd;
  final ButtonState state;
  final double minWidth;
  final double maxWidth;
  final double height;
  final int animationMillisecondsDuration;
  final EdgeInsets buttonContentPadding;
  final ShapeBorder shape;

  const ProgressButton({
    super.key,
    required this.stateWidgets,
    required this.stateColors,
    this.state = ButtonState.idle,
    this.onPressed,
    this.onAnimationEnd,
    this.minWidth = 200.0,
    this.maxWidth = 400.0,
    this.height = kBottomBarItemsHeight,
    this.animationMillisecondsDuration = 200,
    this.buttonContentPadding = EdgeInsets.zero,
    this.shape = const StadiumBorder(),
  });

  @override
  State<StatefulWidget> createState() {
    return _ProgressButtonState();
  }

  factory ProgressButton.icon({
    required Map<ButtonState, IconedButton> iconedButtons,
    Function? onPressed,
    ButtonState state = ButtonState.idle,
    Function? animationEnd,
    double maxWidth = 170.0,
    double minWidth = 58.0,
    double height = 53.0,
    double radius = 100.0,
    double progressIndicatorSize = 35.0,
    double iconPadding = 4.0,
    TextStyle? textStyle,
    Widget? progressIndicator,
    MainAxisAlignment? progressIndicatorAligment,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    assert(
      iconedButtons.keys.toSet().containsAll(ButtonState.values.toSet()),
      'Must be non-null widgets provided in map of stateWidgets. Missing keys => ${ButtonState.values.toSet().difference(iconedButtons.keys.toSet())}',
    );

    textStyle ??=
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w500);

    final stateWidgets = <ButtonState, Widget>{
      ButtonState.idle: buildChildWithIcon(
          iconedButtons[ButtonState.idle]!, iconPadding, textStyle),
      ButtonState.loading: Column(),
      ButtonState.fail: buildChildWithIcon(
          iconedButtons[ButtonState.fail]!, iconPadding, textStyle),
      ButtonState.success: buildChildWithIcon(
          iconedButtons[ButtonState.success]!, iconPadding, textStyle)
    };

    final stateColors = <ButtonState, Color>{
      ButtonState.idle: iconedButtons[ButtonState.idle]!.color,
      ButtonState.loading: iconedButtons[ButtonState.loading]!.color,
      ButtonState.fail: iconedButtons[ButtonState.fail]!.color,
      ButtonState.success: iconedButtons[ButtonState.success]!.color,
    };

    return ProgressButton(
      stateWidgets: stateWidgets,
      stateColors: stateColors,
      state: state,
      onPressed: onPressed,
      onAnimationEnd: animationEnd,
      maxWidth: maxWidth,
      minWidth: minWidth,
      height: height,
    );
  }
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController? colorAnimationController;
  Animation<Color?>? colorAnimation;
  double? width;
  Duration? animationDuration;
  Widget? progressIndicator;

  void startAnimations(ButtonState oldState, ButtonState newState) {
    final begin = widget.stateColors[oldState];
    final end = widget.stateColors[newState];
    if (newState == ButtonState.loading) {
      width = widget.minWidth;
    } else {
      width = widget.maxWidth;
    }
    colorAnimation = ColorTween(begin: begin, end: end).animate(
      CurvedAnimation(
        parent: colorAnimationController!,
        curve: const Interval(0, 1, curve: Curves.easeIn),
      ),
    );
    colorAnimationController!.forward();
  }

  Color? get backgroundColor => colorAnimation == null
      ? widget.stateColors[widget.state]
      : colorAnimation!.value ?? widget.stateColors[widget.state];

  @override
  void initState() {
    super.initState();

    width = widget.maxWidth;

    animationDuration =
        Duration(milliseconds: widget.animationMillisecondsDuration);

    colorAnimationController =
        AnimationController(duration: animationDuration, vsync: this);
    colorAnimationController!.addStatusListener((status) {
      if (widget.onAnimationEnd != null) {
        widget.onAnimationEnd!(status, widget.state);
      }
    });
  }

  @override
  void dispose() {
    colorAnimationController!.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.state != widget.state) {
      colorAnimationController?.reset();
      startAnimations(oldWidget.state, widget.state);
    }
  }

  // ignore: avoid_positional_boolean_parameters
  Widget? getButtonChild(bool visibility) {
    final buttonChild = widget.stateWidgets[widget.state];
    if (widget.state == ButtonState.loading) {
      return widget.stateWidgets[ButtonState.loading];
    }
    return AnimatedOpacity(
      opacity: visibility ? 1.0 : 0.0,
      duration: Duration(
          milliseconds: (widget.animationMillisecondsDuration / 2).round()),
      child: buttonChild,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimationController!,
      builder: (context, child) {
        return AnimatedContainer(
          width: width,
          height: widget.height,
          duration: animationDuration!,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 3.0,
              padding: widget.buttonContentPadding,
              shape: widget.shape as OutlinedBorder?,
            ),
            onPressed: widget.state == ButtonState.idle
                ? widget.onPressed as void Function()?
                : null,
            child: getButtonChild(
                colorAnimation == null ? true : colorAnimation!.isCompleted),
          ),
        );
      },
    );
  }
}

class IconedButton {
  final String text;
  final Icon? icon;
  final Color color;

  const IconedButton({
    this.text = '',
    this.icon,
    required this.color,
  });
}

Widget buildChildWithIcon(
    IconedButton iconedButton, double iconPadding, TextStyle textStyle) {
  return buildChildWithIC(
      iconedButton.text, iconedButton.icon, iconPadding, textStyle);
}

Widget buildChildWithIC(
    String text, Icon? icon, double gap, TextStyle textStyle) {
  return Wrap(
    direction: Axis.horizontal,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: <Widget>[
      icon ?? Container(),
      Padding(padding: EdgeInsets.all(gap)),
      buildText(text, textStyle)
    ],
  );
}

Widget buildText(String text, TextStyle style) {
  return Text(text, style: style);
}
