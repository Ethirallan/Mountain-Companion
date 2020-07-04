import 'package:flutter/material.dart';
import 'package:mountaincompanion/global_widgets/time_input_field.dart';
import 'package:mountaincompanion/models/stop_model.dart';

class NewStopDialog extends StatefulWidget {
  final List<StopModel> stops;
  final int index;
  final int duplicateIndex;

  NewStopDialog({this.stops, this.index, this.duplicateIndex});

  @override
  _NewStopDialogState createState() => _NewStopDialogState();
}

class _NewStopDialogState extends State<NewStopDialog> {
  final TextEditingController locationCtrl = new TextEditingController();
  final TextEditingController heightCtrl = new TextEditingController();
  DateTime dateTime = DateTime.now();


  String title = 'Create new Location';
  @override
  Widget build(BuildContext context) {
    if (widget.index != null) {
      StopModel stop = widget.stops[widget.index];
      locationCtrl.text = stop.location;
      heightCtrl.text = stop.height.toString();
//      dateTime = DateTime.parse(stop.time);
      title = 'Update location';
    } else if(widget.duplicateIndex != null) {
      StopModel stop = widget.stops[widget.duplicateIndex];
      locationCtrl.text = stop.location;
      heightCtrl.text = stop.height.toString();
//      dateTime = DateTime.parse(stop.time); // TODO: problem??
    }

    return AlertDialog(
      title: Text(title),
      content: Container(
        height: 176,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: locationCtrl,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 11, top: 11),
                  labelText: 'Location'),
            ),
            TextFormField(
              controller: heightCtrl,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 11, top: 11),
                  labelText: 'See level height'),
              keyboardType: TextInputType.numberWithOptions(),
            ),
            TimeInputField(
              label: 'Date and Time',
              time: dateTime,
              updateTime: (DateTime value) {
                setState(() {
                  dateTime = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () {
            StopModel newStop = new StopModel(
                locationCtrl.text, int.parse(heightCtrl.text), dateTime.toIso8601String());
            setState(() {
              if (widget.index != null) {
                widget.stops[widget.index] = newStop;
              } else {
                widget.stops.add(newStop);
              }
            });
            Navigator.pop(context);
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}