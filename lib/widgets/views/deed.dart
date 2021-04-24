import 'package:flutter/material.dart';
import 'package:good_deed/widgets/views/user.dart';
import '../drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/widgets/users.dart';
import 'package:good_deed/utils/layout.dart';

class DeedPage extends StatelessWidget {
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/deed';
  final Deed deed;

  DeedPage({Key key, this.deed}) : super(key: key);

  Widget getUserThingy({BuildContext context, User user, String text}){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: user)));
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          ImageUtils.Image.buildIcon(user.avatar, 75.0, 75.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(deed.title),
      ),
      //drawer: GDDrawer(),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          ImageUtils.Image.buildIcon(deed.pictures.first, 190.0, 190.0),
          LayoutUtils.splitter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getUserThingy(context: context, user: deed.deeder, text: 'Deeder'),
              getUserThingy(context: context, user: deed.deeded, text: 'Deeded'),
            ],
          ),
          LayoutUtils.splitter(),
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
          LayoutUtils.splitter(),
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
