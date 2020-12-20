//To search users / sign up
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'drawer.dart';

class UsersPage extends StatelessWidget {
  static const String routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Users"),
        ),
        drawer: GDDrawer(),
        body: Center(child: Text("Users")));
  }
}

class AccountPage extends StatelessWidget {
  static const String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Account"),
        ),
        drawer: GDDrawer(),
        body: Center(child: Text("Account")));
  }
}