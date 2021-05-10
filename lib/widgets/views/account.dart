import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/widgets/buttons/button_logout.dart';
import 'package:good_deed/widgets/forms/login/email_login.dart';
import 'package:good_deed/widgets/forms/signup/email_signup.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:good_deed/widgets/views/user.dart';
import 'package:good_deed/models/user.dart' as GDUser;

//TODO put this all in settings?
class AccountView extends StatelessWidget {
  //static const String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    User fbUser = FirebaseAuth.instance.currentUser;
    return Column(
      children: [
        Text(FirebaseAuth.instance.currentUser == null ? 'NOT LOGGED IN' : 'YOU ARE LOGGED IN'),
        LogoutButton(),
        UserView(user: new GDUser.User(uuid: fbUser.uid, name: fbUser.displayName, avatarURL: fbUser.photoURL),)
      ],
    );
  }
}
