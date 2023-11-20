import 'dart:async';

import 'package:bottleshop_admin/src/features/product_search/data/services/products_search_service.dart';
import 'package:bottleshop_admin/src/features/product_search/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _debounceMs = 750;
const _maxResults = 10;

class SearchBar extends HookWidget {
  final ScaffoldState? pageScaffoldState;

  const SearchBar({
    super.key,
    required this.pageScaffoldState,
  });

  @override
  Widget build(context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[
        TextField(
          onChanged: (query) {
            /// This is to prevent continuing in search processing
            /// in case the widget is not in widget tree
            getContext() {
              if (pageScaffoldState == null) {
                throw Exception();
              }
              return pageScaffoldState!.context;
            }

            try {
              if (query.trim().isEmpty) {
                getContext().read(searchResultsProvider).state =
                    AsyncValue.data([]);
              } else {
                final currentTime = DateTime.now();
                getContext().read(lastQueriedSearchTimeProvider).state =
                    currentTime;

                getContext().read(searchResultsProvider).state =
                    AsyncValue.data([]);

                getContext().read(debounceTimerProvider).state?.cancel();
                getContext().read(debounceTimerProvider).state = Timer(
                  const Duration(milliseconds: _debounceMs),
                  () async {
                    try {
                      getContext().read(searchResultsProvider).state =
                          AsyncValue.loading();
                      final res = await ProductsSearchService.search(
                          query, _maxResults, 0);

                      // Only show the results when this was the last search query made
                      if (getContext()
                              .read(lastQueriedSearchTimeProvider)
                              .state ==
                          currentTime) {
                        getContext().read(searchResultsProvider).state =
                            AsyncValue.data(res);
                      }
                    } catch (err) {
                      debugPrint(err.toString());
                      return;
                    }
                  },
                );
              }
            } catch (err) {
              debugPrint(err.toString());
              return;
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.all(12),
            hintText: 'Search',
            // hintStyle: TextStyle(
            //     color: Theme.of(context).focusColor.withOpacity(0.8)),
            // prefixIcon: Icon(
            //   Icons.search,
            //   size: 20,
            // ),
            border: UnderlineInputBorder(borderSide: BorderSide.none),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
