import 'package:flutter/material.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/pages/mountain_tracker/tab/mountain_log_slide.dart';
import 'package:mountaincompanion/pages/mountain_tracker/tab/mountain_tracker_slide.dart';

class MountainTrackerPage extends StatefulWidget {
  @override
  _MountainTrackerPageState createState() => _MountainTrackerPageState();
}

class _MountainTrackerPageState extends State<MountainTrackerPage> {

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    MountainTrackerSlide(),
    MountainLogSlide(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
              Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.my_location),
              title: Text('Tracker'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assessment),
              title: Text('Log'),
            ),
          ],
          backgroundColor: Colors.lightGreen,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}



