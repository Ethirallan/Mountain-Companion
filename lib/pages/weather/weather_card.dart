import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mountaincompanion/pages/weather/weather_details.dart';

class WeatherCard extends StatelessWidget {
  final int index;
  final String label;
  final List snapshotData;
  WeatherCard({this.index, this.label, this.snapshotData});
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: Duration(milliseconds: 300),
      duration: Duration(milliseconds: 500),
      child: SlideAnimation(
        verticalOffset: 50,
        horizontalOffset: 300,
        child: FadeInAnimation(
          child: Card(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              title: Text(label),
              onTap: () {
                List data = [];
                for (var weather in snapshotData) {
                  if (weather['location'] == label) {
                    data.add(weather);
                  }
                }
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => WeatherDetails(
                      data: data,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}