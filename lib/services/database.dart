import 'package:flutter/foundation.dart';
import 'package:flutterapp/app/home/models/collection.dart';
import 'package:flutterapp/app/home/models/entry.dart';
import 'package:flutterapp/services/api_path.dart';
import 'package:flutterapp/services/firestore_service.dart';


abstract class Database {
  Future<void> setCollection(Collection collection);
  Future<void> deleteCollection(Collection collection);
  Stream<List<Collection>> collectionStream();
  Stream<Collection> collectionsStream ({@required String collectionId});

  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Collection collection});

}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setCollection(Collection collection) async => await _service.setData(
        path: APIPath.collection(uid, collection.id),
        data: collection.toMap(),
      );

  @override
  Future<void> deleteCollection(Collection collection) async {
    // delete unde entry.jobId == job.jobId
    final allEntries = await entriesStream(collection: collection ).first;
    for (Entry entry in allEntries) {
      if (entry.collectionId == collection.id) {
        await deleteEntry(entry);
      }
    }
    // sterge job
    await _service.deleteData(path: APIPath.collection(uid, collection.id));
  }

  @override
  Stream<List<Collection>> collectionStream() => _service.collectionStream(
        path: APIPath.collections(uid),
        builder: (data, documentId) => Collection.fromMap(data, documentId),
      );
@override
Stream<Collection> collectionsStream ({@required String collectionId}) => _service.documentStream(
  path: APIPath.collection(uid, collectionId),
  builder: (data, documentId) => Collection.fromMap(data, documentId),
); 

  @override
  Future<void> setEntry(Entry entry) async => await _service.setData(
    path: APIPath.entry(uid, entry.id),
    data: entry.toMap(),
  );

  @override
  Future<void> deleteEntry(Entry entry) async => await _service.deleteData(path: APIPath.entry(uid, entry.id));

  @override
  Stream<List<Entry>> entriesStream({Collection collection}) => _service.collectionStream<Entry>(
    path: APIPath.entries(uid),
    queryBuilder: collection != null ? (query) => query.where('collectionId', isEqualTo: collection.id) : null,
    builder: (data, documentID) => Entry.fromMap(data, documentID),
    sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
  );
}
