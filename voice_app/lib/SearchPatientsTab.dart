import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPatientsTab extends StatefulWidget{
  _SearchPatientsTab createState()=> _SearchPatientsTab();
}
 class _SearchPatientsTab extends State<SearchPatientsTab>{
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: new AppBar(
         title: new Text("Search Patients", style: new TextStyle(color: Colors.blueGrey)),
         centerTitle: true,
         backgroundColor: Colors.grey[100],
       ),
       body: Padding(
         padding: EdgeInsets.all(10.0),
         child: Container(
         child: Column(
           children: <Widget>[
             SizedBox(
               height: MediaQuery.of(context).size.height * 0.03,
             ),
             Container(
               child: new TextField(                    
                    decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 17),
                      hintText: 'Search your patients',
                      suffixIcon: Icon(Icons.search,size: 40.0,),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(20.0),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 4.0, color: Colors.blueGrey),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
             ),           
              ]
             ),                   
             )                      
       ),
       
       
     );
   }
 }