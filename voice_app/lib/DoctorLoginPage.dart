import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/HomeTab.dart';

class DoctorLoginPage extends StatefulWidget {
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _uploadedQR;
  SharedPreferences preferences;
  bool _goToMain=true;
  

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
    if(preferences.containsKey("address"))
      return preferences.getString("address");
    return "null";
       
  }

 Future<bool> getQuote(String docAddress) async {
    String url = 'http://15d08bce.ngrok.io/api/doctor/login/'+docAddress;
    print(url);
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        //await http.get('$url/$barcode');

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      return user['result'];
    } else {
      print("ERROR FUTUTRE");
      throw Exception('Failed to load post');
    }
  }
    
  @override
  void initState() {
    _uploadedQR=false;

    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp){
      preferences=sp;
      var result=preferences.getString("address");
      if(result==null){
        _goToMain=false;
        _setState(_goToMain);
      }
      else{
        print("Calling FUTURE");
        getQuote(result).then((bool v){
          
          _goToMain=true;
         _setState(_goToMain);
        
        });
        
        
      }

    });
    
      }
      void _setState(bool value){
        setState(() {
          _goToMain=value;
        });
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
            _goToMain?
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
                      print("ELSE PART : ");
                      getQuote(barcode).then((bool v ){
                      if(v){
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
                      });
                      
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
      
      
