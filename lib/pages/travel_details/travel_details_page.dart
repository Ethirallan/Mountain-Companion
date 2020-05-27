import 'package:flutter/material.dart';

class TravelDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text('Go back'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}
