import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mountaincompanion/api/travel.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/models/travel_model.dart';
import 'package:mountaincompanion/pages/new_travel/new_travel_page.dart';
import 'widgets/travel_card.dart';

class TravelsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MountainAppBar(
                title: 'Travel Diary',
                leading: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35),
                      topLeft: Radius.circular(35),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),

                      child: FutureBuilder(
                        future: getTravels(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data['message'].length,
                              itemBuilder: (context, index) {
                                TravelModel travel = new TravelModel(snapshot.data['message'][index]['id'], snapshot.data['message'][index]['user_id'], snapshot.data['message'][index]['title'], DateTime.parse(snapshot.data['message'][index]['date']??DateTime.now().toIso8601String()), snapshot.data['message'][index]['notes'], snapshot.data['message'][index]['thumbnail'], snapshot.data['message'][index]['thumbnail_blurhash'], snapshot.data['message'][index]['public'] == 0 ? false : true, DateTime.parse(snapshot.data['message'][index]['created']));
                                return index-1 > 67 ? TravelCard(
                                  tag: 'tag' + index.toString(),
                                  travel: travel,
                                ) : Container();
                              },
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: OpenContainer(
        openBuilder: (BuildContext context, VoidCallback action) => NewTravelPage(),
        tappable: true,
        closedElevation: 0,
        closedColor: Colors.lightGreen,
        closedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        transitionDuration: Duration(milliseconds: 500),
        closedBuilder: (BuildContext context, VoidCallback action) => Container(
          height: 50,
          width: 50,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}