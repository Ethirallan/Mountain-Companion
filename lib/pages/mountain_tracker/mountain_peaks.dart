import 'package:flutter/material.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/models/mountain_peak_model.dart';
import 'package:latlong/latlong.dart';

class MountainPeaks extends StatelessWidget {
  final List data;
  final LatLng userPosition;
  MountainPeaks({this.data, this.userPosition});

  final Distance distance = new Distance();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [Colors.blue, Colors.green],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            children: <Widget>[
              MountainAppBar(
                title: 'Mountain peaks',
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
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      MountainPeakModel peak = new MountainPeakModel(
                        data[index]['id'],
                        data[index]['name'],
                        data[index]['lat'],
                        data[index]['lng'],
                        data[index]['height'],
                        DateTime.parse(data[index]['created']),
                      );

                      int distanceInM = distance(LatLng(double.parse(peak.lat), double.parse(peak.lng)), userPosition).floor();

                      String distanceString = '';

                      if (distanceInM > 1000) {
                        distanceString = (distanceInM / 1000).toString() + ' km';
                      } else {
                        distanceString = '$distanceInM m';
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(peak.name),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Location: ${peak.lat}, ${peak.lng}'),
                                Text('Height: ${peak.height}'),
                                Text('Distance: $distanceString'),
                              ],
                            ),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                        ),
                      );
                    },
                    itemCount: data.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
