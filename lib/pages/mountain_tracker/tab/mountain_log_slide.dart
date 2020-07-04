import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/api/mountain_tracker.dart';

class MountainLogSlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getMountainLogs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error'),);
          } else if (snapshot.hasData) {
            List data = snapshot.data;
            if (data.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('No mountain peaks logged yet', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
                    SizedBox(height: 20,),
                    Icon(Icons.not_interested, size: 40, color: Colors.white,),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = snapshot.data[index];
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: Duration(milliseconds: 300),
                      duration: Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(16, 10, 10, 16),
                              title: Text(item['name'].toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 8,),
                                  Text(DateFormat('dd. MM. yyyy').format(DateTime.parse(item['date']),),),
                                  Text('Number of times: ' + item['count'].toString() + 'x')
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}