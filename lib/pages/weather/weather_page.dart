import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mountaincompanion/api/weather.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/pages/weather/weather_card.dart';

class WeatherPage extends StatelessWidget {
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
                title: 'Weather',
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
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: FutureBuilder(
                    future: getWeatherMountains(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimationLimiter(
                          child: ListView(
                            children: <Widget>[
                              WeatherCard(
                                index: 0,
                                label: 'Katarina nad Ljubljano',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 1,
                                label: 'Kredarica',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 2,
                                label: 'Lisca',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 3,
                                label: 'Rateče',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 4,
                                label: 'Slovenj Gradec',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 5,
                                label: 'Vogel',
                                snapshotData: snapshot.data,
                              ),
                              WeatherCard(
                                index: 6,
                                label: 'Vojsko',
                                snapshotData: snapshot.data,
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
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