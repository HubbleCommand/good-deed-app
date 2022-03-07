import 'package:flutter/material.dart';
import 'dart:math';

//TODO add to widgets? Not really a util...
class ImageUtil {
  static Widget buildIcon(String source, num height, num width){
    if(source == null) {
      return Icon(Icons.report, size: min(height, width));
    } else {
      return Image.network(
        source,
        loadingBuilder:(BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null ?
              loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
          return Icon(Icons.report, size: min(height, width));
        },
      );
    }
  }
}
