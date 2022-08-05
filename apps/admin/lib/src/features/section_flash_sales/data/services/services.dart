import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/features/section_flash_sales/data/models/flash_sale_model.dart';

final flashSalesDbService = DatabaseService<FlashSaleModel>(
  Constants.flashSalesCollection,
  fromMapAsync: (id, data) async => FlashSaleModel.fromJson(data, id),
);
