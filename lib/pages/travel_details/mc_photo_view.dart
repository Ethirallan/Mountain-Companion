import 'package:flutter/material.dart';
import 'package:mountaincompanion/models/travel_image_model.dart';
import 'package:photo_view/photo_view.dart';

class MCPhotoView extends StatelessWidget {
  final TravelImageModel image;
  final ImageProvider imageProvider;

  MCPhotoView({this.image, this.imageProvider});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Container(
            child: Stack(
              children: <Widget>[
                Hero(tag: image.url, child: Container(height: MediaQuery.of(context).size.height, child: PhotoView(imageProvider: imageProvider,))),
                Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: IconButton(
                    icon: Icon(Icons.clear, color: Colors.white,),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}