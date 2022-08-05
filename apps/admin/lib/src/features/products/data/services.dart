import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/utils/firestore_json_parsing_util.dart';
import 'package:bottleshop_admin/src/models/product_model.dart';

final productsDbService = DatabaseService<ProductModel>(
  Constants.productsCollection,
  fromMapAsync: (_, data) => FirestoreJsonParsingUtil.parseProductJson(data),
);
