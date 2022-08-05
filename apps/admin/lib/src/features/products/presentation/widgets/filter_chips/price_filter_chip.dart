import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PriceFilterChip extends HookWidget {
  const PriceFilterChip({
    Key? key,
  }) : super(key: key);

  String _priceRangeString(RangeValues priceRange) {
    return '€${priceRange.start.round()} - €${priceRange.end.round()}${priceRange.end.round() == Constants.filterMaxPrice ? '+' : ''}';
  }

  @override
  Widget build(BuildContext context) {
    final priceRange =
        useProvider(productsFilterProvider.select((value) => value.priceRange));

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: Text(
          _priceRangeString(priceRange),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () => context.read(productsFilterProvider).resetPriceRange(),
      ),
    );
  }
}
