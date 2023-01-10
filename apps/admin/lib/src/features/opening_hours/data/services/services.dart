import 'package:bottleshop_admin/src/config/constants.dart';
import 'package:bottleshop_admin/src/core/data/services/database_service.dart';
import 'package:bottleshop_admin/src/features/opening_hours/data/models/opening_hours_model.dart';

const entryModelDocId = 'USFRRzUNHuYt4mwmjsAM';

final openingHoursService = DatabaseService<OpeningHoursModel>(
  Constants.openingHoursCollection,
  fromMapAsync: (_, map) async => OpeningHoursModel.fromMap(map),
);
