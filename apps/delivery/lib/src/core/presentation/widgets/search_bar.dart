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

import 'package:delivery/l10n/l10n.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final bool showFilter;
  final ScaffoldState? showFilterDrawerScaffoldState;
  final FocusNode? focusNode;
  final TextEditingController? editingController;
  final bool autoFocus;

  final void Function(String query)? onChangedCallback;

  const SearchBar({
    Key? key,
    required this.showFilter,
    this.showFilterDrawerScaffoldState,
    this.onChangedCallback,
    this.focusNode,
    this.editingController,
    this.autoFocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.30),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            TextField(
              controller: editingController,
              focusNode: focusNode,
              autofocus: true,
              onChanged: onChangedCallback,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
                hintText: context.l10n.search,
                prefixIcon: Hero(
                  tag: UniqueKey(),
                  child: Icon(
                    Icons.search,
                    size: 20,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                ),
                border: const UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    const UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
