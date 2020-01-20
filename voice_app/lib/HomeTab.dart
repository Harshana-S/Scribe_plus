import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:voice_app/NewPrescriptionTab.dart';
import 'package:voice_app/ScanQRTab.dart';
import 'package:shared_preferences/shared_preferences.dart';



class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class HomeTab extends StatelessWidget {
  final MaterialColor primaryColorShades = MaterialColor(
  0xFF00324B,
  <int, Color>{
    50: Color(0xFFA4A4BF),
    100: Color(0xFFA4A4BF),
    200: Color(0xFFA4A4BF),
    300: Color(0xFF9191B3),
    400: Color(0xFF7F7FA6),
    500: Color(0xFF181861),
    600: Color(0xFF6D6D99),
    700: Color(0xFF5B5B8D),
    800: Color(0xFF494980),
    900: Color(0xFF181861),
  },
);
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: primaryColorShades
      ),
      home: VoiceHome(),

    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> with SingleTickerProviderStateMixin{
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  int currentTabIndex=0;
  List<Widget> tabs=[
    NewPrescriptionTab(),
    ScanQRTab()
  ];
  onTapped(int index){
    setState(() {
      currentTabIndex= index;
    });
  }

  @override
  void initState() { 
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Future _logout() async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey("address")){
      sharedPreferences.remove("address");
    }
    // print(sharedPreferences.getString("address"));
    
    // print(sharedPreferences.getString("address"));

  }
 
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Voice Prescription"),
        centerTitle: true,
        elevation: defaultTargetPlatform == TargetPlatform.android? 5.0: 0.0 ,
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Harshana"),
                accountEmail: new Text("hana.8500@gmail.com"),
                decoration: new BoxDecoration(
                  color: Colors.green
                ),
                arrowColor: Colors.white,
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text("H",style: new TextStyle(
                    fontSize: 40.0
                  ),),
                ),
                ),
            new ListTile(
              title: new Text("Home"),
              trailing: new Icon(Icons.home),
            ),
            new ListTile(
              title: new Text("Profile"),
              trailing: new Icon(Icons.person),
            ),
            new ListTile(
              title: new Text("Wallet"),
              trailing: new Icon(Icons.attach_money),
            ),
            new Divider(
              height: 60.0,
            ),
            new ListTile(
              title: new Text("Log out"),
              trailing: new Icon(Icons.exit_to_app),
              onTap: (){
                
                print("log out tapped");
                _logout();
                SystemNavigator.pop();
              },
            )
          ],
        ),
      ),
      body: tabs[currentTabIndex],
      bottomNavigationBar: new BottomNavigationBar(
        onTap: onTapped,
        currentIndex: currentTabIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: new Text("New Patient")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              title: new Text("Existing Patient")
            )
          ],
      ),
    );
  }
}


