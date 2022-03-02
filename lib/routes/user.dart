import 'package:flutter/material.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/views/user.dart';

/*
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
}*/

import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/views/deed.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'dart:convert';
import '../globals.dart';

//TODO convert DeedPage and UserPage to a single DetailPage
//OR just remove these two
//We may want to pass a whole deed, OR just the ID. If just the ID is passed, then we need to go fetch the deed

class UserPage extends StatefulWidget {
  static const String routeName = '/user';

  final double userProfileIconDimensions = 25.0;

  final User user;
  final String userUUID;

  UserPage({Key key, this.user, this.userUUID}) : super(key: key);

  @override
  UserPageState createState() => UserPageState(user: this.user, userUUID: this.userUUID);
}

class UserPageState extends State<UserPage> {
  User user;
  String userUUID;

  bool _error;
  bool _loading = true;

  bool _deedLiked = false;

  UserPageState({user, userUUID}){
    this.user = user;
    this.userUUID = userUUID;
    print("USER UUID : ");
    print(userUUID);
  }

  Future<void> _fetchUser(String uuid) async {
    String url = Globals.backendURL + '/users/user/' + uuid;

    var urlUri = Uri.parse(url);
    final response = await http.Client().get(urlUri);
    print(response.body);

    final parsed = jsonDecode(response.body);
    print(parsed);

    setState(() {
      user = User.fromJson(parsed);
      _loading = false;
    });
    print(user);
    print(user.uuid);
    print(user.toString());
  }

  @override
  void initState() {
    super.initState();
    _error = false;
    _loading = true;

    if(this.user != null){
      _loading = false;
    } else if (this.userUUID != null){
      _fetchUser(this.userUUID);
    } else {
      //Oops! We shouldn't be here!
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder.build(
        context: context,
        basePath: '/users',
        body : _loading ? Container(child: Center(child: new CircularProgressIndicator(),)) :
        //NOTE : DeedView's ListView MUST be encapsulated with something that defines it's size, like the Expanded used here
        //https://flutteragency.com/add-a-listview-to-a-column/
        //Expanded(child: new DeedView(deed: this.deed,),),
        new UserView(user: this.user,)
    );
  }
}
