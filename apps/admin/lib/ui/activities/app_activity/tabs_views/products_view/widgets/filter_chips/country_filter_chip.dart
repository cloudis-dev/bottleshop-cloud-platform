import 'package:bottleshop_admin/view_models/products_filter_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CountryFilterChip extends HookWidget {
  const CountryFilterChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final countryId =
        useProvider(productsFilterProvider.select((value) => value.countryId));

    return Container(
      padding: const EdgeInsets.only(left: 8),
      child: Chip(
        label: RichText(
          text: TextSpan(
            text: 'Krajina: ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                  text: countryId.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        deleteIcon: Icon(Icons.cancel),
        deleteIconColor: Colors.black54,
        onDeleted: () => context.read(productsFilterProvider).resetCountryId(),
      ),
    );
  }
}
