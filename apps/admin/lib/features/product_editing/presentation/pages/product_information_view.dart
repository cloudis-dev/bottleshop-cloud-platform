import 'package:bottleshop_admin/constants/app_theme.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/age_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/alcohol_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/categories/extra_categories_column.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/categories/main_category_column.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/cmat_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/count_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/country_dropdown.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/description_en_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/description_sk_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/ean_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/edition_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/name_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/price_no_vat_readonly_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/price_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/units_count_text_field.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/units_type_dropdown.dart';
import 'package:bottleshop_admin/features/product_editing/presentation/widgets/product_information_view/year_text_field.dart';
import 'package:flutter/material.dart';

class ProductInformationView extends StatelessWidget {
  static const String routeName = '/information';

  const ProductInformationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const NameTextField(),
            const EditionTextField(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const AgeTextField(),
                  const YearTextField(),
                ],
              ),
            ),
            const CmatTextField(),
            const EanTextField(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Text('Cena', style: AppTheme.headline3TextStyle),
            ),
            const PriceTextField(),
            const PriceNoVatReadonlyField(),
            const Divider(),
            const CountTextField(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const UnitsCountTextField(),
                  const UnitsTypeDropdown()
                ],
              ),
            ),
            const Divider(),
            const AlcoholTextField(subtitleStyle: AppTheme.headline3TextStyle),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: Text('Kategorizácia', style: AppTheme.headline3TextStyle),
            ),
            const MainCategoryColumn(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child:
                  Text('Extra kategórie', style: AppTheme.headline3TextStyle),
            ),
            const ExtraCategoriesColumn(),
            const Divider(),
            const CountryDropdown(),
            const DescriptionSkTextField(),
            const DescriptionEnTextField()
          ],
        ),
      );
}
