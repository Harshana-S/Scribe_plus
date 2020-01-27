import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/HomeTab.dart';
import 'package:voice_app/updatePatient.dart';
import 'package:voice_app/url.dart';


class DisplayPatientPage extends StatefulWidget {
  final String patientAddress;

  //DisplayPatientPage(this.patientAddress);
  DisplayPatientPage({Key key, @required this.patientAddress})
      : super(key: key);
  @override
  _DisplayPatientPageState createState() =>
      _DisplayPatientPageState(this.patientAddress);
}

class _DisplayPatientPageState extends State<DisplayPatientPage> {
  String patientAddress, docAddress, docKey;
  int cards = 0;

  String patName, patAge;
  String noOfPres;
  List<dynamic> prescriptions;
  List<dynamic> dates;
  bool _fetchedResults=false;
  bool _timedOut=false;

  _DisplayPatientPageState(this.patientAddress);
  Future<String> getPatientRecords() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("address");
  }

  Future<String> getDoctorKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("key");
  }

  void getPrescriptionDialog(String symptoms,String diagnosis, String medicines, String advice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Material(
          type: MaterialType.transparency,
          child:Center(
          child: Container(
              color: Colors.white,
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
                  Flexible(
                    child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Symptoms",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ),                            
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(symptoms, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                            
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Diagnosis",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text(diagnosis, style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Medicines",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text('$medicines', style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                           Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Advice",style:TextStyle(color:Colors.black,fontWeight: FontWeight.w500, fontSize: 15.0)),
                            ), 
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(15.0),
                              padding: EdgeInsets.all(10.0),
                              child: Text('$advice', style: TextStyle(fontSize: 15.0,)),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black, width: 1.0)
                              ),
                            )
                          ],
                        ),
                      )

                      ],
                    ),
                  ),
                  )
                  
                  // ListView(
                  //   children: <Widget>[
                      
                    //],
                  // )

                ],
              )
            ),

        )
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getPatientRecords().then((String address) async {
      print("TRIALLL: $address");
      setState(() {
        docAddress = address;
      });
      getDoctorKey().then((String value) async {
      print("$value");
      setState(() {
        docKey = value;
      }); 
      print('Patient:$patientAddress/nDoctor:$docAddress');
      String url = '$ngrok_url/api/patient/get/$patientAddress/$docAddress/$docKey';
      print('DISPLAY:$url');
      final response = await http.get(url, headers: {"Accept": "application/json"});

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> user = jsonDecode(response.body);
        // print(user);
        // print(user['result']['0']);
        // print(user['result']['1']);
        // print(user['result']['5']);
        // print(user['result']['1'] is String);
        // print(user['result']['5'] is String);
        setState(() {
          this.patName = user['result']['0'];
          this.patAge = "32";
          this.noOfPres = user['result']['1'];
          this.prescriptions = user['result']['2'];
          this.dates = user['result']['5'];
          this._fetchedResults=true;
        });

      } else {
        throw Exception('Failed to load post');
      }   
    });
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_fetchedResults==true)?
    Scaffold(
      appBar: AppBar(
        title: Text('PATIENT REPORT',
        style: TextStyle(
          color:Colors.white,
          letterSpacing: 4,
          fontWeight: FontWeight.w300
        ),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context)=>HomeTab())
              );
            
            } ,
          ),
          
          
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    patName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400, letterSpacing: 4, fontSize: 20),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "M",
                    style: TextStyle(
                        color: Colors.black,  fontSize: 17),
                  ),
                  Text("$patAge Y",
                  style: TextStyle(
                        color: Colors.black,  fontSize: 17),)
                ],
              ),
            ),
             SizedBox(
              height: MediaQuery.of(context).size.height*0.02,
            ),
            Text("Prescriptions: $noOfPres",
            textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black, fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.04,
            ),
            for (int i = 0; i < dates.length; i++)
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  color: Colors.black,
                  elevation: 15.0,
                  child: ListTile(
                      title: Text(
                        dates[i],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 2
                        ),),
                      onTap: () async {
                        String index = prescriptions[i];
                        print("INDEX : $index");
                        String url =
                            '$ngrok_url/api/patient/prescription/$index';
                        final response = await http.get(url, headers: {"Accept": "application/json"});
                        if (response.statusCode == 200) {
                          print(response.body);
                          Map<String, dynamic> user = jsonDecode(response.body);
                          print(user['prescription']['0']);
                          getPrescriptionDialog(user['prescription']['1'],user['prescription']['2'],user['prescription']['0'],user['prescription']['3']);
                        } else {
                          throw Exception('Failed to load post');
                        }
                        //getPrescriptionDialog(index);
                      }),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        mini: false,
        child: Icon(Icons.add_box, color: Colors.white),
        onPressed: (){
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UpdatePatient(patientAddress: patientAddress,doctorAddress: docAddress,)),);
        },
      ),
    ):
    Scaffold(
      appBar: AppBar(
        title: Text('Patient Reports'),
        centerTitle: true,
      ),
      body:(_timedOut==false)?Center(
        child: SpinKitFadingGrid(
          color: Colors.black,
        ),
      ):Timer(Duration(seconds: 8),
          (){
            setState(() {
              _timedOut=true;
            });
            Center(
              child: Text('Could not load results'),
            );
          } 
      )
      
    );
  }
}
