import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/models/travel_model.dart';
import 'package:mountaincompanion/pages/travel_details/travel_details_page.dart';
import 'travel_card_button.dart';

class TravelCard extends StatelessWidget {
  final String tag;
  final TravelModel travel;
  TravelCard({this.tag, this.travel});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TravelDetailsPage(
                      tag: tag,
                      travel: travel,
                    ))),
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
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://mountain-companion.com/mc-photos/travels/${travel.thumbnail}.png',
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) => travel
                                    .thumbnailBlurhash !=
                                null
                            ? ClipRRect(
                                child: BlurHash(hash: travel.thumbnailBlurhash),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                        errorWidget: (context, url, error) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/blur_wallpaper.jpg',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                            Icon(
                              Icons.location_on,
                              color: Colors.lightGreen,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(travel.title ?? ''),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.date_range,
                              color: Colors.lightGreen,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6),
                              child: Text(DateFormat('dd. MM. yyyy')
                                  .format(travel.date)),
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
          right: 0,
        ),
        TravelCardButton(
          icon: Icons.bookmark,
          top: 80,
          right: 0,
        ),
        TravelCardButton(
          icon: Icons.share,
          top: 140,
          right: 0,
        ),
      ],
    );
  }
}