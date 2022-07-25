import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class LinkAccounts extends StatefulWidget {
  @override
  _LinkAccountsState createState() => _LinkAccountsState();
}

class _LinkAccountsState extends State<LinkAccounts> {

  void _linkCredentials(UserCredential existingCredential, AuthCredential linkCredential) async {
    await existingCredential.user.linkWithCredential(linkCredential);
  }

  @override
  Widget build(BuildContext context) {

  }
}