import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/HomeTab.dart';

class DoctorLoginPage extends StatefulWidget {
  // DoctorLoginPage({Key key}) : super(key: key);

  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _validLogin;
  bool _uploadedQR;

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() {
      this.barcode = barcode;
      _uploadedQR=true;
    });
    print(barcode);
  }
  Future saveAddressPreference(String barcode) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("address", barcode);
  }
  Future<String> getAddressPreference() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    if(preferences.containsKey("address")){
      return preferences.getString("address");
    }
    return "null";
    
  }
  
  bool _validateAddress(String addressResult) {   //send this addressResult to backend, get if it is an address
        return true;

}
  @override
  void initState() {
    super.initState();
    _uploadedQR=false;
    var s ="";
    var _addressResult=getAddressPreference();
    //print(_addressResult);
    _addressResult.then((String add){
     s = add;
    });
    print(s);
    if(s=="null"){
      setState(() {
        _validLogin=false;
      });
    }
    else{
      setState(() {
        _validLogin=true;
      });
    }
    //  print(s);
    //   if(s.isEmpty){
    //     print(false);
    //     setState(() {
          
    //     });
      
    //   }
    //   else{
    //     bool g = _validateAddress(s);
    //     print(g);
    //     setState(() {
    //       _validLogin=g;
    //     });
    //   }
    // if(_addressResult!=null){
    //   setState(() {
    //     _validLogin=_validateAddress(_addressResult.toString());
    //   });
    //   }else{
    //     setState(() {
    //       _validLogin=false;
    //     });
    //   }
      }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            key: _scaffoldKey,
            // appBar: new AppBar(
            //   title: new Text("Scribe +"),
            //   centerTitle: true,
            //   elevation: defaultTargetPlatform == TargetPlatform.android? 5.0: 0.0 ,
            // ),
            body: 
            _validLogin?
            Builder(
              builder: (context)=>HomeTab()
            ):
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Card(
                  elevation: 10.0,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    RaisedButton(
                    color: Colors.green,
                    child: Text("Upload QR code",style: TextStyle(color: Colors.white),),
                    onPressed: _scanPhoto,
                  ),
                  
                
                _uploadedQR?
                Container(
                  child: Icon(Icons.cloud_done,size:30.0),
                ):
                Container(
                  child: Icon(Icons.add_photo_alternate,size:30.0),
                )
      
                    ],
                  ),),),
                  ),
                Builder(
                  builder: (context){
                    return RaisedButton(
                  color: Colors.blueGrey,
                  child: Text("Login",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    print("Login pressed");
                    if(barcode==""){
                      Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid QR code"),
                      ));
                    }
                    else{
                      if(_validateAddress(barcode)){
                      saveAddressPreference(barcode);
                      // Scaffold.of(context).showSnackBar(SnackBar(
                      // content: Text("Login Successful!"),
                      // ));
                      //Navigator.of(context).dispose();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeTab()));

                    }
                    else{
                      Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid Login"),
                      ));
                      setState(() {
                        _uploadedQR=false;
                        barcode="";
                      });
                    }
                    }
                    
                  },
                );
                  },
                  
                ),  
                  
                
                  ],
                )
              )
            ),
          );
        }
      }
      
      
