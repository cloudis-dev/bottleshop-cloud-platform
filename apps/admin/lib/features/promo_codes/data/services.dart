import 'package:bottleshop_admin/constants/constants.dart';
import 'package:bottleshop_admin/core/data/services/database_service.dart';
import 'package:bottleshop_admin/models/promo_code_model.dart';

final promoCodesDbService = DatabaseService<PromoCodeModel>(
  Constants.promoCodesCollection,
  fromMapAsync: (_, data) async => PromoCodeModel.fromJson(data),
);
