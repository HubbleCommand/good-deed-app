import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/routes/Routes.dart';

class GDDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:  AssetImage('res/images/drawer_header_background.png')
                ),
            ),
            child: Stack(children: <Widget>[
              Positioned(
                  bottom: 12.0,
                  left: 16.0,
                  child: Text("Good Deed",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500))),
            ])
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              // Update the state of the app
              // ...
              Navigator.pushReplacementNamed(context, Routes.home);
            },
          ),
          ListTile(
            title: Text('Account'),
            leading: Icon(Icons.account_circle),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              //Navigator.pop(context);
              Navigator.pushReplacementNamed(context, Routes.account);
            },
          ),
          ListTile(
            title: Text('Global Deeds'),
            leading: Icon(Icons.public_rounded),
            onTap: () {
              // Update the state of the app
              // ...

              Navigator.pushReplacementNamed(context, Routes.deeds);

              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            leading: Icon(Icons.policy),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.privacy);
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}