import 'package:delivery/src/core/data/res/constants.dart';
import 'package:delivery/src/core/data/services/database_service.dart';
import 'package:delivery/src/features/cart/data/models/promo_code_model.dart';

DatabaseService<PromoCodeModel> promoCodeDbService =
    DatabaseService<PromoCodeModel>(
  FirestoreCollections.promoCodesCollection,
  fromMapAsync: (id, data) async {
    print(data);
    return PromoCodeModel.fromJson(data, id);
  },
);
