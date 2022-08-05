import 'package:bottleshop_admin/src/core/presentation/widgets/active_dropdown_field.dart';
import 'package:bottleshop_admin/src/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/models/category_plain_model.dart';
import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({
    Key? key,
    required this.isSubcategory,
    required this.currentValue,
    required this.categoriesOptions,
    required this.onSaved,
    required this.validator,
  }) : super(key: key);

  final bool isSubcategory;
  final List<CategoriesTreeModel> categoriesOptions;
  final CategoryPlainModel? currentValue;
  final void Function(CategoryPlainModel?) onSaved;
  final String? Function(CategoryPlainModel?) validator;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: ActiveDropdownField(
          currentValue: currentValue,
          items: <DropdownMenuItem<CategoryPlainModel>>[
            ...categoriesOptions.map((e) =>
                DropdownMenuItem<CategoryPlainModel>(
                    value: e.categoryDetails,
                    child: Text(e.categoryDetails.localizedName.local,
                        style: const TextStyle(color: Colors.black))))
          ],
          label: isSubcategory ? '* Podkategória' : '* Kategória',
          validator: validator,
          onSaved: onSaved,
          validateInitially: true,
        ),
      );
}
