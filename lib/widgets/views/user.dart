import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/filters/post.dart';
import 'package:good_deed/models/filters/user.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/widgets/deeds.dart';
import 'package:good_deed/widgets/posts.dart';
import 'package:good_deed/widgets/users.dart';
import 'package:good_deed/utils/layout.dart';

class UserPage extends StatelessWidget {
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/deed';
  final User user;

  UserPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          ImageUtils.Image.buildIcon(user.avatar, 190.0, 190.0),
          LayoutUtils.splitter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Buttons for Deeds where is Deeder, Deeded, and Posts by user
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(deeder: this.user),)));
                },
                child: Text('Done Deeds'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(deeded: this.user),)));
                },
                child: Text('Recieved Deeds'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PostsPage(filterPost: new FilterPost(user: this.user),)));
                },
                child: Text('Posts'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
