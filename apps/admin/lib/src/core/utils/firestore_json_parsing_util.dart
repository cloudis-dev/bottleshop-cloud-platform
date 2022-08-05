import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/models/admin_user_model.dart';
import 'package:bottleshop_admin/src/models/categories_tree_model.dart';
import 'package:bottleshop_admin/src/models/category_model.dart';
import 'package:bottleshop_admin/src/models/category_plain_model.dart';
import 'package:bottleshop_admin/src/models/country_model.dart';
import 'package:bottleshop_admin/src/models/order_model.dart';
import 'package:bottleshop_admin/src/models/order_type_model.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';
import 'package:bottleshop_admin/src/models/unit_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class FirestoreJsonParsingUtil {
  FirestoreJsonParsingUtil._();

  /// This is used when parsing product from other
  /// data store than Firebase.
  /// (Other in the meaning of containing all json data in place).
  static Future<ProductModel> parseProductRaw(
    Map<String, dynamic> productJson,
  ) async {
    final countryDoc = await FirebaseFirestore.instance
        .collection(Constants.countriesCollection)
        .doc(productJson[ProductModel.countryRefField] as String)
        .get();
    final unitDoc = await FirebaseFirestore.instance
        .collection(Constants.unitsCollection)
        .doc(productJson[ProductModel.unitsTypeRefField] as String)
        .get();

    final List<String> categoryRefs =
        productJson[ProductModel.categoryRefsField].cast<String>();
    productJson[ProductModel.categoriesField] = await _categoriesByRefs(
      categoryRefs
          .map((e) => FirebaseFirestore.instance
              .collection(Constants.categoriesCollection)
              .doc(e))
          .toList(),
    );
    productJson[ProductModel.countryField] =
        CountryModel.fromJson(countryDoc.data()!, countryDoc.id);
    productJson[ProductModel.unitsTypeField] =
        UnitModel.fromJson(unitDoc.data()!, unitDoc.id);

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
    productJson[ProductModel.countryField] = CountryModel.fromJson(
        countryDoc.data()! as Map<String, dynamic>, countryDoc.id);
    productJson[ProductModel.unitsTypeField] =
        UnitModel.fromJson(unitDoc.data()! as Map<String, dynamic>, unitDoc.id);

    return ProductModel.fromJson(productJson);
  }

  static Future<OrderModel> parseOrderJson(
    String id,
    Map<String, dynamic> orderJson,
  ) async {
    final orderTypeDoc =
        await (orderJson[OrderModel.orderTypeRefField] as DocumentReference)
            .get();

    final preparingAdminDoc =
        await (orderJson[OrderModel.preparingAdminRefField]
                as DocumentReference?)
            ?.get();

    if (!orderTypeDoc.exists || !(preparingAdminDoc?.exists ?? true)) {
      return Future.error('Missing reference when parsing order json.');
    }

    orderJson[OrderModel.preparingAdminField] = preparingAdminDoc != null
        ? AdminUserModel.fromJson(
            preparingAdminDoc.data()! as Map<String, dynamic>,
            preparingAdminDoc.id)
        : null;
    orderJson[OrderModel.orderTypeField] = OrderTypeModel.fromJson(
        orderTypeDoc.data()! as Map<String, dynamic>, orderTypeDoc.id);
    orderJson[OrderModel.cartItemsField] = await Future.wait(
      List<Future<dynamic>>.from(
        orderJson[OrderModel.cartItemsField].map(
          (e) async {
            e[CartItemModel.productField] =
                await parseProductJson(e[CartItemModel.productField]);
            return e;
          },
        ),
      ),
    );
    return OrderModel.fromJson(orderJson, id);
  }

  static Future<List<CategoryModel>?> _categoriesByRefs(
      List<DocumentReference> refs) async {
    final docs = await Future.wait(refs.map((e) => e.get()));
    if (docs.any((element) => !element.exists)) {
      throw Exception('All categories haven\'t been found');
    }

    CategoryModel? _parseCategories(
      Iterable<DocumentSnapshot> categories,
    ) {
      if (categories.isEmpty) return null;
      final doc = categories.first;
      return CategoryModel(
        categoryDetails: CategoryPlainModel.fromJson(
            doc.data()! as Map<String, dynamic>, doc.id),
        subCategory: _parseCategories(categories.skip(1)),
      );
    }

    Iterable<int> _categoriesCounts(
      List<DocumentSnapshot> allCategories,
    ) sync* {
      if (allCategories.isEmpty) return;
      for (var i = 0; i < allCategories.length; i++) {
        if (i == 0) continue;
        if ((allCategories[i].data()! as Map<String, dynamic>)
            .containsKey(CategoriesTreeModel.isMainCategoryField)) {
          yield i;
          yield* _categoriesCounts(allCategories.skip(i).toList());
          return;
        }
      }
      yield allCategories.length;
    }

    final result =
        _categoriesCounts(docs).fold<Tuple2<int, Iterable<CategoryModel>>>(
      Tuple2(0, Iterable<CategoryModel>.empty()),
      (previousValue, element) => Tuple2(
        previousValue.item1 + element,
        previousValue.item2.followedBy(
          [_parseCategories(docs.skip(previousValue.item1).take(element))]
              .where((element) => element != null)
              .map((e) => e!),
        ),
      ),
    );

    assert(result.item1 == docs.length);

    return result.item2.toList();
  }
}
