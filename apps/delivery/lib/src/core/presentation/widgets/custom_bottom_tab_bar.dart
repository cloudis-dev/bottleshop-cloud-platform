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

import 'dart:ui' show ImageFilter;

import 'package:delivery/src/config/constants.dart';
import 'package:flutter/cupertino.dart';

const Color _kDefaultTabBarBorderColor = CupertinoDynamicColor.withBrightness(
  color: Color(0x4C000000),
  darkColor: Color(0x29000000),
);
const Color _kDefaultTabBarInactiveColor = CupertinoColors.inactiveGray;

class CustomBottomTabBar extends CupertinoTabBar {
  const CustomBottomTabBar({
    Key? key,
    required List<BottomNavigationBarItem> items,
    ValueChanged<int>? onTap,
    int currentIndex = 0,
    Color? backgroundColor,
    Color? activeColor,
    Color inactiveColor = _kDefaultTabBarInactiveColor,
    double iconSize = 10.0,
    Border border = const Border(
      top: BorderSide(
        color: _kDefaultTabBarBorderColor,
        width: 0.0, // One physical pixel.
        style: BorderStyle.solid,
      ),
    ),
  }) : super(
          key: key,
          items: items,
          onTap: onTap,
          currentIndex: currentIndex,
          backgroundColor: backgroundColor,
          activeColor: activeColor,
          iconSize: iconSize,
          inactiveColor: inactiveColor,
          border: border,
        );

  @override
  Size get preferredSize => const Size.fromHeight(kTabBarHeight);

  @override
  bool opaque(BuildContext context) {
    final backgroundColor =
        this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor;
    return CupertinoDynamicColor.resolve(backgroundColor, context).alpha ==
        0xFF;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final backgroundColor = CupertinoDynamicColor.resolve(
      this.backgroundColor ?? CupertinoTheme.of(context).barBackgroundColor,
      context,
    );

    BorderSide resolveBorderSide(BorderSide side) {
      return side == BorderSide.none
          ? side
          : side.copyWith(
              color: CupertinoDynamicColor.resolve(side.color, context));
    }

    final resolvedBorder = border == null || border.runtimeType != Border
        ? border
        : Border(
            top: resolveBorderSide(border!.top),
            left: resolveBorderSide(border!.left),
            bottom: resolveBorderSide(border!.bottom),
            right: resolveBorderSide(border!.right),
          );

    final inactive = CupertinoDynamicColor.resolve(inactiveColor, context);
    Widget result = DecoratedBox(
      decoration: BoxDecoration(
        border: resolvedBorder,
        color: backgroundColor,
      ),
      child: SizedBox(
        height: kTabBarHeight + bottomPadding,
        child: IconTheme.merge(
          // Default with the inactive state.
          data: IconThemeData(color: inactive, size: iconSize),
          child: DefaultTextStyle(
            style: CupertinoTheme.of(context)
                .textTheme
                .tabLabelTextStyle
                .copyWith(color: inactive),
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomPadding),
              child: Semantics(
                explicitChildNodes: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildTabItems(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (!opaque(context)) {
      result = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: result,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildTabItems(BuildContext context) {
    final result = <Widget>[];
    final localizations = CupertinoLocalizations.of(context);

    for (var index = 0; index < items.length; index += 1) {
      final active = index == currentIndex;
      result.add(
        _wrapActiveItem(
          context,
          Expanded(
            child: Semantics(
              selected: active,
              hint: localizations.tabSemanticsLabel(
                tabIndex: index + 1,
                tabCount: items.length,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null
                    ? null
                    : () {
                        onTap!(index);
                      },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: _buildSingleTabItem(items[index], active),
                  ),
                ),
              ),
            ),
          ),
          active: active,
        ),
      );
    }

    return result;
  }

  List<Widget> _buildSingleTabItem(BottomNavigationBarItem item, bool active) {
    return <Widget>[
      Expanded(
        child: Center(child: active ? item.activeIcon : item.icon),
      ),
      if (item.label != null) Text(item.label!),
    ];
  }

  Widget _wrapActiveItem(BuildContext context, Widget item,
      {required bool active}) {
    if (!active) {
      return item;
    }

    final activeColor = CupertinoDynamicColor.resolve(
      this.activeColor ?? CupertinoTheme.of(context).primaryColor,
      context,
    );
    return IconTheme.merge(
      data: IconThemeData(color: activeColor),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: activeColor),
        child: item,
      ),
    );
  }
}
