import 'package:bottleshop_admin/src/core/presentation/widgets/product_card_all_actions_menu_button.dart';
import 'package:bottleshop_admin/src/features/product_search/data/services/products_search_service.dart';
import 'package:bottleshop_admin/src/features/products/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class SearchResultItem extends StatelessWidget {
  SearchResultItem(this.productSearchRes, {Key? key}) : super(key: key);

  final Tuple2<Map<SearchMatchField, String>, ProductModel> productSearchRes;

  final TextStyle titleStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontWeight: FontWeight.normal,
  );

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      iconColor: Colors.black,
      child: ListTile(
        title: productSearchRes.item1.containsKey(SearchMatchField.name)
            ? parseMatchToWidget(
                productSearchRes.item1[SearchMatchField.name] ?? '')
            : Text(
                productSearchRes.item2.name,
                style: titleStyle,
                overflow: TextOverflow.ellipsis,
              ),
        subtitle: Text(
          'CMAT: ${productSearchRes.item2.cmat}',
        ),
        trailing:
            ProductCardAllActionsMenuButton(product: productSearchRes.item2),
      ),
    );
  }

  Widget parseMatchToWidget(String match) {
    final splits = match.split('<em>');

    final res = Iterable<int>.generate(splits.length)
        .map(
          (id) {
            final tmp = splits[id].split('<\/em>');
            if (tmp.length == 1) {
              return [Tuple2(false, tmp.first)];
            }

            return Iterable<int>.generate(tmp.length).map((e) => Tuple2(
                  e % 2 == 0,
                  tmp[e].replaceFirst('<\/em>', ''),
                ));
          },
        )
        .expand((element) => element)
        .toList();

    return Text.rich(
      TextSpan(
        text: res[0].item2,
        style: titleStyle.copyWith(
          fontWeight: res[0].item1 ? FontWeight.bold : FontWeight.normal,
        ),
        children: res
            .sublist(1)
            .map(
              (e) => TextSpan(
                text: e.item2,
                style: titleStyle.copyWith(
                  fontWeight: e.item1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )
            .toList(),
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
