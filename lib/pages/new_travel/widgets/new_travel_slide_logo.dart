import 'package:flutter/material.dart';

class NewTravelSlideLogo extends StatelessWidget {
  final IconData iconData;
  NewTravelSlideLogo({this.iconData});

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: Colors.lightGreen,
      size: 160,
    );
  }
}