import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/core/utils/firestore_json_parsing_util.dart';
import 'package:bottleshop_admin/src/models/order_model.dart';

final ordersDbService = DatabaseService<OrderModel>(
  Constants.ordersCollection,
  fromMapAsync: FirestoreJsonParsingUtil.parseOrderJson,
);
