import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/main.dart';

class LogoutButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if(FirebaseAuth.instance.currentUser != null){
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Signed out'),
            duration: const Duration(seconds: 3),
          ));
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new GoodDeed()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('You must be logged in before signing out'),
            duration: const Duration(seconds: 3),
          ));
        }
      },
      child: Text("Logout"),
    );
  }
}