import 'package:bottleshop_admin/src/features/products/presentation/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DiscountFilterChip extends HookWidget {
  const DiscountFilterChip({
    Key? key,
  }) : super(key: key);

  String _discountRangeString(RangeValues discountRange) =>
      '${discountRange.start.round()}% - ${discountRange.end.round()}%';

  @override
  Widget build(BuildContext context) {
    final discountRange = useProvider(
      productsFilterProvider.select((value) => value.discountRange!),
    );

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: RichText(
          text: TextSpan(
              text: 'Zľava ',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                    text: _discountRangeString(discountRange),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () =>
            context.read(productsFilterProvider).resetDiscountRange(),
      ),
    );
  }
}
