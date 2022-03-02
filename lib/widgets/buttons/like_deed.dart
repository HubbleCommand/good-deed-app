import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'dart:convert';

import '../../globals.dart';

//TODO convert DeedPage and UserPage to a single DetailPage
//OR just remove these two
//We may want to pass a whole deed, OR just the ID. If just the ID is passed, then we need to go fetch the deed

class DeedLikeButton extends StatefulWidget {
  final String deedUUID;

  DeedLikeButton({Key key, this.deedUUID}) : super(key: key);

  @override
  DeedLikeButtonState createState() => DeedLikeButtonState(deedUUID: this.deedUUID);
}

class DeedLikeButtonState extends State<DeedLikeButton> {
  String deedUUID;

  bool _error;
  bool _loading = true;

  bool _deedLiked = false;

  DeedLikeButtonState({deedUUID}){
    this.deedUUID = deedUUID;
    print("DEED UUID : ");
    print(deedUUID);
  }

  Future<void> _fetchIsDeedLiked(String uuid) async {
    print('Current user');
    print(FBAuth.FirebaseAuth.instance.currentUser);
    String userUUID = FBAuth.FirebaseAuth.instance.currentUser.uid;
    String url = Globals.backendURL + '/deedsv2/likes?deed=' + deedUUID + '&user=' + userUUID;

    var urlUri = Uri.parse(url);
    final response = await http.Client().get(urlUri);
    print(response.body);

    final parsed = jsonDecode(response.body);
    print(parsed);

    setState(() {
      _deedLiked = parsed.containsKey('liked') ? parsed['liked'] : false;
    });
  }

  Future<void> _likeOrUnlikeDeed(String uuid, bool like) async {
    print('Is deed liked ?');
    print(like);
    FBAuth.IdTokenResult userAuthed = await FBAuth.FirebaseAuth.instance.currentUser.getIdTokenResult();

    /*if(FBAuth.FirebaseAuth.instance.currentUser == null){
      return;
    }*/
    String url = Globals.backendURL + '/deedsv2/like?deed=' + uuid + '&user=' + FBAuth.FirebaseAuth.instance.currentUser.uid;

    var urlUri = Uri.parse(url);
    print(urlUri);

    http.Response response;
    if(!like){
      response = await http.Client().post(urlUri);
    } else {
      response = await http.Client().delete(urlUri);
    }

    final parsed = jsonDecode(response.body);
    print('PARSED : ');
    print(parsed);

    setState(() {
      _deedLiked = parsed.containsKey('liked') ? parsed['liked'] : false;
    });
  }

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;

    _fetchIsDeedLiked(this.deedUUID);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon : _deedLiked ?
        Icon(Icons.favorite, color: Colors.red,):
        Icon(Icons.favorite_border),
        onPressed: () {
          //Based on _deedLiked, we send to either like or unlike
          _likeOrUnlikeDeed(this.deedUUID, _deedLiked);
        }
    );
  }
}
