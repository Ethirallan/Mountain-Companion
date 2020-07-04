import 'package:flutter/material.dart';

class NewTravelSlideTitle extends StatelessWidget {
  final String title;
  NewTravelSlideTitle({this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 30,
          color: Colors.lightGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}