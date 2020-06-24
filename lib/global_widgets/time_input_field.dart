import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimeInputField extends StatelessWidget {
  final String label;
  final DateTime time;
  final Function(DateTime) updateTime;

  TimeInputField({this.label, this.time, this.updateTime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
                height: 254,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CupertinoButton(
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                    Container(
                      height: 200,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (DateTime value) =>
                            updateTime(value),
                        mode: CupertinoDatePickerMode.dateAndTime,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: InputDecorator(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 10, top: 11),
            labelText: label),
        child: Text(
          DateFormat('dd. MM. yyyy, HH:mm').format(time),
        ),
      ),
    );
  }
}
