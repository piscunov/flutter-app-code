import 'package:flutter/material.dart';
import 'package:flutterapp/custom_widgets/custom_raised_button.dart';

class FormSubmitButton extends CustomRaisedButton {
  FormSubmitButton({
    @required String text,
    @required VoidCallback onPressed
  }): super (
    child: Text(
      text,
      style: TextStyle(color: Colors.black,fontSize: 16.0),
    ),
    height: 35.0,
    color: Colors.amber,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}