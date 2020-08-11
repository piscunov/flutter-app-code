import 'package:flutter/material.dart';
import 'package:flutterapp/app/home/models/collection.dart';

class CollectionListTitle extends StatelessWidget {
  const CollectionListTitle({Key key, @required this.collection, this.onTap})
      : super(key: key);
  final Collection collection;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListTile(
        contentPadding: EdgeInsets.only(bottom: 3.0, left:12.0,top: 2.0,right: 3.0),
       title: Text(
          collection.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
          ),
          textAlign: TextAlign.start,
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Colors.black87,
        ),
        onTap: onTap,
      ),
    );
  }
}
