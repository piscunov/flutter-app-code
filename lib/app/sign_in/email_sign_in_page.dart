import 'package:flutter/material.dart';
import 'package:flutterapp/app/sign_in/email_sign_in_form_bloc_based.dart';

class EmailSignInPage extends StatefulWidget {
  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Sign in via E-mail'),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 15.0,
            child: EmailSignInFormBlocBased.create(context),
            color: Colors.indigo[600],
          ),
        ),
      ),
      backgroundColor: Colors.indigo[600],
    );
  }
}
