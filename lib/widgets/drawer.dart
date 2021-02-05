import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/routes/Routes.dart';

class GDDrawer extends StatelessWidget {
  _pushRoute(context, route) {
    Navigator.pop(context); //Or after?
    Navigator.of(context).pushNamed(route);
  }

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
              //Navigator.pushReplacementNamed(context, Routes.home);

              _pushRoute(context, Routes.home);
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
            title: Text('Posts'),
            leading: Icon(Icons.public_rounded),
            onTap: () {Navigator.pushReplacementNamed(context, Routes.posts);},
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
            title: Text('Settings & About GD'),
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pushReplacementNamed(context, Routes.settings);
            },
          ),
        ],
      ),
    );
  }
}