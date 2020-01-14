import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_recognition/speech_recognition.dart';

class NewPrescriptionTab extends StatefulWidget {
  @override
  _NewPrescriptionTabState createState() => _NewPrescriptionTabState();
}

class _NewPrescriptionTabState extends State<NewPrescriptionTab> {
  SpeechRecognition _speechRecognition = SpeechRecognition();
  bool _isListening = false;
  bool _isAvailable=false;
  String transcriptionText='';
  String finalReport='';
  bool _displayText=false;
  TextEditingController transcriptionController;

  @override
  void initState() {
    super.initState();
    transcriptionController= TextEditingController();
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
       transcriptionText = text;
       transcriptionController.text=transcriptionText;
    }));

    _speechRecognition.setRecognitionCompleteHandler(()
    => setState(() => _isListening = false));
    
    _speechRecognition//1st Launch- asking the user for audio permissions.
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
    body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
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
                          _displayText=true;
                          finalReport=finalReport+' '+transcriptionController.text;
                          transcriptionController.text='';
                        });
                        break;
                      default:
                      print(direction);
                    }
                  },
                ),
                _isListening? 
                FloatingActionButton(
                child: Icon(Icons.stop),
                backgroundColor:Colors.blueGrey,
                onPressed: (){
                  if(_isListening){
                    _speechRecognition.stop().then((result)=> setState((){
                      _isListening = result;
                    }));
                  }
                },
                ):
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.blueGrey,
                  onPressed: (){
                    if(_isAvailable && !_isListening){
                      _speechRecognition.listen(locale: "en_IN").then((result){
                        print(result);
                      setState(() {
                        print(result);
                        transcriptionText=result;
                        transcriptionController.text=transcriptionText;
                      });
                    });
                  }}),
              ],
            ),
          ),
        _displayText? Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("Prescription"),
              Card(
              color: Colors.blueGrey[150],
              elevation: 20.0,
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(finalReport),
              ),
            ),
            RaisedButton(
              child: Text("Generate Report",style: TextStyle(
                color: Colors.white
              ),),
              color: Colors.green[300],
              onPressed: (){
                print("Generate Report");
              },
            )
            ],
          )
        ) : SizedBox(width: 10.0,)
        
        ],
      ),
    ),
    
    
      
    );
  }
}