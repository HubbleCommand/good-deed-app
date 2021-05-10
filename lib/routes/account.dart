import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:good_deed/main.dart';
import 'package:good_deed/widgets/buttons/button_logout.dart';
import 'package:good_deed/widgets/forms/login/email_login.dart';
import 'package:good_deed/widgets/forms/signup/email_signup.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:good_deed/widgets/views/account.dart';
import 'package:google_sign_in/google_sign_in.dart';

//TODO put this all in settings?

class AccountPage extends StatefulWidget{
  static const String routeName = '/account';

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _loggedIn;

  @override
  void initState(){
    super.initState();
    _loggedIn = FirebaseAuth.instance.currentUser == null ? false : true;
  }

  Widget _buildButton({Buttons button, Function onPressed}){
    return Container(
      height: 50,
      padding: const EdgeInsets.all(5),
      child: SignInButton(
        button,
        padding: const EdgeInsets.all(5),
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Account"),
        ),
        drawer: GDDrawer(),
        body:
        _loggedIn ?
          Column(
            children: [
              AccountView()
            ],
          )
          :
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You are not logged in. Please sign in'),
                _buildButton(button: Buttons.Facebook, onPressed: () async {

                }),
                _buildButton(button: Buttons.Google, onPressed: () async {
                  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  // Once signed in, return the UserCredential
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

                  setState(() {
                    _loggedIn = userCredential == null ? false : true;
                  });
                }),
                _buildButton(button: Buttons.Email, onPressed: () async {
                  bool success = await Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EmailLogIn()));
                  setState(() {
                    _loggedIn = success;
                  });
                }),
                Divider(),
                Text("Or sign up!"),
                ElevatedButton(onPressed: (){Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new EmailSignUp()));}, child: Text("Sign up with Email")),
              ],
            ),
          )
    );
  }
}

class FacebookAuth {
}
