import 'package:flutter/material.dart';
import 'dart:math';

//TODO add to widgets? Not really a util...
class ImageUtil {
  static Widget buildIcon(String source, num height, num width){
    if(source == null) {
      return Icon(Icons.report, size: min(height, width));
    } else {
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
}
