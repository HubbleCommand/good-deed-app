import 'package:flutter/material.dart';
import 'drawer.dart';

class PostsPage extends StatelessWidget {
  static const String routeName = '/posts';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deeds"),
        ),
        drawer: GDDrawer(),
        body: Center(
          child: Text("Posts"),
        )
    );
  }
}