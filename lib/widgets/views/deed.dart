import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/routes/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/picture_carousel.dart';
import 'package:good_deed/utils/image.dart';

//TODO convert to Stateful widget? If we need to fetch the deed, or if we want to be able to update in real time, a StatelessWidget won't do!
class DeedView extends StatelessWidget{
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/deed';
  final Deed deed;

  final double userProfileIconDimensions = 25.0;

  DeedView({Key key, this.deed}) : super(key: key);

  Widget _buildUserList(List<User> data, {BuildContext context}){
    print(data);
    if(data != null && data.isNotEmpty){
      print('empty');
      return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal, //Makes list horizontal
          itemCount: data.length,
          itemBuilder: (context, index) {
            //return ImageUtils.Image.buildIcon(data[index].avatarURL, userProfileIconDimensions, userProfileIconDimensions);
            //return getUserThingy(context: context, user: data[index], dimension: userProfileIconDimensions);
            return InkWell(
              onTap: (){
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: data[index])));
              },
              child: ImageUtil.buildIcon(data[index].avatarURL, 75.0, 75.0),
            );
          }
      );
    } else {
      return Container();
    }
  }

  Widget _buildPostersRow({BuildContext context}){
    print(deed.poster);
    if(deed.poster != null && deed.poster.avatarURL != null && deed.poster.avatarURL.isNotEmpty){
      //return _buildListThingy(deed.poster);
      return ImageUtil.buildIcon(deed.poster.avatarURL, userProfileIconDimensions, userProfileIconDimensions);
    } else {
      return ImageUtil.buildIcon(
          "https://www.clickz.com/wp-content/uploads/2016/03/anontumblr-300x271.png",
          userProfileIconDimensions, userProfileIconDimensions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        PictureCarouselWidget(imageUrls: deed.pictures, imageDimensions: 190.0,),
        LayoutUtils.splitter(),

        Row(
          children: [
            Text('Posted by: '),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: userProfileIconDimensions,
              child: _buildPostersRow(),
            ),
          ],
        ),

        Row(
          children: [
            Text('Didders: '),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: userProfileIconDimensions,
              child: _buildUserList(deed.didders, context: context),
            ),
          ],
        ),

        Row(
          children: [
            Text('Gotters: '),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: userProfileIconDimensions,
              child: _buildUserList(deed.gotters, context: context),
            ),
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
    );
  }
}
