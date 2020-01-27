import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:voice_app/GeneralDisplayReportTab.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:voice_app/HomeTab.dart';
import 'package:voice_app/url.dart';

class NewPrescriptionTab extends StatefulWidget {
  @override
  _NewPrescriptionTabState createState() => _NewPrescriptionTabState();
}

class _NewPrescriptionTabState extends State<NewPrescriptionTab> with TickerProviderStateMixin {
  SpeechRecognition _speechRecognition = SpeechRecognition();
  bool _isListening = false;
  bool _isAvailable=false;
  String transcriptionText='';
  String finalReport='';
  bool _displayText=false;
  TextEditingController transcriptionController;
  String name,age,diagnosis,medicines,symptoms;
  LottieComposition _composition;
  AnimationController _controller;
  

  Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) =>  LottieComposition.fromMap(map));
  }

@override
dispose() {
  _controller.dispose(); // you need this
  super.dispose();
}
  @override
  void initState() {
    super.initState();
    transcriptionController= TextEditingController();
    
    initSpeechRecognizer();
    name='';
    age='';
    diagnosis='';
    medicines='';
    symptoms='';
  }
  
  void initSpeechRecognizer(){
    
    _speechRecognition= SpeechRecognition();
    try{
      _speechRecognition.setAvailabilityHandler((bool result)
    => setState(() => _isAvailable = result));

    _speechRecognition.setRecognitionStartedHandler(()
    => setState(() => _isListening = true));

    _speechRecognition.setRecognitionResultHandler((String text)
    => setState((){
       transcriptionText = text;
       transcriptionController.text=transcriptionText;
    }));

    _speechRecognition.setRecognitionCompleteHandler(()
    => setState(() => _isListening = false));
    
    
    _speechRecognition//1st Launch- asking the user for audio permissions.
        .activate()
        .then((res) => setState(() => _isAvailable = res));
    
    }on Exception catch(e){
      print(e.toString());
    }
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: new AppBar(
    //   title: new Text("New Patient", style: new TextStyle(color: Colors.black),),
    //   centerTitle: true,
    //   backgroundColor: Colors.grey[100],
    // ),
    resizeToAvoidBottomInset: false,
    resizeToAvoidBottomPadding: false,
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
           _displayText?
           SizedBox(
            height: 40,
            ):
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
          Container(
            child: Column(
              children: <Widget>[
                _isListening? 
                Column(children: <Widget>[
                Container(
                  height: 80,
                  child: FittedBox(
                  child: FloatingActionButton(
                  heroTag: "stop",
                  child: Icon(Icons.stop, size: 40,),
                  backgroundColor: Colors.black,
                onPressed: (){
                  setState(() {
                    _controller.reset();
                  });
                  try{
                    if(_isListening){
                    _speechRecognition.stop().then((result)=> setState((){
                      _isListening = result;
                    }));
                  }
                  } on Exception catch(e){
                    print(e.toString());
                  }
                  
                },
                ),
                  
                ),
                ),
                SizedBox(
                  height: 100,
                ),                
                ],)
                :
                Column(
                  children: <Widget>[
                  Container(
                  height: 80,
                  child: FittedBox(
                  child: FloatingActionButton(
                  heroTag: "mic",
                  child: Icon(Icons.mic, size: 40,),
                  backgroundColor: Colors.black,
                  onPressed: (){
                    try{
                      if(_isAvailable && !_isListening){
                      _speechRecognition.listen(locale: "en_IN").then((result){
                        print(result);
                      setState(() {
                        print(result);
                        transcriptionText=result;
                        transcriptionController.text=transcriptionText;
                      });
                    });
                  }
                    } on Exception catch(e){
                      print(e.toString());
                    }
                    }),
                  ),
                  ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
                Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.green),
                  secondaryBackground: Container(color: Colors.red),
                  child: new Padding(
                    padding: EdgeInsets.all(20.0),
                    child: new TextField(
                            controller: transcriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Swipe right to accept',
                            )
                          ),
                  ),
                  onDismissed:(direction){
                    switch (direction) {
                      case DismissDirection.endToStart:
                        setState(() {
                          transcriptionController.text='';
                        });                  
                        break;
                      case DismissDirection.startToEnd:
                        setState(() {
                          if(transcriptionController.text!=''){
                            _displayText=true;
                          }                          
                          finalReport=finalReport+' '+transcriptionController.text;
                          transcriptionController.text='';
                        });
                        break;
                      default:
                      print(direction);
                    }
                  },
                ),                  
              ],
            ),
          ),

        _displayText? 
        Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
                      Divider(),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
                Container(
          width: 40,
          height: 40,
          child: FittedBox(
            child: FloatingActionButton(
            heroTag: "delete",
           child: Icon(Icons.delete_forever, color:Colors.white, size: 30,),
            backgroundColor: Colors.black,
            // child: Text("Reset", style: TextStyle(color: Colors.white),),
            onPressed: (){
              setState(() {
                _displayText=false;
              });
            },
          ),
          ),
        ),        
        Text("PRESCRIPTION",
        style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 4,
                      fontSize: 15,
                      fontWeight: FontWeight.w300
                    ),),
        Container(
          width: 40,
          height: 40,
          child: FittedBox(
            child: FloatingActionButton(
            heroTag: "send",
           child: Icon(Icons.send, color:Colors.white, size: 30,),
            backgroundColor: Colors.black,
            // child: Text("Reset", style: TextStyle(color: Colors.white),),
              onPressed: (){
                if(_displayText){
                              Map<String, String> headers = {"Content-type": "application/json"};
                 String req = '{"text" :"$finalReport"}';
                 http.post("$ngrok_url/api/patient/getName", headers: headers, body: req).then((http.Response response) {
                  final int statusCode = response.statusCode;             
                  if (statusCode < 200 || statusCode > 400 ) {
                    print(statusCode);
                    throw new Exception("Error while fetching data");

                  }
                  else
                  {
                    print(response.body);

                    var model = json.decode(response.body);
                    setState(() {
                      this.name=model['name'].toString();
                      print(this.name);
                    });       
              //String diagnosis=response.body['response']['Diagnosis'];
                  }
                });
                 print("Entered");
                
                print(req);
                http.post("$ngrok_flask_url/api/flaskcall", headers: headers, body: req).then((http.Response response) {
                  final int statusCode = response.statusCode;             
                  if (statusCode < 200 || statusCode > 400 ) {
                    print(statusCode);
                    throw new Exception("Error while fetching data");

                  }
                  else
                  {
                    print(response.body);

                    var model = json.decode(response.body);
                    
                    String diagnosis='';
                    print(model['response']['DIAGNOSIS']);
                    for(var item in model['response']['DIAGNOSIS'][0] ){
                      diagnosis=diagnosis+item.toString()+' ';

                    }
                    String medicines='';
                    for(var item in model['response']['MEDICINE'][0] ){
                      item.toString();
                      medicines=medicines+item.toString()+' ';
                    }
                    String symptoms='';
                    for(var item in model['response']['SYMPTOMS'][0] ){
                      item.toString();
                      symptoms=symptoms+item.toString()+' ';
                    }
                    print(symptoms);
                    print(medicines);
                    print(diagnosis);
                    Navigator.push(context, 
                MaterialPageRoute(
                  builder:(context)=>
                GeneralDisplayReportTab(name: this.name,age: this.age,medicines: medicines,symptoms: symptoms,diagnosis: diagnosis))
                );
                    setState(() {
                      this.diagnosis=diagnosis;
                      this.medicines=medicines;
                      this.symptoms=symptoms;
                      this.age='32';
                    });

                    

                    //String diagnosis=response.body['response']['Diagnosis'];
                  }
                });
                print('Name0'+this.name);
                }
     
                  
              },
          ),
          ),
        ),
        ],),
        Padding(
          padding: EdgeInsets.all(40),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 40),
            child: Container( 
                width: MediaQuery.of(context).size.width*0.80,               
                child: Text(finalReport,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 2.5
                ),
                ),
              ),
          )

        )
              
            ],
          )
          
        :
        SizedBox(),
        ],
      ),
    ),
    
    
      
    );
  }
}