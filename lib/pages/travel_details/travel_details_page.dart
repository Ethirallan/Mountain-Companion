import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/api/travel.dart';
import 'package:mountaincompanion/models/stop_model.dart';
import 'package:mountaincompanion/models/travel_image_model.dart';
import 'package:mountaincompanion/models/travel_model.dart';
import 'package:mountaincompanion/pages/travel_details/widgets/stop_card.dart';

class TravelDetailsPage extends StatelessWidget {
  final String tag;
  final TravelModel travel;
  TravelDetailsPage({this.tag, this.travel});

  void handleMenuClick(String value, BuildContext context) async {
    if (value == 'Edit') {
      print('Edit clicked');
    } else if (value == 'Delete') {
      await showDialog(context: context, builder: (context) {
        if (Platform.isAndroid) {
          return AlertDialog(
            title: Text('Do you really want to delete this travel?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  await deleteTravel(travel.id);
                },
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: Text('Do you really want to delete this travel?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  await deleteTravel(travel.id);
                },
              ),
            ],
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            colors: [Colors.blue, Colors.green],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 250.0,
              backgroundColor: Colors.transparent,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  travel.title ?? '',
                  style: TextStyle(),
                ),
                background: Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://mountain-companion.com/mc-photos/travels/${travel.thumbnail}.png',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        travel.thumbnailBlurhash != null
                            ? BlurHash(hash: travel.thumbnailBlurhash)
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/blur_wallpaper.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                PopupMenuButton(
                  onSelected: (val) => handleMenuClick(val, context),
                  itemBuilder: (context) {
                    return {'Edit', 'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Date:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            DateFormat('dd. MM. yyyy').format(travel.date),
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Text(
                          'Path:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 220,
                          child: FutureBuilder(
                            future: getStops(travel.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState != ConnectionState.done) {
                                return Center(child: CircularProgressIndicator(),);
                              } else if (snapshot.hasData) {
                                var data = snapshot.data['message'];
                                if (data.length == 0) {

                                  return Container(
                                    child: Center(
                                      child: Text('No stops recorded', style: TextStyle(color: Colors.white, fontSize: 20),),
                                    ),
                                  );
                                }
                                return PageView.builder(
                                  controller: PageController(
                                    viewportFraction: 0.8,
                                    initialPage: 0,
                                  ),
                                  itemCount: data.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    StopModel stop = new StopModel(
                                        data[index]['location'],
                                        data[index]['height'],
                                        data[index]['time']);
                                    return StopCard(
                                      stop: stop,
                                    );
                                  },
                                );
                              } else {
                                return Container(
                                  child: Center(
                                    child: Text('No stops recorded'),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          'Notes:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            travel.notes,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: getImages(travel.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var data = snapshot.data['message'];
                        return SizedBox(
                          height: 250,
                          child: PageView.builder(
                            controller: PageController(
                              viewportFraction: 0.8,
                              initialPage: 0,
                            ),
                            itemCount: data.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              TravelImageModel image = new TravelImageModel(
                                  data[index]['id'],
                                  data[index]['travel_id'],
                                  data[index]['url'],
                                  data[index]['blurhash']);
                              return Container(
                                padding: EdgeInsets.all(8),
                                child: CachedNetworkImage(
                                  imageUrl: image.url,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => image
                                              .blurhash !=
                                          null
                                      ? ClipRRect(
                                          child: BlurHash(hash: image.blurhash),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
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
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
