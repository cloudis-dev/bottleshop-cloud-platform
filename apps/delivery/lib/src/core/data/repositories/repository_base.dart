import 'package:delivery/src/core/data/services/database_service.dart';

abstract class RepositoryBase<T> {
  final DatabaseService<T> db;

  RepositoryBase(this.db);
}
