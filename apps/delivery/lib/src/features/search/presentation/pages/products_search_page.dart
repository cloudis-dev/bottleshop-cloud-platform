// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:delivery/l10n/l10n.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/presentation/providers/core_providers.dart';
import 'package:delivery/src/core/presentation/providers/navigation_providers.dart';
import 'package:delivery/src/core/presentation/widgets/empty_tab.dart';
import 'package:delivery/src/core/presentation/widgets/search_bar.dart';
import 'package:delivery/src/core/utils/screen_adaptive_utils.dart';
import 'package:delivery/src/features/home/presentation/widgets/templates/page_body_template.dart';
import 'package:delivery/src/features/products/data/services/product_search_service.dart';
import 'package:delivery/src/features/products/presentation/widgets/product_list_item.dart';
import 'package:delivery/src/features/search/presentation/providers/providers.dart';
import 'package:delivery/src/features/search/presentation/widgets/searched_category_list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:routeborn/routeborn.dart';

const _debounceMs = 750;
const _maxProductsResults = 10;
const _maxCategoriesResults = 3;

final _searchBarFocusNode = FocusNode();

final _searchEditingCtrlProvider =
    Provider.autoDispose((_) => TextEditingController());

final _logger = Logger((ProductsSearchPage).toString());

class ProductsSearchPage extends RoutebornPage {
  static const String pagePathBase = 'search';

  ProductsSearchPage()
      : super.builder(pagePathBase, (_) => _ProductsSearchPageView());

  @override
  Either<ValueListenable<String?>, String> getPageName(BuildContext context) =>
      Right(context.l10n.search);

  @override
  String getPagePath() => pagePathBase;

  @override
  String getPagePathBase() => pagePathBase;
}

class _ProductsSearchPageView extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This is to preserve state
    ref.watch(debounceTimerProvider);
    ref.watch(lastQueriedSearchTimeProvider);
    ref.watch(previousQuery);

    return const _PageScaffold();
  }
}

class _PageScaffold extends HookConsumerWidget {
  const _PageScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldStateKey = useMemoized(() => GlobalKey<ScaffoldState>());
    final searchEditingController = ref.watch(_searchEditingCtrlProvider);

    final body = _Body(scaffoldStateKey: scaffoldStateKey);

    return Scaffold(
      key: scaffoldStateKey,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            ref.read(navigationProvider).setNestingBranch(
                  context,
                  RoutebornBranchParams.of(context).getBranchParam()
                          as NestingBranch? ??
                      NestingBranch.shop,
                );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: SearchBar(
          autoFocus: true,
          showFilter: false,
          onChangedCallback: (query) => _onSearchChanged(
            scaffoldStateKey.currentState,
            context,
            query,
          ),
          focusNode: _searchBarFocusNode,
          editingController: searchEditingController,
        ),
      ),
      body:
          shouldUseMobileLayout(context) ? body : PageBodyTemplate(child: body),
    );
  }
}

class _Body extends HookConsumerWidget {
  final GlobalKey<ScaffoldState> scaffoldStateKey;

  const _Body({Key? key, required this.scaffoldStateKey}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState =
        ref.watch(searchResultsProvider.select((value) => value.value1));

    switch (searchState) {
      case SearchState.cleaned:
        return EmptyTab(
          icon: Icons.search,
          message: context.l10n.hitTheSearch,
          buttonMessage: context.l10n.startSearching,
          onButtonPressed: () =>
              FocusScope.of(context).requestFocus(_searchBarFocusNode),
        );
      case SearchState.typing:
        return Container();
      case SearchState.waiting:
        return const LinearProgressIndicator();
      case SearchState.completed:
        return const _ResultsWidget();
      case SearchState.error:
        return EmptyTab(
          icon: Icons.error_outline,
          message: context.l10n.upsSomethingWentWrong,
          buttonMessage: context.l10n.tryAgain,
          onButtonPressed: () => _onSearchChanged(
            scaffoldStateKey.currentState,
            context,
            ref.read(_searchEditingCtrlProvider).text,
          ),
        );
    }
  }
}

class _ResultsWidget extends HookConsumerWidget {
  const _ResultsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(
      searchResultsProvider
          .select((value) => Tuple2(value.value2, value.value3)),
    );

