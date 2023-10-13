

import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import '../models/open_hours_model.dart';

DatabaseService<OpenHourModel> openHoursDb = DatabaseService<OpenHourModel>(
  Constants.openHoursCollection,
  fromMapAsync: (id, data) async => OpenHourModel.fromMap(data),
);
