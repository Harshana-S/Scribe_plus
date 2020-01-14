import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_app/HomeTab.dart';

void main() => runApp(SplashTab());

class SplashTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() { //landing screen replace with splash screen.
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder:(context) => HomeTab(),
    ));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
