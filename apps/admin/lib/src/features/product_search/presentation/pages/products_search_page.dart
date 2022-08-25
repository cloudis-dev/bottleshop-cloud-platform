import 'package:bottleshop_admin/src/core/app_page.dart';
import 'package:bottleshop_admin/src/core/utils/iterable_extension.dart';
import 'package:bottleshop_admin/src/features/product_search/presentation/providers/providers.dart';
import 'package:bottleshop_admin/src/features/product_search/widgets/search_bar.dart';
import 'package:bottleshop_admin/src/features/product_search/widgets/search_result_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductsSearchPage extends AppPage {
  ProductsSearchPage()
      : super(
          '/product/search',
          (_) => _ProductsSearchView(),
        );
}

class _ProductsSearchView extends HookWidget {
  _ProductsSearchView({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final searchRes = useProvider(searchResultsProvider).state;

    return Scaffold(
      key: scaffoldStateKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Builder(
          builder: (context) => SearchBar(
            pageScaffoldState: scaffoldStateKey.currentState,
          ),
        ),
      ),
      body: searchRes.when(
        data: (items) => ListView(
          scrollDirection: Axis.vertical,
          children: items
              .map<Widget>((e) => SearchResultItem(e))
              .interleave(const Divider(
                height: 1,
              ))
              .toList(),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: SizedBox(
            height: 100,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        error: (err, _) => Text(err.toString()),
      ),
    );
  }
}
