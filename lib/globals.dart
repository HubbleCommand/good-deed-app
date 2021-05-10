///Holds global values

import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';

import 'package:good_deed/models/user.dart';

//https://stackoverflow.com/questions/55243106/dart-nested-classes-how-to-access-child-class-variables
class Globals{
  static const String backendURL = 'http://192.168.1.33:3000';

  //Styles
  //static const Color mainThemeColor = Colors.yellow;

  //Mocked user's password: f@Xp4X=h5vB!4nN-
  static final mockedUser = new User(
      name: 'Mocked',
      uuid: 'i2gu41TWaJXpVYtsGxbnsvLw45J3',
      avatarURL: 'https://www.clickz.com/wp-content/uploads/2016/03/anontumblr-300x271.png',
      story: "I am a mocked user. Don't mind me!"
      //home: new LatLng(40.68972222, 72.04444444), //Mocked User Location, statueOfLiberty
  );

  static final mockedHome = new LatLng(40.68972222, 72.04444444); //Mocked User Location, statueOfLiberty

  static _Styles styles = _Styles();
}

class _Styles{
  const _Styles();
  //static Color mainThemeColor = Colors.yellow;
  Color get mainThemeColor => Colors.yellow;
}
