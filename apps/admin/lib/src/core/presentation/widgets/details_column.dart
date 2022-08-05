import 'package:bottleshop_admin/src/config/app_theme.dart';
import 'package:bottleshop_admin/src/core/presentation/widgets/detail_text.dart';
import 'package:bottleshop_admin/src/core/utils/formatting_util.dart';
import 'package:bottleshop_admin/src/models/category_model.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:flutter/material.dart';

class DetailsColumn extends StatelessWidget {
  final ProductModel? product;

  const DetailsColumn({Key? key, required this.product}) : super(key: key);

  Iterable<Widget> _productDetailsWidgets(ProductModel product) sync* {
    final subtitleTheme = AppTheme.subtitle1TextStyle;
    yield Text(product.name, style: AppTheme.headline1TextStyle);

    if (product.edition != null) {
      yield DetailText(
          title: 'Edícia: ', value: product.edition, theme: subtitleTheme);
    }

    yield DetailText(
        title: 'CMAT: ', value: product.cmat, theme: subtitleTheme);
    yield DetailText(title: 'EAN: ', value: product.ean, theme: subtitleTheme);

    if (product.year != null) {
      yield DetailText(
          title: 'Rok: ', value: '${product.year}', theme: subtitleTheme);
    }

    if (product.age != null) {
      yield DetailText(
          title: 'Vek: ', value: '${product.age}r', theme: subtitleTheme);
    }

    yield DetailText(
        title: '',
        value:
            '${FormattingUtil.getUnitValueString(product.unitsCount)} ${product.unitsType!.localizedAbbreviation.local}',
        theme: subtitleTheme);

    for (var i = 0; i < product.allCategories.length; i++) {
      yield DetailText(
          title: i == 0 ? 'Kategória: ' : 'Extra kategória: ',
          value: CategoryModel.allLocalizedNames(product.allCategories[i])
              .join(' - '),
          theme: subtitleTheme);
    }

    if (product.hasAlcohol) {
      yield DetailText(
          title: 'Alkohol: ',
          value: '${FormattingUtil.getAlcoholNumberString(product.alcohol)}%',
          theme: subtitleTheme);
    }

    if (product.country != null) {
      yield DetailText(
          title: 'Krajina: ',
          value: product.country!.localizedName.local,
          theme: subtitleTheme);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[..._productDetailsWidgets(product!)],
      );
}
