import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as localAuth;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class GeneralDisplayReportTab extends StatefulWidget {
  final String textFromVoice;
  GeneralDisplayReportTab({Key key, @ required this.textFromVoice}) : super(key: key);
  @override
  _GeneralDisplayReportTabState createState() => _GeneralDisplayReportTabState();
}

class _GeneralDisplayReportTabState extends State<GeneralDisplayReportTab> {
  TextEditingController nameController, ageController, symptomsController, diagnosisController, prescriptionController, remarksController, phoneNumberController, emailController;
  String _name, _age, _symptoms, _diagnosis, _prescription, _remarks;

  localAuth.LocalAuthentication localAuthentication=localAuth.LocalAuthentication();
  bool hasFingerPrint=false;
  bool notAuthenticatedFingerprint=true;

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
    initialiseFromJSON();
    initialiseControllers();
    nameController.text=_name;
    ageController.text=_age;
    symptomsController.text=_symptoms;
    diagnosisController.text=_diagnosis;
    prescriptionController.text=_prescription;
    remarksController.text=_remarks;
    print("object");
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
    String req = '{"name":"'+nameController.text+'","age":"'+ageController.text+'","symptoms":"'+symptomsController.text+'","diagnosis":"'+diagnosisController.text+'","prescription":"'+prescriptionController.text+'","advice":"'+remarksController.text+'","phno":"'+phoneNumberController.text+'","email":"'+emailController.text+'","date":"20/01/2020"}';
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
  void initialiseFromJSON(){
    _name="Name";
    _age="23";
    _symptoms="Cough Cold";
    _diagnosis="Fever";
    _prescription="Dolo650 Crocin";
    _remarks="remarks";
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
                  color: Colors.green,
                  child: Text("Send",style:TextStyle(color: Colors.white)),
                  onPressed:() async=> {
                    print("object"),
                    await createPost('http://c68ee564.ngrok.io/api/patient/create')
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
                  color: Colors.green,
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