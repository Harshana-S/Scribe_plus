import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voice_app/HomeTab.dart';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:voice_app/url.dart';

class DoctorLoginPage extends StatefulWidget {
  _DoctorLoginPageState createState() => _DoctorLoginPageState();
}

class _DoctorLoginPageState extends State<DoctorLoginPage> with TickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _uploadedQR;
  SharedPreferences preferences;
  bool _goToMain=true;
  LottieComposition _composition;
  AnimationController _controller;
  bool _repeat;
  bool animation_not_over=true;

  Future saveAddressPreference(String barcode, String value) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setString("address", barcode);
    preferences.setString("key", value);
  }
  Future<String> getAddressPreference() async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    if(preferences.containsKey("address"))
      return preferences.getString("address");
    return "null";
       
  }

 Future<String> validate(String docAddress) async {
    String url = '$ngrok_url/api/doctor/login/'+docAddress;
    print(url);
    final response =
        await http.get(url, headers: {"Accept": "application/json"});
        //await http.get('$url/$barcode');

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> user = jsonDecode(response.body);
      return user['result']['0'];
    } else {
      print("ERROR FUTUTRE");
      throw Exception('Failed to load post');
    }
  }
  Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) =>  LottieComposition.fromMap(map));
}
    
  @override
  void initState() {
    _uploadedQR=false;
    super.initState();
    _repeat = false;
    _controller =  AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    loadAsset("assets/doctoranimation.json").then((LottieComposition composition) {
      setState(() {
        _composition = composition;
        _controller.reset();
        _controller.forward();
      });
    });
    _controller.addListener(() => setState(() {}));
    Timer(Duration(seconds: 6), (){
      setState(() {
        animation_not_over=false;
      });
    });
    SharedPreferences.getInstance().then((SharedPreferences sp){
      preferences=sp;
      var result=preferences.getString("address");
      if(result==null){
        _goToMain=false;
        _setState(_goToMain);
      }
      else{
        validate(result).then((String v){
          if(v!=null){
            _goToMain=true;
          _setState(_goToMain);
          }        
        });
      }

  
      }
    );
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
            backgroundColor: primaryColorShades,
            body: 
            _goToMain?
            Builder(
              builder: (context)=>HomeTab()
            ):
            
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                  
                  Text(
                    "SCRIBE +",
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 8,
                      fontSize: 50,
                      fontWeight: FontWeight.w200
                    ),                    
                  ),
                  Lottie(
                      composition: _composition,
                      size: const Size(300.0, 300.0),
                      controller: _controller,
                  ),
                  animation_not_over?
                  SizedBox(
                    height: 10.0,                  
                  ):
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: RaisedButton(
                    color: Colors.white,
                    child: Text("Upload QR code",style: TextStyle(color: Colors.black),),
                    onPressed: () async{
                      await scanner.scanPhoto().then((String barcode){
                        setState(() {
                          this.barcode=barcode;

                        });
                      if(barcode==""){
                      Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Invalid QR code"),
                      ));
                    }
                    else{
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeTab()));
                      validate(barcode).then((String value){
                      if(value!=null){
                      saveAddressPreference(barcode,value);
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
                      });

                    },
                  ),
                  ),            
                ],
                )
              )
            ),
          );
        }
      }
      

