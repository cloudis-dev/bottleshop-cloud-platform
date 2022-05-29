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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/repositories/common_data_repository.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final categoryProvider = FutureProvider.autoDispose.family<CategoriesTreeModel, String>(
  (ref, uid) {
    final categories = ref.watch(commonDataRepositoryProvider.select((value) => value.data.categories));
    return categories.firstWhere((element) => element.categoryDetails.id == uid);
  },
);

final mainCategoriesWithoutExtraProvider = StateProvider.autoDispose<List<CategoriesTreeModel>>(
  (ref) => ref
      .watch(commonDataRepositoryProvider.select((value) => value.data.categories))
      .where((element) => !element.categoryDetails.isExtraCategory)
      .toList(),
  name: 'mainCategoriesWithoutExtraProvider',
);

final categoryProductCountsProvider = StreamProvider.autoDispose<CategoryProductCountsModel>((ref) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.aggregationsCollection)
      .doc(FirestoreCollections.categoryProductCountsAggregationsDocument)
      .snapshots()
      .map((event) => CategoryProductCountsModel.fromMap(event.data()!));
});

@immutable
class CategoryProductCountsModel {
  final Map<String, int> _productCounts;

  CategoryProductCountsModel.fromMap(Map<String, dynamic> map) : _productCounts = Map<String, int>.from(map);

  int? getProductsCount(String? categoryId) {
    if (_productCounts.containsKey(categoryId)) {
      return _productCounts[categoryId!];
    }
    return 0;
  }
}
