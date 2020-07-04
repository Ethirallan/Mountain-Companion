import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/api/travel.dart';
import 'package:mountaincompanion/global_widgets/time_input_field.dart';
import 'package:mountaincompanion/models/stop_model.dart';
import 'package:mountaincompanion/models/travel_image_model.dart';
import 'package:mountaincompanion/models/travel_model.dart';
import 'package:mountaincompanion/pages/travel_details/mc_photo_view.dart';
import 'package:mountaincompanion/pages/travel_details/widgets/stop_card.dart';

class TravelDetailsPage extends StatefulWidget {
  final String tag;
  final TravelModel travel;
  TravelDetailsPage({this.tag, this.travel});

  @override
  _TravelDetailsPageState createState() => _TravelDetailsPageState();
}

class _TravelDetailsPageState extends State<TravelDetailsPage> {
  bool edited = false;
  bool editMode = false;
  final TextEditingController locationCtrl = new TextEditingController();
  final TextEditingController heightCtrl = new TextEditingController();
  DateTime stopDateTime;

  final picker = ImagePicker();

  Future addImage(int source, int travelId) async {
    final pickedFile = await picker.getImage(
        source: source == 0 ? ImageSource.camera : ImageSource.gallery, imageQuality: 70);

    File image = new File(pickedFile.path);

    if (image != null) {
      String base64Image = base64Encode(image.readAsBytesSync());
      String photo = 'data:image/jpeg;base64,' + base64Image;
      await createImage({'travel_id': travelId, 'image': photo});
      setState(() {});
    }
  }

  Future changeThumbnail(TravelImageModel image) async {
    String url = image.url
        .replaceFirst('https://mountain-companion.com/mc-photos/travels/', '')
        .replaceFirst('.png', '');
    await updateTravel({'thumbnail': url, 'thumbnail_blurhash': image.blurhash},
        image.travelId);
    setState(() {
      widget.travel.thumbnail = url;
      widget.travel.thumbnailBlurhash = image.blurhash;
    });
  }

