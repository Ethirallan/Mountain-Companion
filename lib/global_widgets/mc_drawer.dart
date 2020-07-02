import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mountaincompanion/pages/login/login_page.dart';
import 'package:mountaincompanion/pages/mountain_tracker/mountain_tracker_page.dart';
import 'package:mountaincompanion/pages/sos/sos_page.dart';
import 'package:mountaincompanion/pages/travels/travels_page.dart';
import 'package:mountaincompanion/pages/weather/weather_page.dart';

class MCDrawer extends StatefulWidget {
  @override
  _MCDrawerState createState() => _MCDrawerState();
}

class _MCDrawerState extends State<MCDrawer> {
  Image backgroundImage;

  @override
  void initState() {
    super.initState();
    backgroundImage = Image.asset('assets/default_background.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(backgroundImage.image, context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            backgroundImage,
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Travels'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => TravelsPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Weather'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => WeatherPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Mountain tracker'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => MountainTrackerPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('SOS'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                          builder: (context) => SOSPage(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text('Logout'),
                    onTap: () async {
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      if (await _auth.currentUser() != null) {
                        await _auth.signOut();
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                      }
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
            Expanded(
                child: Align(
              child: Container(
                child: Image.asset('assets/mc-logo.png'),
                height: 140,
              ),
              alignment: Alignment.bottomCenter,
            )),
          ],
        ),
      ),
    );
  }
}
