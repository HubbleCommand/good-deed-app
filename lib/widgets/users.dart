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
      //body: Center(child: Text("Users")));
      body: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Text('Users...'),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Respond to button press
                  },
                  child: Text('Filter'),
                ),
              ),
            ],
          )
      ),
    );
  }
}
