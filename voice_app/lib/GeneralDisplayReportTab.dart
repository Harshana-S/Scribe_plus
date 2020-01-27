import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as localAuth;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:voice_app/HomeTab.dart';
import 'package:voice_app/NewPrescriptionTab.dart';
import 'package:voice_app/url.dart';
import 'package:intl/intl.dart';

class GeneralDisplayReportTab extends StatefulWidget {
  final String name,age,diagnosis,medicines,symptoms;
  GeneralDisplayReportTab({Key key, @ required this.name, @ required this.age, @ required this.diagnosis, @ required this.medicines, @ required this.symptoms}) : super(key: key);
  @override
  _GeneralDisplayReportTabState createState() => _GeneralDisplayReportTabState(this.name,this.age,this.diagnosis,this.medicines,this.symptoms);
}

class _GeneralDisplayReportTabState extends State<GeneralDisplayReportTab> with SingleTickerProviderStateMixin{
  TextEditingController nameController, ageController, symptomsController, diagnosisController, prescriptionController, remarksController, phoneNumberController, emailController;
  String name,age,diagnosis,medicines,symptoms,remarks;
  String docAddress;
  _GeneralDisplayReportTabState(this.name,this.age,this.diagnosis,this.medicines,this.symptoms);
  DateTime _dateTime;
  
  localAuth.LocalAuthentication localAuthentication=localAuth.LocalAuthentication();
  bool hasFingerPrint=false;
  bool notAuthenticatedFingerprint=true;
    Future<String> getPatientRecords() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getKeys());
    return sharedPreferences.getString("address");
  }

  Future<bool> checkBiometrics() async{
    
    try{
      bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
      return canCheckBiometrics;
      
    } on Exception catch(e){
      print(e.toString());
      
    }
    return false;
    
  }
  
  Future<void> _authenticate() async{
    bool authenticated=false;
    try{
      authenticated= await localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate to send report",
        stickyAuth: true,
      );
    } on PlatformException catch(e){
      print(e.message);
    }
    if(!mounted) return;
    setState(() {
      notAuthenticatedFingerprint=authenticated?false:true;
    });
  }

    


  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted);
    getPatientRecords().then((String address) async {
      print("$address");
      setState(() {
        docAddress = address;
      });
        });
    
    initialiseControllers();
    nameController.text=this.name;
    ageController.text=this.age;
    symptomsController.text=this.symptoms;
    diagnosisController.text=this.diagnosis;
    prescriptionController.text=this.medicines;
    remarksController.text='';
    print('NAme'+name);
    checkBiometrics().then((bool result){
      setState(() {
        hasFingerPrint=result;
        print(this.hasFingerPrint);
      });
      
    });
    
  } 

  Future<String> createPost(String url) async {
    Map<String, String> headers = {"Content-type": "application/json"};
    print("Entered");
    String req = '{"name":"'+nameController.text+'","age":"'+ageController.text+'","symptoms":"'+symptomsController.text+'","diagnosis":"'+diagnosisController.text+'","prescription":"'+prescriptionController.text+'","advice":"'+remarksController.text+'","phno":"'+phoneNumberController.text+'","email":"'+emailController.text+'","date":"28/01/2020", "doctorAddress" : "$docAddress"}';
    print(req);
   http.post(url, headers: headers, body: req).then((http.Response response) {
    final int statusCode = response.statusCode;
 
    if (statusCode < 200 || statusCode > 400 ) {
      print(statusCode);
      throw new Exception("Error while fetching data");

    }
    else
    {
      return (response.body);
    }
    
  });
} 
  void showSuccessDialog(){
    
  }
  

  void initialiseControllers(){
    nameController=TextEditingController();
    ageController=TextEditingController();
    symptomsController=TextEditingController();
    diagnosisController=TextEditingController();
    prescriptionController=TextEditingController();
    remarksController=TextEditingController();
    phoneNumberController=TextEditingController();
    emailController=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        centerTitle: true,
      ),
      body: Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[             
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  //keyboardType: TextInputType.multiline,
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ),               
              ],
            ),
              )
              ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Age",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),) ,              
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    decoration: InputDecoration(
                    border: OutlineInputBorder(),)
                  ),
                )   ,
                
                             
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Symptoms",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  //keyboardType: TextInputType.multiline,
                  controller: symptomsController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ),
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Diagnosis",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  //keyboardType: TextInputType.multiline,
                  controller: diagnosisController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ) ,                      
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Prescription",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  //keyboardType: TextInputType.multiline,
                  controller: prescriptionController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                
                ),                          
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Remarks",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  //keyboardType: TextInputType.multiline,
                  controller: remarksController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),                  
                ),                              
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Contact",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                ),              
                
              ],
            ),
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Email",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder())
                  ),
                )
                
              ],
            )
            )
            ,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            hasFingerPrint?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                notAuthenticatedFingerprint?
                FlatButton.icon(
                  icon: Icon(Icons.fingerprint,color:Colors.blueGrey,size:35.0),
                  label: Text("Authenticate"),
                  onPressed: _authenticate,
                ):
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  FlatButton.icon(
                  icon: Icon(Icons.fingerprint,color:Colors.green,size:35.0),
                  label: Text("Authenticated"),
                  onPressed: null,
                ),
                RaisedButton(
                  color: Colors.black,
                  child: Text("Send",style:TextStyle(color: Colors.white)),
                  onPressed:() async{
                    print("object");
                    await createPost('$ngrok_url/api/patient/create');
                    showDialog(
                      context: context,
                      builder: (_) {
                        return ShowSuccessDialog();
                      });
                  }
                )

                  ],
                )
                

              ],
            ):
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: HexColor('#00324B'),
                  child: Text("Send",style:TextStyle(color: Colors.white)),
                  onPressed:()=> print("object"),
                )
              ],
            )
            ],
        ),
      ),
    ) ,
    );


      
  }
}

class ShowSuccessDialog extends StatefulWidget {
  @override
  _ShowSuccessDialogState createState() => _ShowSuccessDialogState();
}

class _ShowSuccessDialogState extends State<ShowSuccessDialog> with TickerProviderStateMixin {
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
      super.initState();
        _controller =  AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
        );
        loadAsset("assets/send_successful.json").then((LottieComposition composition) {
          setState(() {
            _composition = composition;
            _controller.reset();
            _controller.forward();
            _controller.duration=Duration(seconds: 2);
          });
        });
        _controller.addListener(() => setState(() {}));
    }
  @override
  Widget build(BuildContext context) {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     // return object of type Dialog
        
          return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          title: new Center(child: Text("Sent Successfully")),
          content: Builder(
            builder: (BuildContext context){
            return  Container(
            width: 400 ,
            child: Lottie(
              composition: _composition,
              controller: _controller,
              size: const Size(300,200),
            ),
          );
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder:(context)=>HomeTab())
                );
              },
            ),
          ],

        );
        //   },
        // );
  }
}
