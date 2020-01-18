import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Prescription{
  String symptoms;
  String diagnosis;
  String medicines;
  String advice;

  Prescription(String symptoms, String diagnosis, String medicine, String advice){
    this.symptoms=(symptoms==null)?'':symptoms;
    this.diagnosis=(diagnosis==null)?'':diagnosis;
    this.medicines=(medicine==null)?'':medicine;
    this.advice=(advice==null)?'':advice;
  }

}
class Patient{
  String patName;
  String patAge;
  int noOfPrescriptions;
  List<String> prescriptionDates;
  Patient(String patName, String patAge, int noOfPrescriptions, List<String> prescriptionDates){
    this.patName=(patName==null)?'':patName;
    this.patAge=(patAge==null)?'':patAge;
    this.noOfPrescriptions=(noOfPrescriptions==0)?0:noOfPrescriptions;
    this.prescriptionDates=prescriptionDates;
  }
}

class DisplayPatientPage extends StatefulWidget {
  
  final String patientAddress;
  
  //DisplayPatientPage(this.patientAddress);
  DisplayPatientPage({Key key, @ required this.patientAddress}) : super(key: key);
  @override
  _DisplayPatientPageState createState() => _DisplayPatientPageState(this.patientAddress);
}

class _DisplayPatientPageState extends State<DisplayPatientPage> {
  String patientAddress,docAddress;
  int cards=0;

  String patName,patAge;
  int noOfPres;
  List<String> dates;

  _DisplayPatientPageState(this.patientAddress);
  Future<String> getPatientRecords() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    return sharedPreferences.getString("address");
  }

  void getDoctorAddress(){
    getPatientRecords().then((String address){
      setState(() {
        docAddress=address;
      });
    });
  }
  
    Future getPatientJSON() async {
    String url = 'http://605f0698.ngrok.io/api/patient/verifyOtp/$patientAddress/$docAddress';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future getPrescriptionJSON(int index) async{
    String url = 'http://605f0698.ngrok.io/api/patient/verifyOtp/$patientAddress/$docAddress/prescription/$index';
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      print("FUTURE : ");
      print(user['otpAuth']);
      print(user['otpAuth'] is String);
      return user;
    } else {
      throw Exception('Failed to load post');
    }

  }

  
  void getPrescriptionDialog(int i){
    getPrescriptionJSON(i).then((var result){
      Prescription prescription=Prescription(result['symptoms'], result['diagnosis'], result['medicine'], result['advice']);
      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black,
        pageBuilder: (BuildContext context, Animation animation, Animation secondAnimation){
          return Center(
            child: Container(
              width: MediaQuery.of(context).size.width-100,
              height: MediaQuery.of(context).size.height-100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: FlatButton.icon(
                    icon: Icon(Icons.close, size:35.0),
                    label: Text("Close"),
                    onPressed:()=> Navigator.of(context).pop(),
                  ),
                  ),
                  ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Symptoms",style:TextStyle(fontWeight: FontWeight.w500)),
                            Text(prescription.symptoms)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Diagnosis",style:TextStyle(fontWeight: FontWeight.w500)),
                            Text(prescription.diagnosis)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Medicines",style:TextStyle(fontWeight: FontWeight.w500)),
                            Text(prescription.medicines)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Advice",style:TextStyle(fontWeight: FontWeight.w500)),
                            Text(prescription.advice)
                          ],
                        ),
                      )
                    ],
                  )
                  
                ],
              )
            ),
          );
        }
      );
     
    });

  }
  @override
  void initState() { 
    super.initState();
    getDoctorAddress();
    getPatientJSON().then((var response){
      Patient patient=Patient(response['patName'], response['patAge'], response['noOfPrescriptions'], response['prescriptionDates']);
      setState(() {
        this.patName=patient.patName;
        this.patAge=patient.patAge;
        this.noOfPres=patient.noOfPrescriptions;
        this.dates=patient.prescriptionDates;
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Reports'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Text("Patient Name",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),),
                  Text(patName)
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                children: <Widget>[
                  Text("Patient Age",style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500
                  ),),
                  Text(patAge)
                ],
              ),
            ),
            for (int i=0;i<dates.length;i++)
            Padding(
              padding: EdgeInsets.all(2.0),
              child: Card(
                elevation: 15.0,
                child: ListTile(
                  title: Text(dates[i]),
                  onTap: ()=>getPrescriptionDialog(i),
                ),
              ),
            )

            
          ],
        ),
      )

    );
  }
}