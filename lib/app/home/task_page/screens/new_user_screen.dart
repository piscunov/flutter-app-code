import 'package:flutter/material.dart';
import 'package:flutterapp/app/home/task_page/providers/home.dart';
import 'package:flutterapp/app/home/task_page/screens/todo_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


class NewUserScreen extends StatefulWidget {
  
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
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
      bool isCreated = await Provider.of<HomeProvider>(context).createNewUserData(_userName);
      if(isCreated){
        print("New User Created");
        Navigator.of(context).pushReplacementNamed(ToDo.routeName);
      }else{
        showDialog(
          context: context,
          builder: (ctx){
            return AlertDialog();
          }
        ); 
      }
    }catch(e){
      //print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {


    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 100,left: 40,right: 40,bottom: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: "Hello,\n",style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.blue,fontSize: 25,fontWeight: FontWeight.w600))),
                    TextSpan(text: "Les't get some work done,\n",style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.blue))),
                  ]
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                 
                  SizedBox(height: 20,),
                  RaisedButton(
                    color: Colors.blue,
                    child: _isLoading ? CircularProgressIndicator() : 
                      Text("Create Account",style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white),)),
                    onPressed: () {
                     _createUser();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}