import 'package:flutter/material.dart';
import 'package:good_deed/utils/image.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/routes/deeds.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/buttons/follow_user.dart';

class UserView extends StatelessWidget{
  final User user;

  UserView({Key key, this.user}) : super(key: key);

  Widget _buildDeedFilterButton({@required BuildContext context, String title, Function onPressed}){
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(  //Using ListView can utterly fuck up with sizing when this widget is used as a child! WTF! Why can't ListView take the parent sizing?!
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        this.user.name == null ? Container() : Text(this.user.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40,),),
        LayoutUtils.splitter(),
        user.avatarURL == null ? Container() : ImageUtil.buildIcon(user.avatarURL, 190.0, 190.0),
        LayoutUtils.splitter(),
        this.user.story == null ? Container() : Text(this.user.story),
        LayoutUtils.splitter(),
        UserFollowButton(userUUID : this.user.uuid),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Buttons for Deeds where is Deeder, Deeded, and Posts by user
            _buildDeedFilterButton(
              context: context,
              title: "Done Deeds",
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(didders: [this.user]),)));
              }
            ),
            _buildDeedFilterButton(
              context: context,
              title: "Recieved Deeds",
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(gotters: [this.user]),)));
              }
            ),
            _buildDeedFilterButton(
              context: context,
              title: "Posted Deeds",
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedsPage(filterDeed: new FilterDeed(posters: [this.user]),)));
              }
            ),
          ],
        ),
      ],
    );
  }
}
