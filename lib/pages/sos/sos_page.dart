import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';

class SOSPage extends StatelessWidget {

  Future<String> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return '${position.latitude}, ${position.longitude}';
  }

  Geolocator _geolocator = new Geolocator();

  Future<Position> getCurrentPosition() async {
    Position position;
    GeolocationStatus status = await _geolocator.checkGeolocationPermissionStatus();

    if (status != GeolocationStatus.disabled) {
      position = await _geolocator.getLastKnownPosition();

      if (position == null && status == GeolocationStatus.granted) {
        position = await _geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          locationPermissionLevel: GeolocationPermission.locationWhenInUse,
        );
      }
    }

    return position;
  }

  @override
  Widget build(BuildContext context) {

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
              SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height - 92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('My location', textAlign: TextAlign.center,),
                      FutureBuilder(
                        future: getCurrentPosition(),
                        builder: (context, snapshot) {
                          print(snapshot);
                          if (snapshot.hasData) {
                            return Text(snapshot.data);
                          } else if (snapshot.hasError) {
                            return Text('Error');
                          } else {
                              return Center(child: CircularProgressIndicator(),);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
