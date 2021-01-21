import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/routes/Routes.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

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
                        fontWeight: FontWeight.w500
                    )
                  )),
            ])
          ),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.home);
            },
          ),
          ListTile(
            title: Text('Deeds'),
            leading: Icon(Icons.public_rounded),
            onTap: () {
              // Update the state of the app

              Navigator.pushReplacementNamed(context, Routes.deeds);

              // Then close the drawer
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Users'),
            leading: Icon(CupertinoIcons.person_3),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.users);
            },
          ),
          ListTile(
            title: Text('Account'),
            leading: Icon(CupertinoIcons.person),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.account);
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