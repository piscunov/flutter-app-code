import 'package:flutter/foundation.dart';
import 'package:flutterapp/app/home/entries/entry_job.dart';

//  Model class pt stocarea timpului lucrat si banii pe care trebuie sa ii primesc
class CollectionDetails {
  CollectionDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

// Grupeaza toate "lucrarile / intrarile" intr-o zi data
class DailyCollectionDetails {
  DailyCollectionDetails({@required this.date, @required this.collectionsDetails});
  final DateTime date;
  final List<CollectionDetails> collectionsDetails;

  double get pay => collectionsDetails
      .map((collectionDuration) => collectionDuration.pay)
      .reduce((value, element) => value + element);

  double get duration => collectionsDetails
      .map((collectionDuration) => collectionDuration.durationInHours)
      .reduce((value, element) => value + element);

  // impartirea intrarilor pe grupuri separate
  static Map<DateTime, List<EntryCollection>> _entriesByDate(List<EntryCollection> entries) {
    Map<DateTime, List<EntryCollection>> map = {};
    for (var entryCollection in entries) {
      final entryDayStart = DateTime(entryCollection.entry.start.year,
          entryCollection.entry.start.month, entryCollection.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryCollection];
      } else {
        map[entryDayStart].add(entryCollection);
      }
    }
    return map;
  }

  // Mapeaza o lista neordonata de "EntryJob" intr-o lista de DailyJobsDetails cu info despre date
  static List<DailyCollectionDetails> all(List<EntryCollection> entries) {
    final byDate = _entriesByDate(entries);
    List<DailyCollectionDetails> list = [];
    for (var date in byDate.keys) {
      final entriesByDate = byDate[date];
      final byCollection = _collectionsDetails(entriesByDate);
      list.add(DailyCollectionDetails(date: date, collectionsDetails: byCollection));
    }
    return list.toList();
  }

  // Grupeaza intrarile dupa job
  static List<CollectionDetails> _collectionsDetails(List<EntryCollection> entries) {
    Map<String, CollectionDetails> collectionDuration = {};
    for (var entryCollection in entries) {
      final entry = entryCollection.entry;
      final pay = entry.durationInHours * entryCollection.collection.importancyRate;
      if (collectionDuration[entry.collectionId] == null) {
        collectionDuration[entry.collectionId] = CollectionDetails(
          name: entryCollection.collection.name,
          durationInHours: entry.durationInHours,
          pay: pay,
        );
      } else {
        collectionDuration[entry.collectionId].pay += pay;
        collectionDuration[entry.collectionId].durationInHours += entry.durationInHours;
      }
    }
    return collectionDuration.values.toList();
  }
}
