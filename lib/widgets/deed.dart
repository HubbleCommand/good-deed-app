import 'package:flutter/material.dart';
import 'drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/widgets/users.dart';

class DeedPage extends StatelessWidget {
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/deed';
  final Deed deed;

  DeedPage({Key key, this.deed}) : super(key: key);

  final Widget _splitter = Padding(
    padding: EdgeInsets.all(16.0),
    child: Divider(),
  );

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        /*title: Row(
          children: [
            Text(deed.title),
            Padding(padding: EdgeInsets.all(9.0)),
            ImageUtils.Image.buildIcon(deed.deeder.avatar, 20.0, 20.0),
          ],
        ),*/
        title: Text(deed.title),
      ),
      drawer: GDDrawer(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          ImageUtils.Image.buildIcon(deed.pictures.first, 190.0, 190.0),
          //ImageUtils.Image.buildIcon(deed.picture, 190.0, 190.0),
          _splitter,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: (){
                  print('Hello');
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Deeder'),
                    ImageUtils.Image.buildIcon(deed.deeder.avatar, 75.0, 75.0),
                  ],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Deeded'),
                    ImageUtils.Image.buildIcon(deed.deeded.avatar, 75.0, 75.0),
                  ],
                ),
              ),
            ],
          ),
          _splitter,
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
          _splitter,
          Padding(
            padding: EdgeInsets.all(16.0),
            child:Text(
              deed.description,
              style: _descriptionStyle,
            ),
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
