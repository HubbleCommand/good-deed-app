import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/widgets/views/deed.dart';

class DeedPage extends StatelessWidget {
  static const String routeName = '/deed';
  final Deed deed;

  final double userProfileIconDimensions = 25.0;

  DeedPage({Key key, this.deed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(deed.title),  //Don't need to worry about text overflow, handled already
        ),
        //drawer: GDDrawer(),
        body: new DeedView(deed: this.deed,)
    );
  }
}
