import 'package:flutter/material.dart';

Widget loadingDialog = WillPopScope(
  onWillPop: () async {
    return new Future(() => false);
  },
  child: AlertDialog(
    content: Row(
      children: <Widget>[
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Please wait ...',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
      ],
    ),
  ),
);