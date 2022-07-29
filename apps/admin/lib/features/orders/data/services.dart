import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/core/utils/firestore_json_parsing_util.dart';
import 'package:bottleshop_admin/models/order_model.dart';

final ordersDbService = DatabaseService<OrderModel>(
  Constants.ordersCollection,
  fromMapAsync: FirestoreJsonParsingUtil.parseOrderJson,
);
