import 'package:flutter/material.dart';
import 'package:flutterapp/app/home/task_page/providers/home.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PickNickname extends StatefulWidget {
  @override
  _PickNicknameState createState() => _PickNicknameState();
}

class _PickNicknameState extends State<PickNickname> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  String _userName;

  void _createUser() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      bool isCreated =
          await Provider.of<HomeProvider>(context, listen: false).createNewUserData(_userName);
          Navigator.pop(context);
      if (isCreated) {
        //print("New User Created");
        //Navigator.of(context).pushReplacementNamed(ToDo.routeName);
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog();
            });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
          child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Form(
                    key: _form,
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter a nickname",
                      ),
                      autocorrect: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _userName = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      color: Colors.blue,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text("Pick the nickname",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white),
                              )),
                      onPressed: () {
                        _createUser();
                      
                      }),
                ],
              ),
            ),
    );
  }
}
