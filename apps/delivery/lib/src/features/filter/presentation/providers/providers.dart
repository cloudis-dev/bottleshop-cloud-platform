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
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/features/filter/data/models/filter_aggregations_model.dart';
import 'package:delivery/src/features/filter/presentation/viewmodels/filter_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum FilterType {
  allProducts,
  categoryProducts,
}

/// This uses autodispose to discard unapplied changes.
final filterModelProvider = StateProvider.autoDispose
    .family<FilterModel, FilterType>((ref, filterType) {
  return ref.watch(appliedFilterProvider(filterType));
});

final appliedFilterProvider = StateProvider.family<FilterModel, FilterType>(
    (_, __) => FilterModel.empty());

final filterAggregationsProvider =
    StreamProvider.autoDispose<FilterAggregationsModel>(
  (ref) {
    Future<FilterAggregationsModel> _parseFilterAggregations(
        Map<String, dynamic> data) async {
      final List<DocumentReference> countriesRefs =
          data[FilterAggregationsModel.usedCountriesFieldName]
              .cast<DocumentReference>();

      final countryDocs = await Future.wait(
        countriesRefs.map((e) async => e.get()),
      );

      data[FilterAggregationsModel.usedCountriesFieldName] = countryDocs
          .map((e) =>
              CountryModel.fromMap(e.id, e.data() as Map<String, dynamic>))
          .toList();
      return FilterAggregationsModel.fromMap(data);
    }

    return FirebaseFirestore.instance
        .collection(FirestoreCollections.aggregationsCollection)
        .doc(FirestoreCollections.filtersAggregationsDocument)
        .snapshots()
        .asyncMap(
          (event) => _parseFilterAggregations(event.data()!),
        );
  },
);
