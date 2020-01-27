import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voice_app/DisplayPatientPage.dart';
import 'package:voice_app/DoctorLoginPage.dart';
import 'package:voice_app/GeneralDisplayReportTab.dart';
import 'package:voice_app/HomeTab.dart';
import 'package:voice_app/SentSuccessful.dart';
import 'package:voice_app/updatePatient.dart';

// void main() => runApp(SplashTab());
void main()=>runApp(SplashTab());

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
        primarySwatch: primaryColorShades
      ),
      home: DoctorLoginPage(),
      //UpdatePatient(patientAddress: "Patient",doctorAddress: "DOcotr",)
      //DisplayPatientPage(patientAddress: "String",)
      //HomeTab()
      //SentSuccessful()
      //GeneralDisplayReportTab(name: "this.name",age: "this.age",medicines: "medicines",symptoms: "symptoms",diagnosis: "diagnosis")
    );
  }
}
