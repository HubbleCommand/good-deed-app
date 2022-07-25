import 'package:flutter/material.dart';
import 'package:good_deed/routes/Routes.dart';

/**
 * A Simple utility class that handles the appbar
 */
class AppbarController{
  static buildAppbar({String title, List<Widget> moreActions, bool showDrawer, BuildContext context}){
    return AppBar(
      title: title == null ? Text('Good Deed') : Text(title),
      actions: [
        IconButton(
          icon: Icon(Icons.info),
          onPressed: (){
            //Navigator.of(context).pushNamed(Routes.about);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('This is a snackbar')));
            //Navigator.pushNamed(context, Routes.about);
          },
        ),
        IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: (){
            //Navigator.of(context).pushNamed(Routes.account);
          },
        ),
      ],
    );
  }
}