import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StockCountFilterChip extends HookWidget {
  const StockCountFilterChip({
    super.key,
  });

  String _stockCountRangeString(RangeValues stockCount) =>
      '${stockCount.start.round()} - ${stockCount.end.round()}${stockCount.end.round() == Constants.filterMaxStock ? '+' : ''}';

  @override
  Widget build(BuildContext context) {
    final inStockCountRange = useProvider(productsFilterProvider.select(
        ((value) => value.inStockCountRange!) as RangeValues Function(
            ProductsFilterViewModel)));

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: RichText(
          text: TextSpan(
            text: 'Na sklade ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: _stockCountRangeString(inStockCountRange),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () =>
            context.read(productsFilterProvider).resetInStockCountRange(),
      ),
    );
  }
}