  void handleMenuClick(String value, BuildContext context) async {
    if (value == 'Edit') {
      edited = true;
      setState(() {
        editMode = true;
      });
    } else if (value == 'Delete') {
      await showDialog(
        context: context,
        builder: (context) {
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
                  await deleteTravel(widget.travel.id);
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, edited);
        return new Future(() => false);
      },
      child: Scaffold(
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
                expandedHeight: editMode ? 50 : 250,
                backgroundColor: Colors.transparent,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    editMode ? 'Editing travel' : (widget.travel.title ?? ''),
                    style: TextStyle(),
                  ),
                  background: editMode
                      ? Container()
                      : Hero(
                          tag: widget.tag,
                          child: CachedNetworkImage(
                            imageUrl:
                                'https://mountain-companion.com/mc-photos/travels/${widget.travel.thumbnail}.png',
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                widget.travel.thumbnailBlurhash != null
                                    ? BlurHash(
                                        hash: widget.travel.thumbnailBlurhash)
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
                  editMode
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              editMode = false;
                            });
                          },
                        )
                      : PopupMenuButton(
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
                          editMode
                              ? Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Title:',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 4, bottom: 8),
                                              child: Text(
                                                widget.travel.title,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            MCEditButton(
                                              fun: () async {
                                                TextEditingController
                                                    titleCtrl =
                                                    new TextEditingController(
                                                        text: widget
                                                            .travel.title);
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return SimpleDialog(
                                                      title:
                                                          Text('Update title'),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              16, 10, 16, 10),
                                                      children: <Widget>[
                                                        Container(
                                                          child: TextFormField(
                                                            controller:
                                                            titleCtrl,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: FlatButton(
                                                                child: Text(
                                                                    'Cancel'),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: FlatButton(
                                                                child: Text(
                                                                    'Save'),
                                                                onPressed:
                                                                    () async {
                                                                  await updateTravel(
                                                                      {
                                                                        'title': titleCtrl.text
                                                                      },
                                                                      widget.travel.id);
                                                                  setState(() {
                                                                    widget.travel.title = titleCtrl.text;
                                                                  });
                                                                  Navigator.pop(context);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Date:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 4, bottom: 8),
                                        child: Text(
                                          DateFormat('dd. MM. yyyy')
                                              .format(widget.travel.date),
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      editMode
                                          ? MCEditButton(
                                              fun: () async {
                                                if (Platform.isAndroid) {
                                                  Future<DateTime>
                                                      selectedDate =
                                                      showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        widget.travel.date,
                                                    firstDate: DateTime(2018),
                                                    lastDate: DateTime(2030),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget child) {
                                                      return Theme(
                                                        data: ThemeData.light(),
                                                        child: child,
                                                      );
                                                    },
                                                  );
                                                  DateTime newDate = await selectedDate;
                                                  print(newDate);
                                                  if (newDate != null) {
                                                    await updateTravel({
                                                      'date': newDate
                                                          .toIso8601String()
                                                    }, widget.travel.id);
                                                  }
                                                  setState(() {
                                                    widget
                                                        .travel
                                                        .date = newDate;
                                                  });
                                                } else {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      DateTime newDateTime =
                                                          widget.travel.date;
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 10),
                                                        child: Container(
                                                          height: 254,
                                                          color: Colors.white,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            children: <Widget>[
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Container(),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Text(
                                                                      'Select new date',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        CupertinoButton(
                                                                      child:
                                                                          Text(
                                                                        'Save',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Theme.of(context).primaryColor,
                                                                        ),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await updateTravel({
                                                                          'date':
                                                                              newDateTime.toIso8601String()
                                                                        }, widget.travel.id);
                                                                        setState(
                                                                            () {
                                                                          widget
                                                                              .travel
                                                                              .date = newDateTime;
                                                                        });
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                height: 2,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              ),
                                                              Container(
                                                                height: 200,
                                                                child:
                                                                    CupertinoDatePicker(
                                                                  initialDateTime:
                                                                      widget
                                                                          .travel
                                                                          .date,
                                                                  onDateTimeChanged: (DateTime
                                                                          value) =>
                                                                      newDateTime =
                                                                          value,
                                                                  mode:
                                                                      CupertinoDatePickerMode
                                                                          .date,
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
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Path:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          editMode ? FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.add_circle, color: Colors.white,),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Add new Stop',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) {

                                  locationCtrl.clear();
                                  heightCtrl.clear();
                                  stopDateTime = DateTime.now();

                                  return AlertDialog(
                                    title:
                                    Text('Create new Location'),
                                    content: Container(
                                      height: 176,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .stretch,
                                        children: <Widget>[
                                          TextFormField(
                                            controller:
                                            locationCtrl,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.only(
                                                    bottom: 11,
                                                    top: 11),
                                                labelText:
                                                'Location'),
                                          ),
                                          TextFormField(
                                            controller: heightCtrl,
                                            decoration: InputDecoration(
                                                contentPadding:
                                                EdgeInsets.only(
                                                    bottom: 11,
                                                    top: 11),
                                                labelText:
                                                'See level height'),
                                            keyboardType: TextInputType
                                                .numberWithOptions(),
                                          ),
                                          TimeInputField(
                                            label: 'Date and Time',
                                            time: stopDateTime,
                                            updateTime:
                                                (DateTime value) {
                                              setState(() {
                                                stopDateTime =
                                                    value;
                                                print(value);
                                                print(stopDateTime);
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancel'),
                                        onPressed: () =>
                                            Navigator.pop(context),
                                      ),
                                      FlatButton(
                                        child: Text('Save'),
                                        onPressed: () async {
                                          await createStop({
                                            'travel_id':
                                            widget.travel.id,
                                            'location':
                                            locationCtrl.text,
                                            'height': int.parse(
                                                heightCtrl.text),
                                            'time': stopDateTime
                                                .toIso8601String()
                                          });
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                  );
                                },
                              );
                              setState(() {});
                            },
                          ) : Container(),
                          SizedBox(
                            height: editMode ? 270 : 220,
                            child: FutureBuilder(
                              future: getStops(widget.travel.id),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasData) {
                                  var data = snapshot.data['message'];
                                  if (data.length == 0) {
                                    return Container(
                                      child: Center(
                                        child: Text(
                                          'No stops recorded',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
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
                                      StopModel stop = new StopModel.withID(
                                          data[index]['id'],
                                          data[index]['travel_id'],
                                          data[index]['location'],
                                          data[index]['height'],
                                          data[index]['time']);
                                      return StopCard(
                                        stop: stop,
                                        edit: editMode,
                                        removeStop: () async {
                                          await deleteStop(stop.id);
                                          setState(() {});
                                        },
                                        editStop: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              if (index != null) {
                                                locationCtrl.text =
                                                    stop.location;
                                                heightCtrl.text =
                                                    stop.height.toString();
                                                stopDateTime =
                                                    DateTime.parse(stop.time);
                                              }
                                              return AlertDialog(
                                                title:
                                                    Text('Create new Location'),
                                                content: Container(
                                                  height: 176,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        controller:
                                                            locationCtrl,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 11,
                                                                    top: 11),
                                                            labelText:
                                                                'Location'),
                                                      ),
                                                      TextFormField(
                                                        controller: heightCtrl,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 11,
                                                                    top: 11),
                                                            labelText:
                                                                'See level height'),
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(),
                                                      ),
                                                      TimeInputField(
                                                        label: 'Date and Time',
                                                        time: stopDateTime,
                                                        updateTime:
                                                            (DateTime value) {
                                                          setState(() {
                                                            stopDateTime =
                                                                value;
                                                            print(value);
                                                            print(stopDateTime);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  FlatButton(
                                                    child: Text('Save'),
                                                    onPressed: () async {
                                                      await updateStop({
                                                        'location':
                                                            locationCtrl.text,
                                                        'height': int.parse(
                                                            heightCtrl.text),
                                                        'time': stopDateTime
                                                            .toIso8601String()
                                                      }, stop.id);
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              );
                                            },
                                          );
                                          setState(() {});
                                        },
                                        duplicateStop: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              if (index != null) {
                                                locationCtrl.text =
                                                    stop.location;
                                                heightCtrl.text =
                                                    stop.height.toString();
                                                stopDateTime =
                                                    DateTime.parse(stop.time);
                                              }
                                              return AlertDialog(
                                                title:
                                                    Text('Create new Location'),
                                                content: Container(
                                                  height: 176,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    children: <Widget>[
                                                      TextFormField(
                                                        controller:
                                                            locationCtrl,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 11,
                                                                    top: 11),
                                                            labelText:
                                                                'Location'),
                                                      ),
                                                      TextFormField(
                                                        controller: heightCtrl,
                                                        decoration: InputDecoration(
                                                            contentPadding:
                                                                EdgeInsets.only(
                                                                    bottom: 11,
                                                                    top: 11),
                                                            labelText:
                                                                'See level height'),
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(),
                                                      ),
                                                      TimeInputField(
                                                        label: 'Date and Time',
                                                        time: stopDateTime,
                                                        updateTime:
                                                            (DateTime value) {
                                                          setState(() {
                                                            stopDateTime =
                                                                value;
                                                            print(value);
                                                            print(stopDateTime);
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                  ),
                                                  FlatButton(
                                                    child: Text('Save'),
                                                    onPressed: () async {
                                                      await createStop({
                                                        'travel_id':
                                                            stop.travelId,
                                                        'location':
                                                            locationCtrl.text,
                                                        'height': int.parse(
                                                            heightCtrl.text),
                                                        'time': stopDateTime
                                                            .toIso8601String()
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              );
                                            },
                                          );
                                          setState(() {});
                                        },
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
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    'Notes:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 4, bottom: 8),
                                        child: Text(
                                          widget.travel.notes,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      editMode
                                          ? MCEditButton(
                                              fun: () async {
                                                TextEditingController
                                                    notesCtrl =
                                                    new TextEditingController(
                                                        text: widget
                                                            .travel.notes);
                                                await showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return SimpleDialog(
                                                      title:
                                                          Text('Update notes'),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              16, 10, 16, 10),
                                                      children: <Widget>[
                                                        Container(
                                                          child: TextFormField(
                                                            controller:
                                                                notesCtrl,
                                                            expands: false,
                                                            minLines: null,
                                                            maxLines: null,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              child: FlatButton(
                                                                child: Text(
                                                                    'Cancel'),
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                        context),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: FlatButton(
                                                                child: Text(
                                                                    'Save'),
                                                                onPressed:
                                                                    () async {
                                                                  await updateTravel(
                                                                      {
                                                                        'notes':
                                                                            notesCtrl.text
                                                                      },
                                                                      widget
                                                                          .travel
                                                                          .id);
                                                                  setState(() {
                                                                    widget.travel
                                                                            .notes =
                                                                        notesCtrl
                                                                            .text;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    editMode
                        ? Padding(
                            padding: EdgeInsets.only(left: 50, right: 50),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await addImage(0, widget.travel.id);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_photo_alternate,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                    onPressed: () async {
                                      await addImage(1, widget.travel.id);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    FutureBuilder(
                      future: getImages(widget.travel.id),
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
                                        GestureDetector(
                                      onTap: () => Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                          builder: (context) => MCPhotoView(
                                            image: image,
                                            imageProvider: imageProvider,
                                          ),
                                        ),
                                      ),
                                      child: Hero(
                                        tag: image.url,
                                        child: Stack(
                                          children: <Widget>[
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
                                            editMode
                                                ? Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons.remove_circle,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () async {
                                                        await deleteImage(
                                                            image.id);
                                                        setState(() {});
                                                      },
                                                    ),
                                                  )
                                                : Container(),
                                            editMode
                                                ? Positioned(
                                                    top: 10,
                                                    left: 10,
                                                    child: IconButton(
                                                      icon: Icon(
                                                        Icons
                                                            .photo_size_select_actual,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () async =>
                                                          changeThumbnail(
                                                              image),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => image
                                                .blurhash !=
                                            null
                                        ? ClipRRect(
                                            child:
                                                BlurHash(hash: image.blurhash),
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
      ),
    );
  }
}

class MCEditButton extends StatelessWidget {
  final VoidCallback fun;
  MCEditButton({this.fun});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Colors.blue,
      ),
      onPressed: fun,
    );
  }
}
