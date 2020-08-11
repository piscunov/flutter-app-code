import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.collectionId,
    @required this.start,
    @required this.end,
    this.comment,
  });

  String id;
  String collectionId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;

  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];
    return Entry(
      id: id,
      collectionId: value['collectionId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'collectionId': collectionId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }
}
