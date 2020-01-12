import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:clipboard_manager/clipboard_manager.dart';

class ScanQRTab extends StatefulWidget {

  _ScanQRTab createState() => _ScanQRTab();
}

class _ScanQRTab extends State<ScanQRTab> {
  
   String barcode = '';
  Uint8List bytes = Uint8List(200);

 
  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    setState(() => this.barcode = barcode);
  }
    
  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Patient\'s Address:', style: new TextStyle(
              color: Colors.blueGrey,
              fontSize: 25.0,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,),
            SizedBox(
                  height: 40.0,
              ), 
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('$barcode',
                    style: new TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                    
                   ),                   
                    
                  FlatButton(
                child: Icon(
                  Icons.content_copy
                ),
                onPressed: (){
                  ClipboardManager.copyToClipBoard(barcode).then((result) {
                          final snackBar = SnackBar(
                            content: Text('Copied to Clipboard'),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {},
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        });
                },
                ),
                  
              
                
              ]),
              decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueGrey,
                        width: 4.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
            ),    
            Container(
              child: SizedBox(
              width: 50,
              height: 50,
              child: Image.memory(bytes),
            ),
            ),         
              // SizedBox(
              //     height: 80.0,
              // ),   
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                onPressed: _scan,
                child: Text("Scan",style: new TextStyle(color: Colors.white)),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blueGrey),
                    ),
                 ),
                RaisedButton(
                  onPressed: _scanPhoto,
                  child: Text("Scan Photo",style: new TextStyle(color: Colors.white),),
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.blueGrey)
                    ),
                ),

              ],
            ),
            

          ],
        ),
      ),
    );
  }
  
}

