import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';
//import 'package:flutter/foundation.dart';

class AddPrescriptionTab extends StatefulWidget{
  @override 
  _AddPrescriptionTab createState() => _AddPrescriptionTab();
}

class _AddPrescriptionTab extends State<AddPrescriptionTab>{
  
  SpeechRecognition _speechRecognition;
  bool _isAvailable=false;
  bool _isListening= false;
  String resultText="";

  @override
  void initState(){
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition= SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result)
    => setState(() => _isAvailable = result));

    _speechRecognition.setRecognitionStartedHandler(()
    => setState(() => _isListening = true));

    _speechRecognition.setRecognitionResultHandler((String text)
    => setState((){
       resultText = text;
    }));

    _speechRecognition.setRecognitionCompleteHandler(()
    => setState(() => _isListening = false));

    _speechRecognition
        .activate()
        .then((res) => setState(() => _isAvailable = res));
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: new AppBar(
      title: new Text("Add Prescription", style: new TextStyle(color: Colors.blueGrey),),
      centerTitle: true,
      backgroundColor: Colors.grey[100],
    ),
    body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                color: Colors.white60,
                border: Border.all(width: 4.0, color: Colors.blueGrey),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Text(resultText),
            ),
            Container(
              height:  MediaQuery.of(context).size.height * 0.1 ,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                FloatingActionButton(
                    child: Icon(Icons.mic),
                    backgroundColor: Colors.blueGrey,
                    onPressed: (){
                      if(_isAvailable && !_isListening){
                        _speechRecognition.listen(locale: "en_US").then((result){
                          print("Start Recording");
                          print(result);
                          print(_isAvailable);
                          print(_isListening); });
                      }
                    }),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  backgroundColor:Colors.blueGrey,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.stop().then((result)=> setState((){
                        print("Stop button");
                        _isListening = result;
                        print(_isAvailable);
                        print(_isListening);
                      }));
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.blueGrey,
                  onPressed: (){
                    if(_isListening){
                      _speechRecognition.cancel().then((result)=> setState(() {
                        _isListening = result ;
                        resultText="";
                        print("Cancel button");
                        print(_isAvailable);
                        print(_isListening);}));
                    }
                  },
                )
              ],
            ),

          ],
          
        ),
      ),
  );
}
}

