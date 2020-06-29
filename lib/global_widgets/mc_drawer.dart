import 'package:flutter/material.dart';
import 'package:mountaincompanion/pages/travels/travels_page.dart';
import 'package:mountaincompanion/pages/weather/weather_page.dart';

class MCDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
            ),
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
                    title: Text('Mountain tracker '),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}