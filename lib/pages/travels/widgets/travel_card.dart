import 'package:flutter/material.dart';
import 'package:mountaincompanion/pages/travel_details/travel_details_page.dart';
import 'travel_card_button.dart';

class TravelCard extends StatelessWidget {
  final String tag;
  TravelCard({this.tag});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => TravelDetailsPage(tag: tag,))),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: tag,
                    child: Container(
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            topLeft: Radius.circular(15),
                          ),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/blur_wallpaper.jpg'),
                          )
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(Icons.location_on, color: Colors.lightGreen,),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text('Triglavski park'),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.date_range, color: Colors.lightGreen,),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text('16. 5. 2020'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        TravelCardButton(
          icon: Icons.favorite,
          top: 20,
          left: 340,
        ),
        TravelCardButton(
          icon: Icons.bookmark,
          top: 80,
          left: 340,
        ),
        TravelCardButton(
          icon: Icons.share,
          top: 140,
          left: 340,
        ),
      ],
    );
  }
}