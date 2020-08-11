import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app/home/collection_entries/collection_entries_page.dart';
import 'package:flutterapp/app/home/collections/collection_list_title.dart';
import 'package:flutterapp/app/home/collections/edit_collection_page.dart';
import 'package:flutterapp/app/home/collections/list_item_builder.dart';
import 'package:flutterapp/app/home/models/collection.dart';
import 'package:flutterapp/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:flutterapp/services/database.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Collection collection) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteCollection(collection);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //temporary code:
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Task Collections Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.redAccent,
              size: 25,
            ),
            onPressed: () => EditCollectionPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Collection>>(
      stream: database.collectionStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Collection>(
            snapshot: snapshot,
            itemBuilder: (context, collection) => Dismissible(
                  key: Key('job-${collection.id}'),
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(context, collection),
                  child: CollectionListTitle(
                    collection: collection,
                    onTap: () =>
                        CollectionEntriesPage.show(context, collection),
                  ),
                ));
      },
    );
  }
}
