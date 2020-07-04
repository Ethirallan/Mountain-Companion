import 'package:flutter/material.dart';

class MountainAppBar extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  MountainAppBar({this.title, this.leading, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          leading,
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}