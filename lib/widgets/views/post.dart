import 'package:flutter/material.dart';
import 'package:good_deed/models/post.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/views/user.dart';

class PostPage extends StatelessWidget {
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/post';
  final Post post;

  PostPage({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
          ),
          ImageUtils.Image.buildIcon(post.pictures.first, 190.0, 190.0),
          LayoutUtils.splitter(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Buttons for Deeds where is Deeder, Deeded, and Posts by user
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: post.user)));
                },
                child: Text('Poster'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
