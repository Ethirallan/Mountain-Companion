import 'package:flutter/material.dart';

class NewTravelNavigation extends StatefulWidget {
  final VoidCallback next;
  final VoidCallback prev;
  final double currentPage;
  NewTravelNavigation({this.next, this.prev, this.currentPage});

  @override
  _NewTravelNavigationState createState() => _NewTravelNavigationState();
}

class _NewTravelNavigationState extends State<NewTravelNavigation> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color:
                  widget.currentPage == 0 ? Colors.grey : Colors.lightGreen,
                ),
                onPressed: widget.currentPage == 0 ? null : widget.prev,
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(
                  widget.currentPage == 4
                      ? Icons.save
                      : Icons.arrow_forward_ios,
                  color: Colors.lightGreen,
                ),
                onPressed: widget.next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}