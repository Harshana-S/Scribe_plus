import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/DisplayPatientPage.dart';
import 'package:http/http.dart' as http;
import 'package:voice_app/url.dart';




class ScanQRTab extends StatefulWidget {
  _ScanQRTab createState() => _ScanQRTab();
}

class _ScanQRTab extends State<ScanQRTab> {
  
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _ownPatient= true;
  String otp='';
  String docAddress, docKey;
  bool _startScan=true;
  
 
  Future<String> _scan() async {
    String barcode = await scanner.scan();
    setState((){
      this.barcode = barcode;
      print(barcode);//Convert to JSON and Send
    } );
    return barcode;
  }
  Future<String> getDoctorAddress() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("address");
  }
  Future<String> getDoctorKey() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("key");
  }

   Future<String> verifyOTP(String patAddress,String otp) async {
    String url = '$ngrok_url/api/patient/verifyOtp/'+patAddress+'/'+otp+'/$docKey';
    print(url);
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        //await http.get('$url/$barcode');

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      print("FUTURE : ");
      print(user['otpAuth']);
      print(user['otpAuth'] is String);
      return user['otpAuth'];
    } else {
      throw Exception('Failed to load post');
    }
  }
  Future<String> getPatient(String patAddress) async {
    String url = '$ngrok_url/api/patient/get/'+patAddress+'/'+docAddress+'/$docKey';
    print(url);
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        //await http.get('$url/$barcode');

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      return user['result']['0'];
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future sendOTP() async {
    String url = '$ngrok_url/api/patient/sendOTP/$barcode';
    print('Send OTP:$url');
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        //await http.get('$url/$barcode');

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      return user['0'];
    } else {
      throw Exception('Failed to load post');
    }
  }


    
  @override
  void initState() {
    super.initState();
    this.barcode='';
    getDoctorAddress().then((String address) async {
      print("$address");
      setState(() {
        docAddress = address;
      });    
    });
    getDoctorKey().then((String value) async {
      print("$value");
      setState(() {
        docKey = value;
      });    
    });
    _scan().then((String qrcode){
                    getPatient(qrcode).then((String result){
                    print('After scanning patient $result');
                    print(result=='');
                    if(result!=''){
                      print(result);
                      goToPatientsPage();
                    }
                    else{
                      sendOTP();
                      print(result);
                      showOTPDialog();

                    }
                  });
                  });

  }

  void showOTPDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          title: new Text("Enter OTP"),
          content: Builder(
            builder: (BuildContext context){
            return  Container(
            width: 500 ,
            child: PinEntryTextField(
              fields: 6,
              showFieldAsBox: false,
              onSubmit: (String pin){
                setState(() {
                  otp=pin;
                });
              },
            ),
          );
            },
          ),
          
          actions: <Widget>[
            new FlatButton(
              child: Text("Submit"),
              onPressed: (){
                print('Doctor:$barcode');
                verifyOTP(this.barcode, otp).then((String result){
                  if(result=='true'){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DisplayPatientPage(patientAddress:barcode)));
                  }
                  else{
                Navigator.of(context).pop();
                Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid OTP"),
                      ));
                  }
                });

                
              },
            
            ),
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void goToPatientsPage(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>DisplayPatientPage(patientAddress:barcode)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Container(
          child: SpinKitWave(
            color: Colors.black,
          ),
        )
      ));
  }
  
}

