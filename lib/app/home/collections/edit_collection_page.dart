import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp/app/home/models/collection.dart';
import 'package:flutterapp/custom_widgets/platform_alert_dialog.dart';
import 'package:flutterapp/custom_widgets/platform_exception_alert_dialog.dart';
import 'package:flutterapp/services/database.dart';

class EditCollectionPage extends StatefulWidget {
  const EditCollectionPage({Key key, @required this.database, this.collection})
      : super(key: key);

  final Database database;
  final Collection collection;

  static Future<void> show(BuildContext context,
      {Database database, Collection collection}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditCollectionPage(
          database: database,
          collection: collection,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditCollectionPageState createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _importancyRate;

  @override
  void initState() {
    super.initState();
    if (widget.collection != null) {
      _name = widget.collection.name;
      _importancyRate = widget.collection.importancyRate;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final collections = await widget.database.collectionStream().first;
        final allNames =
            collections.map((collection) => collection.name).toList();
        if (widget.collection != null) {
          allNames.remove(widget.collection.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please chose a diffrent collection name',
            defaultActionText: 'Ok',
          ).show(context);
        } else {
          final id = widget.collection?.id ?? documentIdFromCurrentDate();
          final collection = Collection(
            id: id,
            name: _name,
            importancyRate: _importancyRate,
          );
          await widget.database.setCollection(collection);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(
            widget.collection == null ? 'New Collection' : 'Edit Collection'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                )),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.indigo,
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFromChildren(),
      ),
    );
  }

  List<Widget> _buildFromChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Task collection name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration:
            InputDecoration(labelText: 'Amount per hour'),
        initialValue: _importancyRate != null ? '$_importancyRate' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _importancyRate = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
