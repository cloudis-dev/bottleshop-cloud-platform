import 'package:bottleshop_admin/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CategoryFilterChip extends HookWidget {
  const CategoryFilterChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categoryId =
        useProvider(productsFilterProvider.select((value) => value.categoryId));

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: RichText(
          text: TextSpan(
              text: 'Kategória: ',
              style: TextStyle(color: Colors.black),
              children: [
                TextSpan(
                    text: categoryId.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () => context.read(productsFilterProvider).resetCategoryId(),
      ),
    );
  }
}
