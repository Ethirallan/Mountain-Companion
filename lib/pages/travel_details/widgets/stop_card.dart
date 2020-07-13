import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/models/stop_model.dart';

class StopCard extends StatelessWidget {
  final StopModel stop;
  final bool edit;
  final VoidCallback removeStop;
  final VoidCallback editStop;
  final VoidCallback duplicateStop;
  StopCard({this.stop, this.edit, this.removeStop, this.editStop, this.duplicateStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Location:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  stop.location,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Text(
                'Date and time:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  DateFormat('dd. MM. yyyy hh:mm').format(DateTime.parse(stop.time)),
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              Text(
                'See level:',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8),
                child: Text(
                  '${stop.height} m',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              edit ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: removeStop,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                    onPressed: editStop,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      color: Colors.blue,
                    ),
                    onPressed: duplicateStop,
                  ),
                ],
              ) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}