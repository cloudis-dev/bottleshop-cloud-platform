import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/features/section_flash_sales/data/models/flash_sale_model.dart';

final flashSalesDbService = DatabaseService<FlashSaleModel>(
  Constants.flashSalesCollection,
  fromMapAsync: (id, data) async => FlashSaleModel.fromJson(data, id),
);
