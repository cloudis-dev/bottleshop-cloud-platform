import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/models/promo_code_model.dart';

final promoCodesDbService = DatabaseService<PromoCodeModel>(
  Constants.promoCodesCollection,
  fromMapAsync: (_, data) async => PromoCodeModel.fromJson(data),
);
