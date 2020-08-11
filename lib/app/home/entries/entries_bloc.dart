import 'package:flutter/foundation.dart';
import 'package:flutterapp/app/home/collection_entries/format.dart';
import 'package:flutterapp/app/home/entries/daily_jobs_details.dart';
import 'package:flutterapp/app/home/entries/entries_list_tile.dart';
import 'package:flutterapp/app/home/entries/entry_job.dart';
import 'package:flutterapp/app/home/models/collection.dart';
import 'package:flutterapp/app/home/models/entry.dart';
import 'package:flutterapp/services/database.dart';
import 'package:rxdart/rxdart.dart';


class EntriesBloc {
  EntriesBloc({@required this.database});
  final Database database;

  // combinarea List<Job>, List<Entry> in List<EntryJob>
  Stream<List<EntryCollection>> get _allEntriesStream => Observable.combineLatest2(
        database.entriesStream(),
        database.collectionStream(),
        _entriesCollectionsCombiner,
      );

  static List<EntryCollection> _entriesCollectionsCombiner(
      List<Entry> entries, List<Collection> collections) {
    return entries.map((entry) {
      final collection = collections.firstWhere((collections) => collections.id == entry.collectionId);
      return EntryCollection(entry, collection);
    }).toList();
  }

  // Output stream
  Stream<List<EntriesListTileModel>> get entriesTileModelStream =>
      _allEntriesStream.map(_createModels);

  static List<EntriesListTileModel> _createModels(List<EntryCollection> allEntries) {
    if(allEntries.isEmpty){
      return [];
    }
    final allDailyCollectionsDetails = DailyCollectionDetails.all(allEntries);

    // cat dureaza in total un job-urile
    final totalDuration = allDailyCollectionsDetails
        .map((dateCollectionsDuration) => dateCollectionsDuration.duration)
        .reduce((value, element) => value + element);

    // cati bani castig adunand toate platile
    final totalPay = allDailyCollectionsDetails
        .map((dateCollectionsDuration) => dateCollectionsDuration.pay)
        .reduce((value, element) => value + element);

    return <EntriesListTileModel>[
      EntriesListTileModel(
        leadingText: 'All Entries',
        middleText: Format.currency(totalPay),
        trailingText: Format.hours(totalDuration),
      ),
      for (DailyCollectionDetails dailyCollectionsDetails in allDailyCollectionsDetails) ...[
        EntriesListTileModel(
          isHeader: true,
          leadingText: Format.date(dailyCollectionsDetails.date),
          middleText: Format.currency(dailyCollectionsDetails.pay),
          trailingText: Format.hours(dailyCollectionsDetails.duration),
        ),
        for (CollectionDetails collectionDuration in dailyCollectionsDetails.collectionsDetails)
          EntriesListTileModel(
            leadingText: collectionDuration.name,
            middleText: Format.currency(collectionDuration.pay),
            trailingText: Format.hours(collectionDuration.durationInHours),
          ),
      ]
    ];
  }
}
