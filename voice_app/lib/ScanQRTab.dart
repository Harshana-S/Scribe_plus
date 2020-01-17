import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:voice_app/DisplayPatientPage.dart';
import 'package:http/http.dart' as http;

class ScanQRTab extends StatefulWidget {

  _ScanQRTab createState() => _ScanQRTab();
}

class _ScanQRTab extends State<ScanQRTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _ownPatient= true;
  String otp='';
  String _resultOTP;
 
  Future _scan() async {
    String barcode = await scanner.scan();
    setState((){
      this.barcode = barcode;
      print(barcode);//Convert to JSON and Send
    } );
  }

   Future<String> getQuote(String patAddress,String otp) async {
    String url = 'http://7a43d130.ngrok.io/api/patient/verifyOtp/'+patAddress+'/'+otp;
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
    
  @override
  void initState() {
    super.initState();
    searchPatient();
  }
  void searchPatient(){
  
    setState(() {
      _ownPatient=false;
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
                String result;
                getQuote(barcode, otp).then((String val){
                  print(val);
                  result=val;
                  setState(() {
                  _resultOTP=result;
                });   
                print(_resultOTP);
                if(_resultOTP == 'true'){
                  Navigator.of(context).pop();
                  Navigator.of(_scaffoldKey.currentContext).push(MaterialPageRoute(builder: (context)=>DisplayPatientPage()));
                }
                else{
                  final snackBar = SnackBar(content: Text('Invalid OTP'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  Navigator.of(context).pop();                  
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
    Navigator.push(context, MaterialPageRoute(
              builder: (context)=>DisplayPatientPage()
            ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Scan QR Code",
        style: TextStyle(
          color: Colors.blueGrey
        )),
        centerTitle: true,
        backgroundColor: Colors.grey[100],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                onPressed: (){
                  _scan();
                  
                },
                child: Text("Scan",style: new TextStyle(color: Colors.white)),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blueGrey),
                    ),
                 ),
            
          ],
        ),
        _ownPatient?
            RaisedButton(
              color: Colors.green,
              child: Text("View Result",style:TextStyle(color: Colors.white)),
              onPressed:()=> goToPatientsPage(),
            ):
            RaisedButton(
              color: Colors.green,
              child: Text("Get Patient Authorization",style:TextStyle(color: Colors.white)),
              onPressed:()=> showOTPDialog(),
            ),
        
        ],
        
        
        ),
     ));
  }
  
}

