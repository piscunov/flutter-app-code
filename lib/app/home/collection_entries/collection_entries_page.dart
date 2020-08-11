import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app/home/collection_entries/entry_list_item.dart';
import 'package:flutterapp/app/home/collection_entries/entry_page.dart';
import 'package:flutterapp/app/home/collections/edit_collection_page.dart';
import 'package:flutterapp/app/home/collections/list_item_builder.dart';
import 'package:flutterapp/app/home/models/collection.dart';
import 'package:flutterapp/app/home/models/entry.dart';
import 'package:flutterapp/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:flutterapp/services/database.dart';
import 'package:provider/provider.dart';

class CollectionEntriesPage extends StatelessWidget {
  const CollectionEntriesPage(
      {@required this.database, @required this.collection});
  final Database database;
  final Collection collection;

  static Future<void> show(BuildContext context, Collection collection) async {
    final Database database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => CollectionEntriesPage(
          database: database,
          collection: collection,
        ),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Collection>(
        stream: database.collectionsStream(collectionId: collection.id),
        builder: (context, snapshot) {
          final collection = snapshot.data;
          final collectionName = collection?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              backgroundColor: Colors.black87,
              title: Text(collectionName),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => EditCollectionPage.show(context,
                      database: database, collection: collection),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.red,size: 25,),
                  onPressed: () => EntryPage.show(
                      context: context,
                      database: database,
                      collection: collection),
                ),
              ],
            ),
            body: _buildContent(context, collection),
          );
        });
  }

  Widget _buildContent(BuildContext context, Collection collection) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(collection: collection),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              collection: collection,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                collection: collection,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
