import 'package:flutter/material.dart';
import 'package:good_deed/widgets/drawer.dart';

class UnknownPage extends StatelessWidget {
  static const String routeName = '/unknown';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Unknown"),
        ),
        drawer: GDDrawer(),
        body: Center(child: Text('404 not found'),)
    );
  }
}