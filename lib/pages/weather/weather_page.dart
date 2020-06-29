import 'package:flutter/material.dart';
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
                child: FutureBuilder(
                  future: getWeatherMountains(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: EdgeInsets.all(16),
                        child: ListView(
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Katarina nad Ljubljano'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Katarina nad Ljubljano') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Kredarica'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Kredarica') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Lisca'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Lisca') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Rateče'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Rateče') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Slovenj Gradec'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Slovenj Gradec') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Vogel'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Vogel') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
                                title: Text('Vojsko'),
                                onTap: () {
                                  List data = [];
                                  for (var weather in snapshot.data) {
                                    if (weather['location'] == 'Vojsko') {
                                      data.add(weather);
                                    }
                                  }
                                  Navigator.push(context, new MaterialPageRoute(builder: (context) => WeatherDetails(data: data,)));
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator(),);
                    }
                  },
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
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      WeatherMountainModel weather = new WeatherMountainModel(data[index]['id'], data[index]['location'], data[index]['datetime'], data[index]['icon'], data[index]['description'], data[index]['t'], data[index]['wind_icon'], data[index]['wind_speed'], data[index]['wind_max_speed'], data[index]['p'], data[index]['p_tendency'], data[index]['rain'], data[index]['timestamp']);
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(weather.location),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(weather.datetime),
                              Text('Description: ' + (weather.description != '' ? weather.description : '/')),
                              Text('Temp: ${weather.t} ˚C'),
                              Text('Wind speed: ${weather.windSpeed} km/h'),
                              Text('Wind max speed: ${weather.windMaxSpeed} km/h'),
                              Text('Pressure: ${weather.p} hPa'),
                              Text('Rain in the last 24h: ${weather.rain} mm'),
                            ],
                          ),
                        ),
                      );
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