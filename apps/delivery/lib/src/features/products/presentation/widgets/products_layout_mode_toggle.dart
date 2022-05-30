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

import 'package:delivery/src/core/data/models/preferences.dart';
import 'package:delivery/src/features/products/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsLayoutModeToggle extends HookConsumerWidget {
  const ProductsLayoutModeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layoutMode = ref.watch(productsLayoutModeProvider.state).state;
    const appIcon = Icon(Icons.apps);
    if (layoutMode == SupportedLayoutMode.grid) {
      return IconButton(
        icon: appIcon,
        onPressed: () => ref.read(productsLayoutModeProvider.state).state =
            ref.read(productsLayoutModeProvider.state).state ==
                    SupportedLayoutMode.list
                ? SupportedLayoutMode.grid
                : SupportedLayoutMode.list,
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.format_list_bulleted),
        onPressed: () => ref.read(productsLayoutModeProvider.state).state =
            ref.read(productsLayoutModeProvider.state).state ==
                    SupportedLayoutMode.list
                ? SupportedLayoutMode.grid
                : SupportedLayoutMode.list,
      );
    }
  }
}
