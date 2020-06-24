import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateInputField extends StatelessWidget {
  final String label;
  final DateTime date;
  final Function(DateTime) updateDate;

  DateInputField({this.label, this.date, this.updateDate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (Platform.isAndroid) {
          Future<DateTime> selectedDate = showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2018),
            lastDate: DateTime(2030),
            builder: (BuildContext context, Widget child) {
              return Theme(
                data: ThemeData.light(),
                child: child,
              );
            },
          );
          DateTime newDate = await selectedDate;
          if (newDate != null) {
            updateDate(newDate);
          }
        } else {
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
                          onDateTimeChanged: (DateTime value) => updateDate(value),
                          mode: CupertinoDatePickerMode.date,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          ),
          child: Text(
            DateFormat('dd. MM. yyyy').format(date),
          ),
        ),
      ),
    );
  }
}