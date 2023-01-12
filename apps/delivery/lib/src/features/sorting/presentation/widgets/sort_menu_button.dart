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
import 'package:delivery/src/features/sorting/data/models/sort_model.dart';
import 'package:delivery/src/features/sorting/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum _ButtonOptions {
  ascending,
  descending,
  name,
  price,
}

class SortMenuButton extends HookConsumerWidget {
  const SortMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sortModel = ref.watch(sortModelProvider);

    return PopupMenuButton<_ButtonOptions>(
      icon: const Icon(
        Icons.sort_by_alpha,
      ),
      onSelected: (option) {
        ref.read(sortModelProvider.state).state = () {
          switch (option) {
            case _ButtonOptions.ascending:
            case _ButtonOptions.descending:
              return sortModel.copyWith(
                  ascending: option == _ButtonOptions.ascending);
            case _ButtonOptions.name:
              return sortModel.copyWith(sortField: SortField.name);
            case _ButtonOptions.price:
              return sortModel.copyWith(sortField: SortField.price);
          }
        }();
      },
      itemBuilder: (context) => <PopupMenuEntry<_ButtonOptions>>[
        _MenuItem(
          value: _ButtonOptions.ascending,
          text: context.l10n.sortAscending,
          isChecked: sortModel.ascending,
        ),
        _MenuItem(
          value: _ButtonOptions.descending,
          text: context.l10n.sortDescending,
          isChecked: !sortModel.ascending,
        ),
        const PopupMenuDivider(),
        _MenuItem(
          value: _ButtonOptions.name,
          text: context.l10n.name,
          isChecked: sortModel.sortField == SortField.name,
        ),
        _MenuItem(
          value: _ButtonOptions.price,
          text: context.l10n.price,
          isChecked: sortModel.sortField == SortField.price,
        ),
      ],
    );
  }
}

class _MenuItem<T> extends PopupMenuItem<T> {
  _MenuItem({
    T? value,
    required String text,
    required bool isChecked,
  }) : super(
          value: value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(text),
              ),
              if (isChecked) const Icon(Icons.check),
            ],
          ),
        );
}
