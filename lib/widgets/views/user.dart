import 'package:flutter/material.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/routes/deeds.dart';
import 'package:good_deed/utils/layout.dart';

class UserView extends StatelessWidget{
  final User user;

  UserView({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        ImageUtils.Image.buildIcon(user.avatarURL, 190.0, 190.0),
        LayoutUtils.splitter(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Buttons for Deeds where is Deeder, Deeded, and Posts by user
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(didders: [this.user]),)));
              },
              child: Text('Done Deeds'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(gotters: [this.user]),)));
              },
              child: Text('Recieved Deeds'),
            ),
          ],
        ),
      ],
    );
  }
}
