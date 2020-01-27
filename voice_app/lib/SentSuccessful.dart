import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:flutter/material.dart';

class SentSuccessful extends StatefulWidget {
  @override
  _SentSuccessfulState createState() => _SentSuccessfulState();
}

class _SentSuccessfulState extends State<SentSuccessful> with TickerProviderStateMixin {
  LottieComposition _composition;
  AnimationController _controller;

  Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) =>  LottieComposition.fromMap(map));
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =  AnimationController(
     duration: const Duration(seconds: 4),
     vsync: this,
    );
    loadAsset("assets/send_successful.json").then((LottieComposition composition) {
      setState(() {
        _composition = composition;
        _controller.reset();
        _controller.forward();
      });
    });
    _controller.addListener(() => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SingleChildScrollView(
        child:       Center(
        child: 
      //   Lottie(
      //     composition: _composition,
      //     controller: _controller,
      //     size: const Size(300.0, 900.0),
      //   ),
      // )
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
      <Widget>[
        Lottie(
          composition: _composition,
          controller: _controller,
          size: const Size(400.0, 900.0),
        ),
        Text(
          "Sent Successfully",
          style: TextStyle(
            color: Colors.green,
            fontSize: 40
          ),
        )
      ],)),
      )

      
    );
  }
}