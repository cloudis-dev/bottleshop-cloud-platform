import 'package:bottleshop_admin/src/core/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/core/utils/snackbar_utils.dart';
import 'package:bottleshop_admin/src/features/backdrop/backdrop.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/pages/product_edit_page.dart';
import 'package:bottleshop_admin/src/features/product_editing/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_search/pages/products_search_page.dart';
import 'package:bottleshop_admin/src/features/products/presentation/widgets/products_list.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsView extends StatelessWidget {
  static const String routeName = '/products';

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // static const double _backdropHeaderHeight = 76;
  static const double _backdropHeaderHeight = 48;

  ProductsView({Key? key}) : super(key: key);

  Widget _backLayer() =>
//    final textStyle = TextStyle(fontSize: 16, color: Colors.white);
      Container();
//    return Container(
//        margin: const EdgeInsets.only(bottom: _backdropHeaderHeight),
//        child: ListView(
//          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//          children: <Widget>[
//            RichText(
//              text:
//                  TextSpan(text: 'Cenový rozsah ', style: textStyle, children: [
//                TextSpan(
//                    text: '${productsFilter.priceRangeString}',
//                    style: TextStyle(fontWeight: FontWeight.bold))
//              ]),
//            ),
//            Container(
//                color: Theme.of(context).primaryColor,
//                child: RangeSlider(
//                    activeColor: Colors.white,
//                    inactiveColor: Colors.white38,
//                    values: productsFilter.priceRange,
//                    min: 0,
//                    max: 500,
//                    divisions: 20,
//                    onChanged: (value) =>
//                        setState(() => productsFilter.priceRange = value))),
//            Divider(
//              color: Colors.white24,
//            ),
//            Text(
//              'Kategória',
//              style: textStyle,
//            ),
//            Container(
//                margin: const EdgeInsets.only(top: 8),
//                padding: const EdgeInsets.only(left: 16, right: 8),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.circular(8),
//                ),
//                child: DropdownButtonHideUnderline(
//                    child: DropdownButton<int>(
//                  isExpanded: true,
//                  value: productsFilter.categoryId,
//                  items: <DropdownMenuItem<int>>[
//                    ...Iterable<int>.generate(widget.categories.length)
//                        .map((e) => DropdownMenuItem(
//                            value: e,
//                            child: Text(widget.categories[e],
//                                style: TextStyle(color: Colors.black))))
//                        .toList()
//                  ],
//                  onChanged: (value) =>
//                      setState(() => productsFilter.categoryId = value),
//                ))),
//            Divider(
//              color: Colors.white24,
//            ),
//            RichText(
//              text: TextSpan(
//                  text: 'Obsah alkoholu ',
//                  style: textStyle,
//                  children: [
//                    TextSpan(
//                        text: '${productsFilter.alcoholRangeString}',
//                        style: TextStyle(fontWeight: FontWeight.bold))
//                  ]),
//            ),
//            Container(
//                color: Theme.of(context).primaryColor,
//                child: RangeSlider(
//                    activeColor: Colors.white,
//                    inactiveColor: Colors.white38,
//                    values: productsFilter.alcoholRange,
//                    min: 0,
//                    max: 100,
//                    divisions: 20,
//                    onChanged: (value) =>
//                        setState(() => productsFilter.alcoholRange = value))),
//            Divider(
//              color: Colors.white24,
//            ),
//            Text(
//              'Krajina pôvodu',
//              style: textStyle,
//            ),
//            Container(
//                margin: const EdgeInsets.only(top: 8),
//                padding: const EdgeInsets.only(left: 16, right: 8),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                  borderRadius: BorderRadius.circular(8),
//                ),
//                child: DropdownButtonHideUnderline(
//                    child: DropdownButton<int>(
//                  isExpanded: true,
//                  value: productsFilter.countryId,
//                  items: <DropdownMenuItem<int>>[
//                    ...Iterable<int>.generate(widget.countries.length)
//                        .map((e) => DropdownMenuItem(
//                            value: e,
//                            child: Text(widget.countries[e],
//                                style: TextStyle(color: Colors.black))))
//                        .toList()
//                  ],
//                  onChanged: (value) =>
//                      setState(() => productsFilter.countryId = value),
//                ))),
//            Divider(
//              color: Colors.white24,
//            ),
//            RichText(
//              text: TextSpan(
//                  text: 'Počet kusov na sklade ',
//                  style: textStyle,
//                  children: [
//                    TextSpan(
//                        text: '${productsFilter.inStockCountRangeString}',
//                        style: TextStyle(fontWeight: FontWeight.bold))
//                  ]),
//            ),
//            Container(
//                color: Theme.of(context).primaryColor,
//                child: RangeSlider(
//                    activeColor: Colors.white,
//                    inactiveColor: Colors.white38,
//                    values: productsFilter.inStockCountRange,
//                    min: 0,
//                    max: 50,
//                    divisions: 10,
//                    onChanged: (value) => setState(
//                        () => productsFilter.inStockCountRange = value))),
//            Divider(
//              color: Colors.white24,
//            ),
//            RichText(
//              text: TextSpan(text: 'Zľava ', style: textStyle, children: [
//                TextSpan(
//                    text: '${productsFilter.discountRangeString}',
//                    style: TextStyle(fontWeight: FontWeight.bold))
//              ]),
//            ),
//            Container(
//                color: Theme.of(context).primaryColor,
//                child: RangeSlider(
//                    activeColor: Colors.white,
//                    inactiveColor: Colors.white38,
//                    values: productsFilter.discountRange,
//                    min: 0,
//                    max: 100,
//                    divisions: 10,
//                    onChanged: (value) =>
//                        setState(() => productsFilter.discountRange = value))),
//          ],
//        ));

  Widget _backdropSubHeader() => BackdropSubHeader(
        padding: EdgeInsets.all(0),
        automaticallyImplyTrailing: false,
        divider: Container(),
        title: Material(
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                  child: Text('Zoradené produkty')),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                // height: 32,
                // child: ListView(
                //   scrollDirection: Axis.horizontal,
                //   children: <Widget>[
                //     Container(
                //       padding: const EdgeInsets.only(left: 8),
                //     ),
                //     Container(
                //         padding: const EdgeInsets.only(left: 8),
                //         child: Chip(
                //           avatar: Icon(
                //             Icons.search,
                //             color: Colors.black54,
                //           ),
                //           label: Text('Hello'),
                //           deleteIcon: Icon(Icons.cancel),
                //           deleteIconColor: Colors.black54,
                //           onDeleted: () => {print('Delete')},
                //         )),
                //     const PriceFilterChip(),
                //     const AlcoholFilterChip(),
                //     const CategoryFilterChip(),
                //     const CountryFilterChip(),
                //     const StockCountFilterChip(),
                //     const DiscountFilterChip(),
                //     const Padding(
                //       padding: EdgeInsets.only(right: 8),
                //     ),
                //   ],
                // ),
              )
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        key: scaffoldMessengerKey,
        child: BackdropScaffold(
          subHeaderAlwaysActive: true,
          appBar: BackdropAppBar(
            title: Text('Produkty'),
            leading: BackdropToggleButton(
              icon: AnimatedIcons.close_menu,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  context
                      .read(navigationProvider.notifier)
                      .pushPage(ProductsSearchPage());
                },
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () =>
                    context.read(navigationProvider.notifier).pushPage(
                          ProductEditPage(
                            productAction: ProductAction.creating,
                            onPopped: (res) => res != null
                                ? SnackBarUtils.showResultMessageSnackbar(
                                    scaffoldMessengerKey.currentState,
                                    res,
                                  )
                                : null,
                          ),
                        ),
              )
            ],
          ),
          headerHeight: _backdropHeaderHeight,
          backLayer: _backLayer(),
          subHeader: _backdropSubHeader(),
          frontLayer: const ProductsList(),
        ),
      );
}
