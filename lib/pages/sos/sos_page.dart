import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocation/geolocation.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:url_launcher/url_launcher.dart';

class SOSPage extends StatefulWidget {

  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  Future<String> getLocation() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(
      permission: LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );
    if(result.isSuccessful) {
      LocationResult result = await Geolocation.lastKnownLocation();
      return '${result.location.latitude}, ${result.location.longitude}';
    } else {
      print(result.error);
      return 'Can not get the current location at the moment!';
    }
  }

  void callHelp() async {
    const url = 'tel:112';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void smsHelp() async {
    String location = await getLocation();
    String url;
    if (Platform.isIOS) {
      url = 'sms:&body=Need help! My location: $location';
    } else {
      url = 'sms:?body=Need help! My location: $location';
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String sosProgress = ' ';
  bool disableFlashlightButton = false;

  @override
  Widget build(BuildContext context) {
    Future flashlightSOS (int time, String sign) async {
      for (int i = 0; i < 3; i++) {
        await TorchCompat.turnOn();
        setState(() {
          sosProgress += '$sign';
        });
        await Future.delayed(Duration(milliseconds: time), () async {
          await TorchCompat.turnOff();
        });
        await Future.delayed(Duration(milliseconds: 300), () {
          setState(() {
            sosProgress += ' ';
          });
        });
      }
      await Future.delayed(Duration(milliseconds: 600), () {
        setState(() {
          sosProgress += ' ';
        });
      });
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MountainAppBar(
                title: 'SOS',
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                trailing: Container(
                  width: 50,
                ),
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('My location', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                        Center(
                          child: FutureBuilder(
                            future: getLocation(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data);
                              } else if (snapshot.hasError) {
                                return Text('Error');
                              } else {
                                  return Center(child: CircularProgressIndicator(),);
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width / 4, right: MediaQuery.of(context).size.width / 4),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.lightGreen,
                            textColor: Colors.white,
                            child: Text('Call help (112)'),
                            onPressed: callHelp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width / 4, right: MediaQuery.of(context).size.width / 4),
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.lightGreen,
                            textColor: Colors.white,
                            child: Text('Send SOS SMS'),
                            onPressed: smsHelp,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20, left: MediaQuery.of(context).size.width / 4, right: MediaQuery.of(context).size.width / 4),
                          child: RaisedButton(

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            color: Colors.lightGreen,
                            textColor: Colors.white,
                            child: Text('SOS flashlight'),
                            onPressed: disableFlashlightButton ? null : () async {
                              setState(() {
                                disableFlashlightButton = true;
                              });
                              await flashlightSOS(300, '•');
                              await flashlightSOS(900, '–');
                              await flashlightSOS(300, '•');
                              setState(() {
                                sosProgress = ' ';
                                disableFlashlightButton = false;
                              });
                            },
                          ),
                        ),
                        Center(child: Text(sosProgress, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    TorchCompat.dispose();
    super.dispose();
  }
}
