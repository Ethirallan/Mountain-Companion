import 'package:flutter/material.dart';

class TravelCardButton extends StatelessWidget {
  final IconData icon;
  final double left;
  final double top;
  TravelCardButton({this.icon, this.left, this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 40,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.lightGreen,
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: Icon(icon, color: Colors.white,),
      ),
    );
  }
}