    if (searchResults.value1.isEmpty && searchResults.value2.isEmpty) {
      return EmptyTab(
        icon: Icons.block_rounded,
        message: context.l10n.noSuchItems,
        buttonMessage: context.l10n.searchAgain,
        onButtonPressed: () {
          // Scaffold.of(context).
          ref.read(_searchEditingCtrlProvider).clear();
          ref.read(searchResultsProvider.state).state =
              const Tuple3(SearchState.cleaned, [], []);
          FocusScope.of(context).requestFocus(_searchBarFocusNode);
        },
      );
    } else {
      final categories = ref.watch(
          commonDataRepositoryProvider.select((value) => value.categories));

      final searchedCategoryItems = searchResults.value2.map(
        (searchedCategory) => Tuple2(
          categories.firstWhere(
            (element) => CategoriesTreeModel.getAllCategoryPlainModels(element)
                .map((e) => e.id)
                .contains(searchedCategory.id),
            orElse: null,
          ),
          searchedCategory,
        ),
      );

      return ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ...searchedCategoryItems.map(
            (e) => SearchedCategoryListItem(
              categoryPlainModel: e.value2,
              navigationCategory: e.value1,
              heroTag: '${e.value1.categoryDetails.id}_categorySearch',
            ),
          ),
          ...searchResults.value1
              .map<Widget>(
                (e) => ProductListItem(
                  product: e.value2,
                  nameTextSpans: parseMatchToTextSpans(
                    e.value1[SearchMatchField.name]!,
                  ),
                ),
              )
              .toList()
        ],
      );
    }
  }
}

void _onSearchChanged(
  ScaffoldState? pageScaffoldState,
  BuildContext context,
  String query,
) async {
  /// This is to prevent continuing in search processing
  /// in case the widget is not in widget tree
  WidgetRef _getContext() {
    if (pageScaffoldState == null || !pageScaffoldState.mounted) {
      throw _OutOfWidgetTreeException();
    }
    return context as WidgetRef;
  }

  query = query.trim();

  if (_getContext().read(previousQuery) == query) {
    return;
  } else {
    _getContext().read(previousQuery.state).state = query;
  }

  try {
    final currentTime = DateTime.now();
    _getContext().read(lastQueriedSearchTimeProvider.state).state = currentTime;

    _getContext().read(debounceTimerProvider)?.cancel();

    if (query.isEmpty) {
      _getContext().read(searchResultsProvider.state).state =
          const Tuple3(SearchState.cleaned, [], []);
    } else {
      _getContext().read(searchResultsProvider.state).state =
          const Tuple3(SearchState.typing, [], []);

      _getContext().read(debounceTimerProvider.state).state = Timer(
        const Duration(milliseconds: _debounceMs),
        () async {
          try {
            bool isLastQueryMade() {
              final lastQueriedTime =
                  _getContext().read(lastQueriedSearchTimeProvider.state).state;
              return lastQueriedTime == currentTime;
            }

            if (!isLastQueryMade()) {
              return;
            }

            _getContext().read(searchResultsProvider.state).state =
                const Tuple3(SearchState.waiting, [], []);

            final res = await ProductsSearchService.search(
              query,
              productsLength: _maxProductsResults,
              categoriesLength: _maxCategoriesResults,
            );

            // Only shows the results when this was the last search query made
            if (!isLastQueryMade()) {
              return;
            }

            _getContext().read(searchResultsProvider.state).state = Tuple3(
              SearchState.completed,
              res.value1,
              res.value2,
            );
          } on _OutOfWidgetTreeException catch (_) {
            return;
          } catch (err, stack) {
            _getContext().read(searchResultsProvider.state).state =
                const Tuple3(SearchState.error, [], []);

            _logger.severe('Search failed', err, stack);
          }
        },
      );
    }
  } on _OutOfWidgetTreeException catch (_) {
    return;
  } catch (err, stack) {
    _getContext().read(searchResultsProvider.state).state =
        const Tuple3(SearchState.error, [], []);

    _logger.severe('search failed', err, stack);
  }
}

List<TextSpan> parseMatchToTextSpans(String match) {
  final splits = match.split('<em>');

  final res = Iterable<int>.generate(splits.length)
      .map(
        (id) {
          final tmp = splits[id].split('</em>');
          if (tmp.length == 1) {
            return [Tuple2(false, tmp.first)];
          }

          return Iterable<int>.generate(tmp.length).map((e) => Tuple2(
                e % 2 == 0,
                tmp[e].replaceFirst('</em>', ''),
              ));
        },
      )
      .expand((element) => element)
      .toList();

  return res
      .map(
        (e) => TextSpan(
          text: e.value2,
          style: TextStyle(
            fontWeight: e.value1 ? FontWeight.w900 : FontWeight.normal,
          ),
        ),
      )
      .toList();
}

/// This is thrown when the timer hits in time
/// when the search page is not there anymore.
class _OutOfWidgetTreeException implements Exception {}
