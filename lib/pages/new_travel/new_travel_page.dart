import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mountaincompanion/api/travel.dart';
import 'package:mountaincompanion/global_widgets/date_input_field.dart';
import 'package:mountaincompanion/models/stop_model.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/loading_dialog.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_stop_dialog.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_travel_navigation.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_travel_notes_field.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_travel_slide_logo.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_travel_slide_title.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/new_travel_text_form_field.dart';
import 'package:mountaincompanion/pages/new_travel/widgets/wave_cliper_one.dart';

class NewTravelPage extends StatefulWidget {
  @override
  _NewTravelPageState createState() => _NewTravelPageState();
}

class _NewTravelPageState extends State<NewTravelPage> {
  PageController pageCtrl = new PageController(initialPage: 0);
  String imgHash;
  double currentPage = 0;

  File thumbnailImg;

  void setThumbnailImage(File image) {
    setState(() {
      thumbnailImg = image;
    });
  }

  void next() async {
    if (currentPage != 4) {
      setState(() {
        currentPage++;
      });
      pageCtrl.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    } else if (currentPage == 4) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to save this travel?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () async {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        },
      ).then((value) async {
        if (value) {
          List<String> imagesBase64 = [];

          for (File image in images) {
            String base64Image = base64Encode(image.readAsBytesSync());
            String photo = 'data:image/jpeg;base64,' + base64Image;
            imagesBase64.add(photo);
          }

          if (thumbnailImg != null) {
            String base64Image = base64Encode(thumbnailImg.readAsBytesSync());
            String photo = 'data:image/jpeg;base64,' + base64Image;
            var bytes = utf8.encode(photo);
            imgHash = sha256.convert(bytes).toString();
          } else if (images.length > 0) {
            String base64Image = base64Encode(images[0].readAsBytesSync());
            String photo = 'data:image/jpeg;base64,' + base64Image;
            var bytes = utf8.encode(photo);
            imgHash = sha256.convert(bytes).toString();
          }

          var data = {
            'title': titleCtrl.text,
            'date': date.toIso8601String(),
            'stops': stops,
            'images': imagesBase64,
            'notes': notesCtrl.text,
            'thumbnail': imgHash
          };

          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return loadingDialog;
            },
          );
          await createNewTravel(data);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      });
    }
  }

  void previous() {
    if (currentPage != 0) {
      setState(() {
        currentPage--;
      });
      pageCtrl.previousPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastLinearToSlowEaseIn);
    }
  }

  TextEditingController titleCtrl = new TextEditingController();
  DateTime date = new DateTime.now();
  TextEditingController notesCtrl = new TextEditingController();

  List<StopModel> stops = [];

  final picker = ImagePicker();

  Future getImage(int source) async {
    final pickedFile = await picker.getImage(
        source: source == 0 ? ImageSource.camera : ImageSource.gallery, imageQuality: 70);

    if(images.length == 0) {
      setState(() {
        images.add(File(pickedFile.path));
        thumbnailImg = images[0];
      });
    } else {
      setState(() {
        setState(() {
          images.add(File(pickedFile.path));
        });
      });
    }
  }

  List<File> images = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: <Widget>[
            ClipPath(
              child: Container(
                height: 230,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [Colors.blue, Colors.green],
                  ),
                ),
              ),
              clipper: WaveClipperOne(),
            ),
            Positioned(
              top: 200,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: DotsIndicator(
                    dotsCount: 5,
                    position: currentPage,
                    decorator: DotsDecorator(
                      color: Colors.grey,
                      activeColor: Colors.lightGreen,
                      spacing: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 30,
              child: Text(
                'New travel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () async {
                    if (currentPage == 0) {
                      bool discard = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                                'Do you really want to discard this travel?'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('No'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: () async {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          );
                        },
                      );
                      if (discard) Navigator.pop(context);
                    } else {
                      previous();
                    }
                  }),
            ),
            Container(
              padding: EdgeInsets.only(top: 250),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: pageCtrl,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              NewTravelSlideTitle(
                                title: 'Title',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              NewTravelTextFormField(
                                ctrl: titleCtrl,
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              NewTravelSlideLogo(
                                iconData: Icons.location_on,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              NewTravelSlideTitle(
                                title: 'Date',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DateInputField(
                                label: 'Date',
                                date: date,
                                updateDate: (val) {
                                  setState(() {
                                    date = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              NewTravelSlideLogo(
                                iconData: Icons.date_range,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 50, 16, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              NewTravelSlideTitle(
                                title: 'Travel path',
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: FlatButton(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(Icons.add_circle),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Add new Stop',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return NewStopDialog(
                                          stops: stops,
                                        );
                                      },
                                    );
                                    setState(() {
                                      stops = stops;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                height: 400,
                                child: ListView.builder(
                                  controller: PageController(
                                    viewportFraction: 0.8,
                                    initialPage: 0,
                                  ),
                                  itemCount: stops.length,
                                  itemBuilder: (context, index) {
                                    //return StopCard(stop: stops[index]);
                                    StopModel stop = stops[index];
                                    return Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            '${index + 1}. ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Expanded(
                                            child: Text(
                                              stop.location +
                                                  '\n' +
                                                  stop.height.toString() +
                                                  'm\n' +
                                                  DateFormat(
                                                          'dd. MM. yyyy, HH:mm')
                                                      .format(DateTime.parse(
                                                          stop.time)),
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                stops.removeAt(index);
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.green,
                                            ),
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return NewStopDialog(
                                                    stops: stops,
                                                    index: index,
                                                  );
                                                },
                                              );
                                              setState(() {
                                                stops = stops;
                                              });
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.content_copy,
                                              color: Colors.blue,
                                            ),
                                            onPressed: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return NewStopDialog(
                                                    stops: stops,
                                                    duplicateIndex: index,
                                                  );
                                                },
                                              );
                                              setState(() {
                                                stops = stops;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              NewTravelSlideTitle(
                                title: 'Photos',
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_a_photo,
                                        color: Colors.lightGreen,
                                        size: 40,
                                      ),
                                      onPressed: () async {
                                        await getImage(0);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_photo_alternate,
                                        color: Colors.lightGreen,
                                        size: 40,
                                      ),
                                      onPressed: () async {
                                        await getImage(1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Container(
                                height: 200,
                                child: Swiper(
                                  loop: false,
                                  itemCount: images.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Stack(
                                      children: <Widget>[
                                        Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              margin: EdgeInsets.all(images[index] == thumbnailImg ? 10 :0),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: FileImage(images[index]),
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.remove_circle,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                images.removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.photo_size_select_actual,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            onPressed: () {
                                              setThumbnailImage(images[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  viewportFraction: 0.8,
                                  scale: 0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(50, 50, 50, 0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                NewTravelSlideTitle(
                                  title: 'Notes',
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                NewTravelNotesField(
                                  ctrl: notesCtrl,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              right: 50,
              child: NewTravelNavigation(
                prev: previous,
                next: next,
                currentPage: currentPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}