///Holds global values

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:good_deed/models/user.dart';

//https://stackoverflow.com/questions/55243106/dart-nested-classes-how-to-access-child-class-variables
class Globals{
  static const String backendURL = 'https://gdvps.slalomwithsalmon.com/nodejs';
  static const String beDeedURI = '/deeds';
  static const String beUserURI = '/users';
  static const String beFTPURI = '/ftp';

  //Styles
  //static const Color mainThemeColor = Colors.yellow;

  //Mocked user's password: f@Xp4X=h5vB!4nN-

  static final mockedHome = new LatLng(40.68972222, 72.04444444); //Mocked User Location, statueOfLiberty

  static _Styles styles = _Styles();
}

class _Styles{
  const _Styles();
  //static Color mainThemeColor = Colors.yellow;
  Color get mainThemeColor => Colors.yellow;
}
