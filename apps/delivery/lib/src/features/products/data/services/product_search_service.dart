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

import 'dart:convert';

import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/utils/firestore_json_parsing_util.dart';
import 'package:delivery/src/features/products/data/models/filter_query.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';
import 'package:delivery/src/features/sorting/data/models/sort_model.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

enum SearchMatchField { name }

class ProductsSearchService {
  static const appId = 'HUD78UFQAW';
  static const searchApiKey = '6ae06d7c4c55cbc4ac3cbfb4900c8343';

  static const searchProductsIndexName = 'dev_warehouse';
  static const searchCategoriesIndexName = 'dev_categories';

  static const indexNameAscSort = 'dev_warehouse_name_asc_sort';
  static const indexNameDescSort = 'dev_warehouse_name_desc_sort';
  static const indexPriceAscSort = 'dev_warehouse_price_asc_sort';
  static const indexPriceDescSort = 'dev_warehouse_price_desc_sort';

  static const baseUrl = 'https://$appId-dsn.algolia.net/1/indexes/';

  static const searchUrl = '$baseUrl*/queries';

  static String getFilterUrl(SortModel sortModel) {
    switch (sortModel.sortField) {
      case SortField.name:
        if (sortModel.ascending) {
          return '$baseUrl$indexNameAscSort/query';
        }
        return '$baseUrl$indexNameDescSort/query';
      case SortField.price:
        if (sortModel.ascending) {
          return '$baseUrl$indexPriceAscSort/query';
        }
        return '$baseUrl$indexPriceDescSort/query';
    }
  }

  static const Map<String, String> headers = {
    'X-Algolia-Application-Id': appId,
    'X-Algolia-API-Key': searchApiKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const encoding = 'utf-8';

  static Future<Tuple2<List<Tuple2<Map<SearchMatchField, String>, ProductModel>>, List<CategoryPlainModel>>> search(
    String searchQuery, {
    required int productsLength,
    required int categoriesLength,
  }) async {
    final res = await http.post(
      Uri.parse(searchUrl),
      headers: headers,
      body: jsonEncode({
        'requests': [
          {'indexName': searchProductsIndexName, 'params': 'query=$searchQuery&length=$productsLength&offset=0'},
          {'indexName': searchCategoriesIndexName, 'params': 'query=$searchQuery&length=$categoriesLength&offset=0'}
        ],
        'strategy': 'none'
      }),
      encoding: Encoding.getByName(encoding),
    );

    final decodedResult = json.decode(res.body);
    final productsResult = decodedResult['results'][0];
    final categoriesResult = decodedResult['results'][1];

    final List<Map<String, dynamic>> productJsons = productsResult['hits'].cast<Map<String, dynamic>>();

    final parsedProducts = await Future.wait(
      productJsons.map(
        (obj) async {
          final matches = <SearchMatchField, String>{};

          final Map<String, dynamic> highlight = obj['_highlightResult'];
          if (highlight.containsKey('name')) {
            matches[SearchMatchField.name] = highlight['name']['value'] ?? '';
          }

          final product = await FirestoreJsonParsingUtil.parseProductRaw(obj);
          return Tuple2(matches, product);
        },
      ),
    );

    final List<Map<String, dynamic>> categoriesJsons = categoriesResult['hits'].cast<Map<String, dynamic>>();
    final parsedCategories =
        categoriesJsons.map((e) => CategoryPlainModel.fromJson(e, e[CategoryPlainModel.uidField])).toList();

    return Tuple2(parsedProducts, parsedCategories);
  }

  static Future<List<ProductModel>> filterProducts(
    FilterQuery query,
    int count,
    int pageId,
    SortModel sortModel,
  ) async {
    final res = await http.post(
      Uri.parse(getFilterUrl(sortModel)),
      headers: headers,
      body: jsonEncode({'params': 'filters=${query.toString()}&hitsPerPage=$count&page=$pageId'}),
      encoding: Encoding.getByName(encoding),
    );

    final List<Map<String, dynamic>> productJsons = json.decode(res.body)['hits'].cast<Map<String, dynamic>>();
    final parsedProducts = await Future.wait(
      productJsons.map(FirestoreJsonParsingUtil.parseProductRaw),
    );
    return parsedProducts;
  }
}
