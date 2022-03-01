import 'package:flutter/material.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/views/user.dart';

class UserPage extends StatelessWidget {
  static const String routeName = '/user';
  final User user;

  UserPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageBuilder.build(
        context: context,
        basePath: '/users',
        body : new UserView(user: this.user,)
    );
  }
}