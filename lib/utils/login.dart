import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../globals.dart';

class LoginHelper{
  Future<Map<String, dynamic>> login(OAuthCredential credential) async {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    IdTokenResult userAuthed = await FirebaseAuth.instance.currentUser.getIdTokenResult();

    var urlUri = Uri.parse(Globals.backendURL + Globals.beUserURI + '/login');

    final response = await http.Client().post(
        urlUri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"uuid":userCredential.user.uid, "token": userAuthed.token, "name": userCredential.user.displayName})
    );

    return jsonDecode(response.body);
  }

    //CALLED registerToFb in email_signup
  void registerToFirebase(email, password, age, name) {
    DatabaseReference dbRef = FirebaseDatabase.instance.reference().child("Users");
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: email, password: password)
        .then((result) {
          dbRef.child(result.user.uid).set({
            "email": email,
            "age": age,
            "name": name
          }).then((res) {

          });
        }).catchError((err) {

        });
  }

  //ALSO CALLED logInToFb
  Future<Map<String, dynamic>> loginEmail(email, password) async {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email, password: password)
        .then((result) {
          return "A";
        });
    //.catchError();
    //TODO catch error
  }

  Future<Map<String, dynamic>> loginFacebook() async {
    final loginThing = await FacebookAuth.instance.login();
    final result = FacebookAuthProvider.credential(loginThing.accessToken.token);
    final facebookAuthCredential = FacebookAuthProvider.credential(result.token.toString()); // Create a credential from the access token

    return login(facebookAuthCredential);
  }

  Future<Map<String, dynamic>> loginGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;  // Obtain the auth details from the request
    final credential = GoogleAuthProvider.credential( // Create a new credential
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return login(credential);
  }

  Future<Map<String, dynamic>> loginApple() async {

  }

  /*Future<OAuthCredential> loginEmail() async {
    final AccessToken result = await FacebookAuth.instance.login();
    return FacebookAuthProvider.credential(result.token); // Create a credential from the access token
    //return login(facebookAuthCredential);
  }

  OAuthCredential loginFacebook(){

  }

  OAuthCredential loginGoogle(){

  }

  OAuthCredential loginApple(){

  }*/
}