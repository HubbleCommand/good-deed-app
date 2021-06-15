import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:good_deed/widgets/forms/account/email_login.dart';
import 'package:good_deed/widgets/forms/account/email_signup.dart';
import 'package:good_deed/widgets/views/account.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/globals.dart';
import 'dart:io';

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

  void _login(OAuthCredential credential) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      IdTokenResult userAuthed = await FirebaseAuth.instance.currentUser.getIdTokenResult();

      final response = await http.Client().post(
          Globals.backendURL + Globals.beUserURI + '/login',
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"uuid":userCredential.user.uid, "token": userAuthed.token, "name": userCredential.user.displayName})
      );

      if(jsonDecode(response.body)["uuid"] != null){
        setState(() {
          _loggedIn = userCredential == null ? false : true;
        });
      } else {
        await FirebaseAuth.instance.signOut();
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Problem Signing you in'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('We seem to have encountered a problem while signing you in. \n'),
                    Text('Please try again later.'),
                  ],
                ),
              ),
            );
          },
        );
      }

      if(jsonDecode(response.body)["new"] != null){
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Welcome to Good Deed!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('We see that this is the first time you log into Good Deed. \n'),
                    Text('We hope you enjoy using our app!'),
                  ],
                ),
              ),
            );
          },
        );
      }

    } on FirebaseException catch (e)  {
      //TODO handle code 186 duplicate user (when loggin in with Facebook for example)
      print(e.code);
    } catch (e){

    }
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
                  final AccessToken result = await FacebookAuth.instance.login();
                  final facebookAuthCredential = FacebookAuthProvider.credential(result.token); // Create a credential from the access token
                  _login(facebookAuthCredential);
                }),
                _buildButton(button: Buttons.Google, onPressed: () async {
                  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
                  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;  // Obtain the auth details from the request
                  final credential = GoogleAuthProvider.credential( // Create a new credential
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                  );

                  _login(credential);
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
