import 'package:flutter/material.dart';
import 'package:flutterapp/app/home/task_page/task_page.dart';
import 'package:flutterapp/app/landing_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchApp extends StatefulWidget {
  @override
  _SwitchAppState createState() => _SwitchAppState();
}

class _SwitchAppState extends State<SwitchApp> {


  @override
  Widget build(BuildContext context) {

  //UI pt schimbarea categoriei
    return Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black87, Colors.indigo])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            "images/app-logo.png",
            width: 180,
            height: 205,
            color: Colors.amber,
          ),
          SizedBox(height: 10),
          Text(
            'Chose who you want to become!',
            style: GoogleFonts.poppins(
                textStyle:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.amber)),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              elevation: 5.0,
              child: Text('Task Manager'),
              onPressed: () => _goToTaskPage(context),
            ),
          ),
          SizedBox(height: 35),
          SizedBox(
            height: 50,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
              ),
              elevation: 5.0,
              child: Text('Jobs Manager'),
              onPressed: () => _goToJobPage(context),
            ),
          )
        ],
      ),
    );
  }

  _goToTaskPage(BuildContext context) {
    try {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new TaskPage()),
      );
    } catch (e) {
      print(e);
    }
  }

  _goToJobPage(BuildContext context) {
    try {
      Navigator.of(context).push(
        new MaterialPageRoute(builder: (context) => new LandingPage()),
      );
    } catch (e) {
      print(e);
    }
  }
}
