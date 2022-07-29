import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/core/utils/firestore_json_parsing_util.dart';
import 'package:bottleshop_admin/models/product_model.dart';

final productsDbService = DatabaseService<ProductModel>(
  Constants.productsCollection,
  fromMapAsync: (_, data) => FirestoreJsonParsingUtil.parseProductJson(data),
);
