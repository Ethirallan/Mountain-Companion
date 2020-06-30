import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:latlong/latlong.dart';
import 'package:user_location/user_location.dart';

class MountainTrackerPage extends StatefulWidget {
  @override
  _MountainTrackerPageState createState() => _MountainTrackerPageState();
}

class _MountainTrackerPageState extends State<MountainTrackerPage> {
  MapController mapController = MapController();

  UserLocationOptions userLocationOptions;

  List<Marker> markers = [];

  List<LatLng> mountains = [LatLng(45.548243, 13.729533),];

  final Distance distance = Distance();

  var userPosition;

  @override
  Widget build(BuildContext context) {

    void logMountain(BuildContext context) {
      for (LatLng mountain in mountains) {
        int distanceInM = distance(mountain, userPosition).floor();
        if (distanceInM <= 50) {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Congrats! Added new mountain (distance $distanceInM m).'),),);
        } else {
          Scaffold.of(context).showSnackBar(SnackBar(content: Text('You are too far away from the peak ($distanceInM m)!'),),);
        }
      }
    }

    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
      defaultZoom: 18,
      updateMapLocationOnPositionChange: true,
      onLocationUpdate: (LatLng pos) {
        userPosition = pos;
      },
      markerWidget: Icon(Icons.location_on, size: 40,),
    );
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
                title: 'Mountain tracker',
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
                  padding: EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(45.54730224609375, 13.72856426002181),
                        zoom: 18,
                        maxZoom: 19,
                        minZoom: 14,
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
                          circles: [
                            CircleMarker(
                              point: LatLng(45.548243, 13.729533),
                              color: Colors.blue.withOpacity(0.3),
                              borderStrokeWidth: 3.0,
                              borderColor: Colors.blue,
                              radius: 50,
                              useRadiusInMeter: true,
                            ),
                          ],
                        ),
                        userLocationOptions,
                      ],
                      mapController: mapController,
                    ),
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  return Center(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      color: Colors.lightGreen,
                      textColor: Colors.white,
                      child: Text('Log the mountain'),
                      onPressed: () => logMountain(context),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
