import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/routes/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/picture_carousel.dart';
import 'package:good_deed/utils/image.dart';

class DeedView extends StatelessWidget{
  final _titleStyle = TextStyle(fontSize: 35.0);
  final _descriptionStyle = TextStyle(fontSize: 15.0);
  static const String routeName = '/deed';
  final Deed deed;

  final double userProfileIconDimensions = 25.0;

  DeedView({Key key, this.deed}) : super(key: key);

  Widget getUserThingy({BuildContext context, User user, double dimension}){
    return InkWell(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: user)));
      },
      /*child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          ImageUtils.Image.buildIcon(user.avatarURL, 75.0, 75.0),
        ],
      ),*/
      child: ImageUtil.buildIcon(user.avatarURL, 75.0, 75.0),
    );
  }

  Widget _buildListThingy(List<User> data, {BuildContext context}){
    return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal, //Makes list horizontal
        itemCount: data.length,
        itemBuilder: (context, index) {
          //return ImageUtils.Image.buildIcon(data[index].avatarURL, userProfileIconDimensions, userProfileIconDimensions);
          return getUserThingy(context: context, user: data[index], dimension: userProfileIconDimensions);
        }
    );
  }

  Widget _buildPostersRow({BuildContext context}){
    print(deed.poster);
    if(deed.poster != null && deed.poster.avatarURL.isNotEmpty){
      //return _buildListThingy(deed.poster);
      return ImageUtil.buildIcon(deed.poster.avatarURL, userProfileIconDimensions, userProfileIconDimensions);
    } else {
      return Container();
    }
  }

  Widget _buildDiddersRow({BuildContext context}){
    if(deed.didders != null && deed.didders.isNotEmpty){
      return _buildListThingy(deed.didders, context: context);
      /*return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          //scrollDirection: Axis.horizontal, //Makes list horizontal
          itemCount: deed.didders.length,
          itemBuilder: (context, index) {
            return ImageUtils.Image.buildIcon(deed.didders[index].avatarURL, userProfileIconDimensions, userProfileIconDimensions);
          }
      );*/
    } else {
      print("Y");
      return Container();
    }
  }

  Widget _buildGottersRow({BuildContext context}){
    if(deed.gotters != null && deed.gotters.isNotEmpty){
      return _buildListThingy(deed.gotters, context: context);
      /*return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal, //Makes list horizontal
          itemCount: deed.gotters.length,
          itemBuilder: (context, index) {
            return ImageUtils.Image.buildIcon(deed.gotters[index].avatarURL, userProfileIconDimensions, userProfileIconDimensions);
          }
      );*/
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        //ImageUtils.Image.buildIcon(deed.pictures.first, 190.0, 190.0),
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
              child: _buildDiddersRow(context: context),
            ),
          ],
        ),

        Row(
          children: [
            Text('Gotters: '),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              height: userProfileIconDimensions,
              child: _buildGottersRow(context: context),
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
