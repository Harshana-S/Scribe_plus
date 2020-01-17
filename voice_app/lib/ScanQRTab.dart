import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:voice_app/DisplayPatientPage.dart';

class ScanQRTab extends StatefulWidget {

  _ScanQRTab createState() => _ScanQRTab();
}

class _ScanQRTab extends State<ScanQRTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  String barcode = '';
  Uint8List bytes = Uint8List(200);
  bool _ownPatient= true;
  String otp='';
  bool _resultOTP=true;
 
  Future _scan() async {
    String barcode = await scanner.scan();
    setState((){
      this.barcode = barcode;
      print(barcode);//Convert to JSON and Send
    } );
  }

  // Future _scanPhoto() async {
  //   String barcode = await scanner.scanPhoto();
  //   setState(() => this.barcode = barcode);
  // }
    
  @override
  void initState() {
    super.initState();
    searchPatient();
  }
  void searchPatient(){//Function to check if json is null or not
  
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
          title: new Text("Enter OTP"),
          content: Container(
            child: PinEntryTextField(
              showFieldAsBox: false,
              onSubmit: (String pin){
                setState(() {
                  otp=pin;
                });
              },
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            // new FlatButton(
            //   child: new Text("Resend OTP"),
            //   onPressed: (){
            //     print("resend OTP is pressed");
              
            //   },
            // ),
            new FlatButton(
              child: Text("Submit"),
              onPressed: (){
                print("OK is pressed:"+otp);//Send otp as JSON
                setState(() {
                  _resultOTP=true;//Write a function to send the otp and returns boolean
                });                
                if(_resultOTP){
                  Navigator.of(context).pop();
                  Navigator.of(_scaffoldKey.currentContext).push(MaterialPageRoute(builder: (context)=>DisplayPatientPage()));
                }
                else{
                  final snackBar = SnackBar(content: Text('Invalid OTP'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  Navigator.of(context).pop();
                  
                }
                
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
            
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: <Widget>[
        //     Text('Patient\'s Address:', style: new TextStyle(
        //       color: Colors.blueGrey,
        //       fontSize: 25.0,
        //       fontWeight: FontWeight.bold
        //     ),
        //     textAlign: TextAlign.center,),
        //     SizedBox(
        //           height: 40.0,
        //       ), 
        //     Container(
        //       width: MediaQuery.of(context).size.width * 0.9,
        //       child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: <Widget>[
        //         Text('$barcode',
        //             style: new TextStyle(
        //             color: Colors.greenAccent,
        //             fontSize: 17.0,
        //             fontWeight: FontWeight.bold
        //             ),
        //             textAlign: TextAlign.center,
                    
        //            ),                   
                    
        //           FlatButton(
        //         child: Icon(
        //           Icons.content_copy
        //         ),
        //         onPressed: (){
        //           ClipboardManager.copyToClipBoard(barcode).then((result) {
        //                   final snackBar = SnackBar(
        //                     content: Text('Copied to Clipboard'),
        //                     action: SnackBarAction(
        //                       label: 'Undo',
        //                       onPressed: () {},
        //                     ),
        //                   );
        //                   Scaffold.of(context).showSnackBar(snackBar);
        //                 });
        //         },
        //         ),
                  
              
                
        //       ]),
        //       decoration: BoxDecoration(
        //               border: Border.all(
        //                 color: Colors.blueGrey,
        //                 width: 4.0,
        //               ),
        //               borderRadius: BorderRadius.all(Radius.circular(20.0))
        //             ),
        //     ),    
        //     Container(
        //       child: SizedBox(
        //       width: 50,
        //       height: 50,
        //       child: Image.memory(bytes),
        //     ),
        //     ),         
        //       // SizedBox(
        //       //     height: 80.0,
        //       // ),   
        //       Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //       children: <Widget>[
        //         RaisedButton(
        //         onPressed: _scan,
        //         child: Text("Scan",style: new TextStyle(color: Colors.white)),
        //         color: Colors.blueGrey,
        //         shape: RoundedRectangleBorder(
        //             borderRadius: new BorderRadius.circular(20.0),
        //             side: BorderSide(color: Colors.blueGrey),
        //             ),
        //          ),
        //         RaisedButton(
        //           onPressed: _scanPhoto,
        //           child: Text("Scan Photo",style: new TextStyle(color: Colors.white),),
        //           color: Colors.blueGrey,
        //           shape: RoundedRectangleBorder(
        //             borderRadius: new BorderRadius.circular(20.0),
        //             side: BorderSide(color: Colors.blueGrey)
        //             ),
        //         ),

        //       ],
        //     ),
            

        //   ],
        // ),
        ));
  }
  
}

