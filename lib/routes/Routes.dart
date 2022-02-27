import 'package:flutter/material.dart';
import 'package:good_deed/routes/users.dart';
import 'package:good_deed/routes/account.dart';
import 'package:good_deed/routes/about.dart';
import 'package:good_deed/routes/home.dart';
import 'package:good_deed/routes/deeds.dart' as D;
import 'package:good_deed/routes/unknown.dart';
import 'package:good_deed/routes/user.dart';
import 'package:good_deed/routes/deed.dart';

class Routes {
  static const String deeds = D.DeedsPage.routeName;
  static const String home = MyHomePage.routeName;
  static const String users = UsersPage.routeName;
  static const String account = AccountPage.routeName;
  static const String about = AboutPage.routeName;
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
    AccountPage.routeName: (context) => AccountPage(),
    AboutPage.routeName: (context) => AboutPage(),
    UnknownPage.routeName: (context) => UnknownPage(),
    //DeedPage.routeName: (context) => DeedPage(),
    //UserPage.routeName :(context) => UserPage(),
  };
}
