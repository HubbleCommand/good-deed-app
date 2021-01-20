import 'package:flutter/material.dart';
import 'package:good_deed/widgets/deeds.dart' as D;
import 'package:good_deed/widgets/privacy.dart';
import 'package:good_deed/widgets/users.dart';
import 'package:good_deed/widgets/home.dart';

class Routes {
  static const String deeds = D.DeedsPage.routeName;
  static const String home = MyHomePage.routeName;
  static const String privacy = PrivacyPage.routeName;
  static const String users = UsersPage.routeName;
  static const String account = AccountPage.routeName;
  //static const String notes = NotesPage.routeName;

  /*var routes = {
    Routes.deeds: (context) => D.DeedsPage(),
    Routes.home: (context) => MyHomePage(title: 'Good Deed Home Page'),
    Routes.privacy: (context) => PrivacyPage(),
    Routes.users: (context) => UsersPage(),
    Routes.account: (context) => AccountPage(),
  };*/

  //NOTE this is where routes are stored, everything above can be removed!
  static Map<String, WidgetBuilder> routes = {
    MyHomePage.routeName: (context) => MyHomePage(title: 'Good Deed Home Page'),
    D.DeedsPage.routeName: (context) => D.DeedsPage(),
    UsersPage.routeName: (context) => UsersPage(),
    //AccountPage.routeName: (context) => AccountPage(),
  };
}
