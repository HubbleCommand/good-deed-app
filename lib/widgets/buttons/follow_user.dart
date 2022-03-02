import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'dart:convert';

import '../../globals.dart';

//TODO convert DeedPage and UserPage to a single DetailPage
//OR just remove these two
//We may want to pass a whole deed, OR just the ID. If just the ID is passed, then we need to go fetch the deed

class UserFollowButton extends StatefulWidget {
  final String userUUID;

  UserFollowButton({Key key, this.userUUID}) : super(key: key);

  @override
  UserFollowButtonState createState() => UserFollowButtonState(userUUID: this.userUUID);
}

class UserFollowButtonState extends State<UserFollowButton> {
  String userUUID;

  bool _error;
  bool _loading = true;

  bool _userFollowed = false;

  UserFollowButtonState({userUUID}){
    this.userUUID = userUUID;
    print("USER UUID : ");
    print(userUUID);
  }

  Future<void> _fetchIsUserFollowed(String uuid) async {
    print('Current user');
    print(FBAuth.FirebaseAuth.instance.currentUser);
    String userUUID = FBAuth.FirebaseAuth.instance.currentUser.uid;
    String url = Globals.backendURL + '/deedsv2/likes?deed=' + userUUID + '&user=' + userUUID;

    var urlUri = Uri.parse(url);
    final response = await http.Client().get(urlUri);
    print(response.body);

    final parsed = jsonDecode(response.body);
    print(parsed);

    setState(() {
      _userFollowed = parsed.containsKey('follows') ? parsed['follows'] : false;
    });
  }

  Future<void> _followOrUnfollowUser(String uuid, bool follows) async {
    print('Is user followed ?');
    print(follows);
    FBAuth.IdTokenResult userAuthed = await FBAuth.FirebaseAuth.instance.currentUser.getIdTokenResult();

    String url = Globals.backendURL + '/users/follow?followee=' + uuid + '&follower=' + FBAuth.FirebaseAuth.instance.currentUser.uid;

    var urlUri = Uri.parse(url);
    print(urlUri);

    http.Response response;
    if(!follows){
      response = await http.Client().post(urlUri);
    } else {
      response = await http.Client().delete(urlUri);
    }

    final parsed = jsonDecode(response.body);
    print('PARSED : ');
    print(parsed);

    setState(() {
      _userFollowed = parsed.containsKey('follows') ? parsed['follows'] : false;
    });
  }

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;

    _fetchIsUserFollowed(this.userUUID);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon : _userFollowed ?
          Icon(Icons.add_alert, color: Colors.red,):
          Icon(Icons.add_alert_outlined),
          onPressed: () {
            _followOrUnfollowUser(this.userUUID, _userFollowed);
          }
    );
  }
}
