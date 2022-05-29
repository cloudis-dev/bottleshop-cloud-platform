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

import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/core/utils/firestore_json_parsing_util.dart';
import 'package:delivery/src/features/auth/data/models/device_model.dart';
import 'package:delivery/src/features/auth/data/models/user_model.dart';
import 'package:delivery/src/features/home/data/models/favorite_item_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';

DatabaseService<UserModel> userDb = DatabaseService<UserModel>(
  FirestoreCollections.usersCollection,
  toMap: (user) => user.toMap(),
  fromMapAsync: (id, data) async => UserModel.fromMap(id, data),
);

UserDeviceDBService userDeviceDb =
    UserDeviceDBService(FirestoreCollections.userDevicesSubCollection);

class UserDeviceDBService extends DatabaseService<Device> {
  UserDeviceDBService(String collection)
      : super(collection,
            fromMapAsync: (id, data) async => Device.fromMap(id, data),
            toMap: (device) => device.toMap());
}

class WishListDBService extends DatabaseService<FavoriteItemModel> {
  WishListDBService(String collection)
      : super(collection,
            fromMapAsync: (id, data) async => FavoriteItemModel.fromMap(data),
            toMap: (favoriteItemModel) => favoriteItemModel.toMap());

  Stream<List<ProductModel>> getWishListStream() {
    return streamList().asyncMap((refList) async {
      final list = refList.map((e) => e.product!.get()).toList();
      return Future.wait(list);
    }).asyncMap((event) {
      return Future.wait(
        event.where((value) => value.exists).map((e) {
          return FirestoreJsonParsingUtil.parseProductJson(
              e.data() as Map<String, dynamic>);
        }),
      );
    });
  }
}
