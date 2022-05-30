import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:delivery/src/config/constants.dart';
import 'package:delivery/src/core/data/models/categories_tree_model.dart';
import 'package:delivery/src/core/data/models/category_model.dart';
import 'package:delivery/src/core/data/models/category_plain_model.dart';
import 'package:delivery/src/core/data/models/country_model.dart';
import 'package:delivery/src/core/data/models/unit_model.dart';
import 'package:delivery/src/features/cart/data/models/cart_item_model.dart';
import 'package:delivery/src/features/orders/data/models/order_model.dart';
import 'package:delivery/src/features/orders/data/models/order_type_model.dart';
import 'package:delivery/src/features/products/data/models/product_model.dart';

class FirestoreJsonParsingUtil {
  FirestoreJsonParsingUtil._();

  static Future<OrderModel> parseOrderJson(
    String id,
    Map<String, dynamic> orderJson,
  ) async {
    final DocumentSnapshot orderTypeDoc =
        await orderJson[OrderModelFields.orderTypeRefField].get();

    if (!orderTypeDoc.exists) {
      return Future.error('Missing reference when parsing order json.');
    }

    orderJson[OrderModelFields.orderTypeField] = OrderTypeModel.fromMap(
        orderTypeDoc.id, orderTypeDoc.data() as Map<String, dynamic>);
    orderJson[OrderModelFields.cartItemsField] = await Future.wait(
      List<Future<dynamic>>.from(
        orderJson[OrderModelFields.cartItemsField].map(
          (dynamic e) async {
            e[CartItemModel.productField] =
                await parseProductJson(e[CartItemModel.productField]);
            return e;
          },
        ),
      ),
    );
    return OrderModel.fromJson(orderJson, id);
  }

  /// This is used when parsing product from other
  /// data store than Firebase.
  /// (Other in the meaning of containing all json data in placel10n.
  static Future<ProductModel> parseProductRaw(
    Map<String, dynamic> productJson,
  ) async {
    final countryDoc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.countriesCollection)
        .doc(productJson[ProductModel.countryRefField])
        .get();
    final unitDoc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.unitsCollection)
        .doc(productJson[ProductModel.unitsTypeRefField])
        .get();

    final List<String> categoryRefs =
        productJson[ProductModel.categoryRefsField].cast<String>();
    productJson[ProductModel.categoriesField] = await _categoriesByRefs(
      categoryRefs
          .map((e) => FirebaseFirestore.instance
              .collection(FirestoreCollections.categoriesCollection)
              .doc(e))
          .toList(),
    );
    productJson[ProductModel.countryField] =
        CountryModel.fromMap(countryDoc.id, countryDoc.data()!);
    productJson[ProductModel.unitsTypeField] =
        UnitModel.fromMap(unitDoc.id, unitDoc.data()!);

    return ProductModel.fromJson(productJson);
  }

  static Future<ProductModel> parseProductJson(
    Map<String, dynamic> productJson,
  ) async {
    final DocumentSnapshot countryDoc =
        await productJson[ProductModel.countryRefField].get();
    final DocumentSnapshot? unitDoc =
        await productJson[ProductModel.unitsTypeRefField].get();

    if (!countryDoc.exists || !unitDoc!.exists) {
      return Future.error('Missing reference');
    }

    productJson[ProductModel.categoriesField] = await _categoriesByRefs(
        productJson[ProductModel.categoryRefsField].cast<DocumentReference>());
    productJson[ProductModel.countryField] = CountryModel.fromMap(
        countryDoc.id, countryDoc.data() as Map<String, dynamic>);
    productJson[ProductModel.unitsTypeField] =
        UnitModel.fromMap(unitDoc.id, unitDoc.data() as Map<String, dynamic>);

    return ProductModel.fromJson(productJson);
  }

  static Future<List<CategoryModel>> _categoriesByRefs(
      List<DocumentReference> refs) async {
    final docs = await Future.wait(refs.map((e) => e.get()));
    if (docs.any((element) => !element.exists)) {
      throw Exception('All categories haven\'t been found');
    }

    CategoryModel? _parseCategories(
      List<DocumentSnapshot> categories,
    ) {
      if (categories.isEmpty) return null;
      final doc = categories.first;
      return CategoryModel(
        categoryDetails: CategoryPlainModel.fromJson(
            doc.data() as Map<String, dynamic>, doc.id),
        subCategory: _parseCategories(categories.skip(1).toList()),
      );
    }

    Iterable<int> _categoriesCounts(
      List<DocumentSnapshot> allCategories,
    ) sync* {
      if (allCategories.isEmpty) return;
      for (var i = 0; i < allCategories.length; i++) {
        if (i == 0) continue;
        if ((allCategories[i].data() as Map)
            .containsKey(CategoriesTreeModel.isMainCategoryField)) {
          yield i;
          yield* _categoriesCounts(allCategories.skip(i).toList());
          return;
        }
      }
      yield allCategories.length;
    }

    final result =
        _categoriesCounts(docs).fold<Tuple2<int, List<CategoryModel>>>(
      Tuple2(0, List<CategoryModel>.empty()),
      (previousValue, element) => Tuple2(
        previousValue.value1 + element,
        previousValue.value2.followedBy([
          _parseCategories(
              docs.skip(previousValue.value1).take(element).toList())!
        ]).toList(),
      ),
    );

    assert(result.value1 == docs.length);

    return result.value2;
  }
}
