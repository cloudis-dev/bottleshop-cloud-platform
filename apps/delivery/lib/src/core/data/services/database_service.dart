// Copyright 2020 cloudis.dev
//
// info@cloudis.dev
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
//

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class DatabaseService<T> {
  String collection;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Future<T> Function(String, Map<String, dynamic>) fromMapAsync;
  final Map<String, dynamic> Function(T)? toMap;

  DatabaseService(
    this.collection, {
    required this.fromMapAsync,
    this.toMap,
  });

  FirebaseFirestore get db => _db;

  Future<bool> exists(String id) {
    return _db
        .collection(collection)
        .doc(id)
        .get()
        .then((value) => value.exists);
  }

  /// Gets a single record.
  /// @returns null in case the record does not exist.
  Future<T?> getSingle(String id) async {
    final snap = await _db.collection(collection).doc(id).get();
    if (!snap.exists) return null;

    return fromMapAsync(snap.id, snap.data()!);
  }

  Stream<T?> streamSingle(String id) {
    return _db.collection(collection).doc(id).snapshots().asyncMap((snap) {
      return snap.exists
          ? fromMapAsync(snap.id, snap.data()!)
          : Future.value(null);
    });
  }

  Future<List<T>> getQueryList({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
    int? limit,
    DocumentSnapshot? startAfterDocument,
  }) async {
    final query = _createQuery(
      orderBy: orderBy,
      args: args,
      limit: limit,
      startAfterDocument: startAfterDocument,
    );

    final docs = await query.get().then((value) => value.docs);
    return Future.wait(
      docs
          .map(
            (doc) => doc.exists
                ? fromMapAsync(doc.id, doc.data()! as Map<String, dynamic>)
                : null,
          )
          .whereType(),
    );
  }

  Stream<List<T>> streamList({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
  }) {
    final query = _createQuery(orderBy: orderBy, args: args);
    return query.snapshots().asyncMap<List<T>>(
          (event) => Future.wait(
            event.docs
                .map(
                  (e) => e.exists
                      ? fromMapAsync(e.id, e.data()! as Map<String, dynamic>)
                      : null,
                )
                .whereType(),
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
      StreamController<List<Tuple3<DocumentChangeType, DocumentSnapshot, T>>>?
          _getStreamCtrl() => streamCtrl.isClosed ? null : streamCtrl;

      try {
        // The initial batch have to be first awaited and fully added to the stream
        // Just after that the changes stream is added.
        final initialBatch = await query
            .get(GetOptions(source: Source.server))
            .then(
              (event) => Future.wait(
                event.docs.map(
                  (queryDocSnapshot) => queryDocSnapshot.exists
                      ? fromMapAsync(queryDocSnapshot.id,
                              queryDocSnapshot.data()! as Map<String, dynamic>)
                          .then(
                          (value) =>
                              Tuple3<DocumentChangeType, DocumentSnapshot, T>(
                            DocumentChangeType.added,
                            queryDocSnapshot,
                            value,
                          ),
                        )
                      : Future.value(null),
                ),
              ).then(
                (value) => value
                    .whereType<
                        Tuple3<DocumentChangeType, DocumentSnapshot<Object?>,
                            T>>()
                    .toList(),
              ),
            );

        _getStreamCtrl()?.add(initialBatch);

        final snapshotsStream = query.snapshots().asyncMap(
          (snap) {
            return Future.wait(
              snap.docChanges.map(
                (docChange) => fromMapAsync(
                  docChange.doc.id,
                  docChange.doc.data()! as Map<String, dynamic>,
                ).then(
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

  Future<dynamic> create(Map<String, dynamic> data, {String? id}) {
    if (id != null) {
      return _db
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: true));
    } else {
      return _db.collection(collection).add(data);
    }
  }

  Future<void> updateData(String id, Map<String, dynamic> data) {
    return _db
        .collection(collection)
        .doc(id)
        .set(data, SetOptions(merge: true));
  }

  Future<void> removeItem(String id) {
    return _db.collection(collection).doc(id).delete();
  }

  Query _createQuery({
    List<OrderBy>? orderBy,
    List<QueryArgs>? args,
    int? limit,
    DocumentSnapshot? startAfterDocument,
  }) {
    Query query = _db.collection(collection);

    if (orderBy != null) {
      orderBy.forEach((order) {
        query = query.orderBy(order.field, descending: order.descending);
      });
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
  final dynamic field;
  final bool descending;

  OrderBy(this.field, {this.descending = false});
}
