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

import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/core/utils/firestore_json_parsing_util.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';

class CartContentService extends DatabaseService<CartRecord> {
  CartContentService(UserModel user)
      : super(
          FirestorePaths.userCartContent(user.uid),
          fromMapAsync: (id, data) async => CartRecord.fromMap(data),
          toMap: (cartRecord) => cartRecord.toMap(),
        );

  Future<List<CartItemModel>> _itemsTransformation(List<CartRecord> items) =>
      Future.wait(
        items.map(
          (item) async {
            final data = await item.productRef.get();
            final product = await FirestoreJsonParsingUtil.parseProductJson(
              data.data() as Map<String, dynamic>,
            );
            return CartItemModel(
              count: item.quantity,
              product: product,
              paidPrice: product.finalPrice,
            );
          },
        ),
      ).then(
        (value) => value.toList(),
      );

  Stream<List<CartItemModel>> streamCartItems() {
    return streamList().asyncMap(
      (event) => _itemsTransformation(event),
    );
  }

  Future<List<CartItemModel>> getCartItems() {
    return getQueryList().then(
      (event) => _itemsTransformation(event),
    );
  }
}
