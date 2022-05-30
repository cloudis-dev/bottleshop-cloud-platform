import 'package:dartz/dartz.dart';

import 'change_status.dart';

/// Representation of a batch received via a stream.
class ItemsStateStreamBatch<T> {
  final List<Tuple2<ChangeStatus, T>> batch;

  ItemsStateStreamBatch(this.batch);
}
