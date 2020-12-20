import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';

class PrivacyPage extends StatelessWidget {
  static const String routeName = '/privacy';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Your Data & Privacy"),
        ),
        drawer: GDDrawer(),
        body: Center(child: Text(
            """Privacy"""
        )));
  }
}