import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';

class DeedPage extends StatelessWidget {
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);

  static const String routeName = '/deed';

  final Deed deed;
  DeedPage({Key key, this.deed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(deed.title),
      ),
      drawer: GDDrawer(),
      //body: Deed(title:value)
      body: ListView(
        children: <Widget>[
          Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new NetworkImage("https://i.imgur.com/BoN9kdC.png")
                  )
          )),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                deed.title,
                style: _titleStyle,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Divider(),
          ),
          Text(
            deed.description,
            style: _descriptionStyle,
          ),
        ],
      ),
    );
  }
}

//I don't think this even needs a state!
class DeedWidget extends StatefulWidget {
  final String title;

  DeedWidget({Key key, this.title}) : super(key: key);

  @override
  _DeedState createState() => new _DeedState();
}

class _DeedState extends State<DeedWidget> {
  final _deeds = <String>[];
  //final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            Text(widget.title),
          ],
        ),
    );
  }
}
