import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const _widthFactor = .8;

class PageBodyTemplate extends StatelessWidget {
  final Widget child;

  @literal
  const PageBodyTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: FractionallySizedBox(
        widthFactor: _widthFactor,
        child: child,
      ),
    );
  }
}

class PageBodyTemplateSliver extends StatelessWidget {
  final Widget sliver;

  const PageBodyTemplateSliver({Key? key, required this.sliver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: width * (1 - _widthFactor) / 2),
      sliver: sliver,
    );
  }
}
