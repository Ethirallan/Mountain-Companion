import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mountaincompanion/api/travel.dart';
import 'package:mountaincompanion/global_widgets/mountain_app_bar.dart';
import 'package:mountaincompanion/models/travel_model.dart';
import 'package:mountaincompanion/pages/login/login_page.dart';
import 'package:mountaincompanion/pages/new_travel/new_travel_page.dart';
import 'widgets/travel_card.dart';

class TravelsPage extends StatefulWidget {
  @override
  _TravelsPageState createState() => _TravelsPageState();
}

class _TravelsPageState extends State<TravelsPage> {

  Future _dataFuture;

  @override
  void initState() {
    _dataFuture = getTravels();
    super.initState();
  }

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
                  onPressed: () {

                  },
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final FirebaseAuth _auth = FirebaseAuth.instance;
                    if (await _auth.currentUser() != null) {
                      await _auth.signOut();
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
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
                        future: _dataFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState != ConnectionState.done) {
                            return Center(child: CircularProgressIndicator(),);
                          } else if (snapshot.hasData) {
                            return AnimationLimiter(
                              child: ListView.builder(
                                itemCount: snapshot.data['message'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  var element = snapshot.data['message'][index];
                                  TravelModel travel = new TravelModel(element['id'], element['user_id'], element['title'], DateTime.parse(element['date']??DateTime.now().toIso8601String()), element['notes'], element['thumbnail'], element['thumbnail_blurhash'], element['public'] == 0 ? false : true, DateTime.parse(element['created']));

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: Duration(milliseconds: 300),
                                    duration: Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      verticalOffset: 50,
                                      horizontalOffset: 300,
                                      child: FadeInAnimation(
                                        child: TravelCard(
                                          tag: 'tag' + index.toString(),
                                          travel: travel,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
//                            return Center(child: CircularProgressIndicator());
                            return Container();
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
        onClosed: (val) {
          setState(() {
            _dataFuture = getTravels();
          });
        },
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