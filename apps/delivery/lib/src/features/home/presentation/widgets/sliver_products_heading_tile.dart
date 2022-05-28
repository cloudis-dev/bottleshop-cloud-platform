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

import 'package:delivery/src/features/products/presentation/widgets/products_layout_mode_toggle.dart';
import 'package:delivery/src/features/sorting/presentation/widgets/sort_menu_button.dart';
import 'package:flutter/material.dart';

class SliverProductsHeadingTile extends StatelessWidget {
  const SliverProductsHeadingTile({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 0),
        title: Text(title!, style: Theme.of(context).textTheme.headline6),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const <Widget>[ProductsLayoutModeToggle(), SortMenuButton()],
        ),
      ),
    );
  }
}
