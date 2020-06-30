import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mountaincompanion/api/weather.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/models/weather_mountain_model.dart';

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

class WeatherDetails extends StatelessWidget {
  final List data;
  WeatherDetails({this.data});
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
            children: <Widget>[
              MountainAppBar(
                title: 'Weather history',
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
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        WeatherMountainModel weather = new WeatherMountainModel(
                            data[index]['id'],
                            data[index]['location'],
                            data[index]['datetime'],
                            data[index]['icon'],
                            data[index]['description'],
                            data[index]['t'],
                            data[index]['wind_icon'],
                            data[index]['wind_speed'],
                            data[index]['wind_max_speed'],
                            data[index]['p'],
                            data[index]['p_tendency'],
                            data[index]['rain'],
                            data[index]['timestamp']);
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: Duration(milliseconds: 300),
                          duration: Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 50,
                            horizontalOffset: 300,
                            child: FadeInAnimation(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  title: Text(weather.location),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(weather.datetime),
                                      Text('Description: ' +
                                          (weather.description != ''
                                              ? weather.description
                                              : '/')),
                                      Text('Temp: ${weather.t} ˚C'),
                                      Text('Wind speed: ${weather.windSpeed} km/h'),
                                      Text(
                                          'Wind max speed: ${weather.windMaxSpeed} km/h'),
                                      Text('Pressure: ${weather.p} hPa'),
                                      Text('Rain in the last 24h: ${weather.rain} mm'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
}

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
