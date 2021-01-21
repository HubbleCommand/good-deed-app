import 'package:flutter/material.dart';

//TODO add to widgets? Not really a util...
class Image {
  static Widget buildIcon(String source, num height, num width){
    return Container(
        width: width,
        height: height,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: new NetworkImage(source)
            )
        )
    );
  }
}