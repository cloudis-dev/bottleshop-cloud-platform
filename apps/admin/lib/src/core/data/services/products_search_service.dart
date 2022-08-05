import 'dart:convert';

import 'package:bottleshop_admin/src/core/utils/firestore_json_parsing_util.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

enum SearchMatchField { name }

class ProductsSearchService {
  static const appId = 'HUD78UFQAW';
  static const searchApiKey = '6ae06d7c4c55cbc4ac3cbfb4900c8343';
  static const indexName = 'dev_warehouse';

  static const url =
      'https://$appId-dsn.algolia.net/1/indexes/$indexName/query';

  static const Map<String, String> headers = {
    'X-Algolia-Application-Id': appId,
    'X-Algolia-API-Key': searchApiKey,
    'Content-Type': 'application/json; charset=UTF-8',
  };

  static const encoding = 'utf-8';

  static Future<List<Tuple2<Map<SearchMatchField, String>, ProductModel>>>
      search(
    String searchQuery,
    int length,
    int offset,
  ) async {
    final res = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(
          {'params': 'query=$searchQuery&length=$length&offset=$offset'}),
      encoding: Encoding.getByName(encoding),
    );

    final List<Map<String, dynamic>> productJsons =
        json.decode(res.body)['hits'].cast<Map<String, dynamic>>();

    final parsedProducts = await Future.wait(
      productJsons.map(
        (obj) async {
          final matches = <SearchMatchField, String>{};

          final Map<String, dynamic> highlight = obj['_highlightResult'];
          if (highlight.containsKey('name')) {
            if (highlight['name']['value'] != null) {
              matches[SearchMatchField.name] = highlight['name']['value'];
            }
          }

          final product = await FirestoreJsonParsingUtil.parseProductRaw(obj);
          return Tuple2(matches, product);
        },
      ),
    );
    return parsedProducts;
  }

  // static Future<List<ProductModel>> filterProducts(
  //     FilterQuery query,
  //     int length,
  //     int offset,
  //     ) async {
  //   final res = await http.post(
  //     url,
  //     headers: headers,
  //     body: jsonEncode({
  //       'params': 'filters=${query.toString()}&length=$length&offset=$offset'
  //     }),
  //     encoding: Encoding.getByName(encoding),
  //   );
  //
  //   print(query.toString());
  //
  //   final List<Map<String, dynamic>> productJsons =
  //   json.decode(res.body)['hits'].cast<Map<String, dynamic>>();
  //   final parsedProducts = await Future.wait(
  //     productJsons.map(FirestoreJsonParsingUtil.parseProductRaw),
  //   );
  //   return parsedProducts;
  // }
}
