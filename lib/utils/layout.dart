/// Assorted utils to help layout widgets
/// Common layouts

import 'package:flutter/material.dart';

class LayoutUtils {
  static Widget widenButton(Widget button){
    return SizedBox(
      width: double.infinity,
      child: button,
    );
  }

  static Widget splitter (){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Divider(),
    );
  }

  static Widget listEndItemBuilder({@required String message}){
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(message),
      ),
    );
  }
}