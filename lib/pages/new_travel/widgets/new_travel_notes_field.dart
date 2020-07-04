import 'package:flutter/material.dart';

class NewTravelNotesField extends StatelessWidget {
  final TextEditingController ctrl;
  NewTravelNotesField({this.ctrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          controller: ctrl,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
          expands: true,
          minLines: null,
          maxLines: null,
        ),
      ),
    );
  }
}