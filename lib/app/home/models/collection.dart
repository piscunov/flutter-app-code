import 'package:flutter/foundation.dart';

class Collection {
  Collection({@required this.id,@required this.name,@required this.importancyRate});
  final String id;
  final String name;
  final int importancyRate;

  factory Collection.fromMap(Map<String, dynamic> data, String documentId) {
      if(data == null) {
        return null;
      }
      final String name = data['name'];
      final int importancyRate = data['importancyRate'];
      return Collection(
       id: documentId,
        name: name,
        importancyRate: importancyRate
      );
  }

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'importancyRate' : importancyRate,
    };
  }
}
