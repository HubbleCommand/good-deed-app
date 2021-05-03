import 'package:flutter/material.dart';
//import 'package:good_deed/routes/posts.dart';
import 'package:good_deed/routes/users.dart';

import 'package:good_deed/widgets/account.dart';
import 'package:good_deed/routes/settings.dart';
import 'package:good_deed/routes/home.dart';
import 'package:good_deed/routes/deeds.dart' as D;

class Routes {
  static const String deeds = D.DeedsPage.routeName;
  static const String home = MyHomePage.routeName;
  static const String users = UsersPage.routeName;
  static const String account = AccountPage.routeName;
  //static const String posts = PostsPage.routeName;
  static const String settings = SettingsPage.routeName;
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
    //PostsPage.routeName: (context) => PostsPage(),
    SettingsPage.routeName: (context) => SettingsPage(),
  };
}
