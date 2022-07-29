import 'dart:async';

import 'package:bottleshop_admin/core/data/exceptions/no_such_snapshot_exists.dart';
import 'package:bottleshop_admin/utils/logical_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class DatabaseService<T> {
  String collection;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Future<T> Function(String, Map<String, dynamic>) fromMapAsync;

  DatabaseService(
    this.collection, {
    required this.fromMapAsync,
  });

  Future<bool> exists({String? id, List<QueryArgs>? args}) async {
    assert(LogicalUtils.xor(id != null, args != null));

    if (id == null) {
      final snap = _db.collection(collection);
      _addArgsToQuery(args, snap);

      return (await snap.get()).docs.isNotEmpty;
    } else {
      final snap = await _db.collection(collection).doc(id).get();
      return snap.exists;
    }
  }

  Future<T?> getSingle(String? id) async {
    final snap = await _db.collection(collection).doc(id).get();
    if (!snap.exists) return null;
    return fromMapAsync(snap.id, snap.data() ?? {});
  }

  Stream<T> streamSingle(String? id) {
    return _db.collection(collection).doc(id).snapshots().asyncMap(
          (snap) => snap.exists
              ? fromMapAsync(snap.id, snap.data() ?? {})
              : throw NoSuchSnapshotExists(snap.reference),
        );
  }

  Future<List<T>> getQueryList({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
    int? limit,
  }) async {
    final query = _createQuery(
      orderBy: orderBy,
      args: args,
      limit: limit,
    );

    return query.get().then(
          (value) => Future.wait(
            value.docs
                .map((doc) =>
                    fromMapAsync(doc.id, doc.data()! as Map<String, dynamic>))
                .toList(),
          ),
        );
  }

  /// This is a convenience function when we don't need the [DocumentSnapshot].
  Stream<List<Tuple2<DocumentChangeType, T>>> streamQueryListWithChangesAll({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
  }) {
    return streamQueryListWithChanges(orderBy: orderBy, args: args).map(
      (event) => event.map((e) => Tuple2(e.item1, e.item3)).toList(),
    );
  }

  Stream<List<Tuple3<DocumentChangeType, DocumentSnapshot, T>>>
      streamQueryListWithChanges({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
    int? limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    final query = _createQuery(
      orderBy: orderBy,
      args: args,
      limit: limit,
      startAfterDocument: startAfterDocument,
    );

    final streamCtrl = StreamController<
        List<Tuple3<DocumentChangeType, DocumentSnapshot, T>>>();

    streamCtrl.onCancel = () async {
      return streamCtrl.close();
    };

    // ignore: cascade_invocations
    streamCtrl.onListen = () async {
      final _getStreamCtrl = () => streamCtrl.isClosed ? null : streamCtrl;

      try {
        // The initial batch have to be first awaited and fully added to the stream
        // Just after that the changes stream is added.
        final initialBatch = await query
            .get(GetOptions(source: Source.server))
            .then(
              (event) => Future.wait(
                event.docs.map(
                  (doc) =>
                      fromMapAsync(doc.id, doc.data()! as Map<String, dynamic>)
                          .then(
                    (value) => Tuple3(DocumentChangeType.added, doc, value),
                  ),
                ),
              ),
            );

        _getStreamCtrl()?.add(initialBatch);

        final snapshotsStream = query.snapshots().asyncMap(
          (snap) {
            return Future.wait(
              snap.docChanges.map(
                (docChange) => fromMapAsync(docChange.doc.id,
                        (docChange.doc.data() as Map<String, dynamic>?) ?? {})
                    .then(
                  (value) => Tuple3(docChange.type, docChange.doc, value),
                ),
              ),
            );
          },
        );

        await _getStreamCtrl()?.addStream(snapshotsStream);
      } catch (e) {
        _getStreamCtrl()?.addError(e);
      }
    };

    return streamCtrl.stream;
  }

  Future<void> create(
    Map<String, dynamic> data, {
    String? id,
    WriteBatch? batch,
  }) {
    if (batch != null) {
      batch.set(
        _db.collection(collection).doc(id),
        data,
        SetOptions(merge: true),
      );
      return Future.value();
    } else {
      return _db.collection(collection).doc(id).set(
            data,
            SetOptions(merge: true),
          );
    }
  }

  Future<void> updateData(
    String id,
    Map<String, dynamic> data, {
    WriteBatch? batch,
  }) {
    if (batch != null) {
      batch.update(_db.collection(collection).doc(id), data);
      return Future.value();
    } else {
      return _db.collection(collection).doc(id).update(data);
    }
  }

  Future<void> removeItem(
    String id, {
    WriteBatch? batch,
  }) {
    if (batch != null) {
      batch.delete(_db.collection(collection).doc(id));
      return Future.value();
    } else {
      return _db.collection(collection).doc(id).delete();
    }
  }

  Query _createQuery({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
    int? limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = _db.collection(collection);

    if (orderBy != null) {
      for (var order in orderBy) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    query = _addArgsToQuery(args, query);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (startAfterDocument != null) {
      query = query.startAfterDocument(startAfterDocument);
    }

    return query;
  }

  Query _addArgsToQuery(
    List<QueryArgs>? args,
    Query query,
  ) {
    if (args != null) {
      for (final arg in args) {
        query = query.where(
          arg.key,
          isEqualTo: arg.isEqualTo,
          isGreaterThan: arg.isGreaterThan,
          isGreaterThanOrEqualTo: arg.isGreaterThanOrEqualTo,
          isLessThan: arg.isLessThan,
          isLessThanOrEqualTo: arg.isLessThanOrEqualTo,
          isNull: arg.isNull,
          arrayContains: arg.arrayContains,
          arrayContainsAny: arg.arrayContainsAny,
          whereIn: arg.whereIn,
        );
      }
    }
    return query;
  }
}

class QueryArgs {
  final dynamic key;
  final dynamic isEqualTo;
  final dynamic isLessThan;
  final dynamic isLessThanOrEqualTo;
  final dynamic isGreaterThanOrEqualTo;
  final dynamic isGreaterThan;
  final dynamic arrayContains;
  final List<dynamic>? arrayContainsAny;
  final List<dynamic>? whereIn;
  final bool? isNull;

  QueryArgs(
    this.key, {
    this.isEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.isNull,
    this.isGreaterThanOrEqualTo,
  });
}

class OrderBy {
  final String field;
  final bool descending;

  OrderBy(this.field, {this.descending = false});
}
