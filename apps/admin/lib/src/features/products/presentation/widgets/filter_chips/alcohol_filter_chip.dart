import 'package:bottleshop_admin/src/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AlcoholFilterChip extends HookWidget {
  const AlcoholFilterChip({
    Key? key,
  }) : super(key: key);

  String _alcoholRangeString(RangeValues alcoholRange) =>
      '${alcoholRange.start.round()}% - ${alcoholRange.end.round()}%';

  @override
  Widget build(BuildContext context) {
    final alcoholRange = useProvider(
        productsFilterProvider.select((value) => value.alcoholRange));
    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: RichText(
          text: TextSpan(
            text: 'Alkohol ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: _alcoholRangeString(alcoholRange),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () =>
            context.read(productsFilterProvider).resetAlcoholRange(),
      ),
    );
  }
}
