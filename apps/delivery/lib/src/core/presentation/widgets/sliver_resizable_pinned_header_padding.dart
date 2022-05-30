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

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// It behaves exactly like pinned header except it can change its size on scroll.
/// When pinned it will gradually change its size up until the [maxShift].
/// It starts changing the size after scrolling threshold exceeds [shiftDelay].
class SliverResizablePinnedHeaderPadding extends SingleChildRenderObjectWidget {
  const SliverResizablePinnedHeaderPadding({
    Key? key,
    required Widget child,
    required this.maxShift,
    required this.shiftDelay,
  }) : super(key: key, child: child);

  /// This is the max shift the widget will be shifted according to scrollOffset.
  final double maxShift;

  /// After the scrollOffset will exceed the [shiftDelay] the widget will start to move.
  final double shiftDelay;

  @override
  // ignore: library_private_types_in_public_api
  _RenderSliverResizablePinnedHeaderPadding createRenderObject(
      BuildContext context) {
    return _RenderSliverResizablePinnedHeaderPadding(maxShift, shiftDelay);
  }
}

class _RenderSliverResizablePinnedHeaderPadding
    extends RenderSliverSingleBoxAdapter {
  _RenderSliverResizablePinnedHeaderPadding(this.maxShift, this.shiftDelay);

  final double maxShift;
  final double shiftDelay;

  @override
  void performLayout() {
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    late double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    geometry = SliverGeometry(
      paintExtent: childExtent +
          min(maxShift, max(0, constraints.scrollOffset - shiftDelay)),
      maxPaintExtent: childExtent +
          min(maxShift, max(0, constraints.scrollOffset - shiftDelay)),
      scrollExtent: childExtent,
      layoutExtent: 0,
    );
  }
}
