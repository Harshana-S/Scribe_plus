import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_app/DoctorLoginPage.dart';

void main() => runApp(SplashTab());

class SplashTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // routes: {
      //   '/':(BuildContext context)=>SplashTab(),
      //   '/login':(BuildContext context)=>DoctorLoginPage(),
      //   '/home':(BuildContext context)=>HomeTab()
      // },
      title: 'Scribe+',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: LoginTab(),
    );
  }
}

class LoginTab extends StatefulWidget {
 
  _LoginTabState createState() => _LoginTabState();
  
}

class _LoginTabState extends State<LoginTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() { //landing screen replace with splash screen.
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
        builder:(context) => DoctorLoginPage(),
    ),
  (Route<dynamic> route) => false,);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("scribe +", style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.w900,
            fontSize: 60.0,
            letterSpacing: 2),)
        ],
      ),
      )
        
    );
  }
}
