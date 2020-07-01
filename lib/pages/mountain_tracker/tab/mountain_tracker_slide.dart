import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocation/geolocation.dart';
import 'package:mountaincompanion/api/mountain_tracker.dart';
import 'package:mountaincompanion/models/mountain_peak_model.dart';
import 'package:user_location/user_location.dart';
import 'package:latlong/latlong.dart';

import '../mountain_peaks.dart';

class MountainTrackerSlide extends StatefulWidget {
  @override
  _MountainTrackerSlideState createState() => _MountainTrackerSlideState();
}

class _MountainTrackerSlideState extends State<MountainTrackerSlide> {
  MapController mapController = MapController();

  UserLocationOptions userLocationOptions;

  List<Marker> markers = [];
  List<CircleMarker> circleMarkers = [];

  List<LatLng> mountains = [];

  final Distance distance = Distance();

  var userPosition;

  Future<LatLng> getLocation() async {
    final GeolocationResult result = await Geolocation.requestLocationPermission(
      permission: LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );
    if(result.isSuccessful) {
      LocationResult result = await Geolocation.lastKnownLocation();
      return LatLng(result.location.latitude, result.location.longitude);
    } else {
      print(result.error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    void logMountain(List peaks) async {

      int distanceInM = 1000000;
      LatLng peakLocation;
      int peakId = 0;
      String mountainName;

      for (LatLng mountain in mountains) {
        var distancePeakUser = distance(mountain, userPosition).floor();
        if (distancePeakUser < distanceInM) {
          distanceInM = distancePeakUser;
          peakLocation = mountain;
        }
      }

      if (distanceInM <= 50) {

        for (var el in peaks) {
          if (el['lat'] == peakLocation.latitude.toString() && el['lng'] == peakLocation.longitude.toString()) {
            peakId = el['id'];
            mountainName = el['name'];
          }
        }

        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Successfully added $mountainName (distance $distanceInM m).'),
          ),
        );
        var data = {
          'mountain_peak_id' : peakId,
          'date' : new DateTime.now().toString()
        };
        await addNewMountainLog(data);
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content:
            Text('You are too far away from the nearest peak ($distanceInM m)!'),
          ),
        );
      }
    }

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      defaultZoom: 18,
      updateMapLocationOnPositionChange: false,
      onLocationUpdate: (LatLng pos) {
        userPosition = pos;
      },
      markerWidget: Icon(
        Icons.location_on,
        size: 40,
      ),
    );

    return FutureBuilder(
      future: getLocation(),
      builder: (context, snap) {
        if (snap.hasError) {
          return Center(
            child: Text('Error'),
          );
        } else if (snap.hasData) {
          userPosition = snap.data;
          return FutureBuilder(
            future: getMountainPeaks(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              } else if (snapshot.hasData) {
                List data = snapshot.data;
                for (var bla in data) {
                  MountainPeakModel peak = new MountainPeakModel(
                      bla['id'],
                      bla['name'],
                      bla['lat'],
                      bla['lng'],
                      bla['height'],
                      DateTime.parse(bla['created']));
                  LatLng pos =
                  new LatLng(double.parse(peak.lat), double.parse(peak.lng));

                  if (distance(userPosition, pos) < 10000) {
                    mountains.add(pos);
                    circleMarkers.add(CircleMarker(
                      point: pos,
                      color: Colors.blue.withOpacity(0.3),
                      borderStrokeWidth: 3.0,
                      borderColor: Colors.blue,
                      radius: 50,
                      useRadiusInMeter: true,
                    ));
                    markers.add(
                      Marker(
                        width: 10,
                        height: 10,
                        point: pos,
                        builder: (ctx) => Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                        ),
                      ),
                    );
                  }
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: FlutterMap(
                            options: MapOptions(
                              center: userPosition,
                              zoom: 18,
                              maxZoom: 19,
                              minZoom: 10,
                              plugins: [
                                // ADD THIS
                                UserLocationPlugin(),
                              ],
                            ),
                            layers: [
                              TileLayerOptions(
                                  urlTemplate:
                                  "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                  subdomains: ['a', 'b', 'c']),
                              MarkerLayerOptions(markers: markers),
                              CircleLayerOptions(
                                circles: circleMarkers,
                              ),
                              userLocationOptions,
                            ],
                            mapController: mapController,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: OpenContainer(
                        openBuilder: (BuildContext context, VoidCallback action) =>
                            MountainPeaks(
                                data: snapshot.data, userPosition: userPosition),
                        tappable: true,
                        closedElevation: 0,
                        closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15))),
                        transitionDuration: Duration(milliseconds: 500),
                        closedBuilder: (BuildContext context, VoidCallback action) =>
                            Container(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Show available mountains',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Colors.lightGreen,
                        textColor: Colors.white,
                        child: Text('Log the mountain'),
                        onPressed: () => logMountain(data),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
