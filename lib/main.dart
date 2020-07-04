import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mountaincompanion/pages/login/login_page.dart';
import 'package:mountaincompanion/pages/travels/travels_page.dart';

void main() => runApp(App());

class App extends StatefulWidget {

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  Future getUser() async {
    var user = await _auth.currentUser();
    if (user == null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.green,
          cursorColor: Colors.green,
        ),
        home: FutureBuilder(
          future: getUser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data == false ? LoginPage() : TravelsPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}