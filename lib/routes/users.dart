//To search users / sign up
import 'package:flutter/material.dart';
import 'package:good_deed/routes/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/adds.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/image.dart';
import 'package:good_deed/globals.dart';

class UsersPage extends StatelessWidget {
  static const String routeName = '/users';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Users"),
        ),
        drawer: GDDrawer(),
        body: Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  //child: Deeds(),
                  child: UsersList(),
                ),
              ]
          ),
        )
    );
  }
}

//TODO look at this: https://medium.com/@sharmadhiraj.np/infinite-scrolling-listview-on-flutter-88d7a5e2bb4
class UsersList extends StatefulWidget {
  UsersList({Key key}) : super(key: key);

  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  bool _hasMore;
  bool _error;
  bool _loading;
  final int _defaultUsersPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<User> users;
  int timesFoundZeroUsers = 0;
  int timesFoundZeroUsersThreshold = 5;

  String _searchName = "";
  String _searchUUID = "";

  int _timeRequest;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _error = false;
    _loading = true;
    users = [];

    _fetchUsers(_defaultUsersPerPageCount, _timeRequest);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //TODO also only fetch when there is search terms
        // ... call method to load more deeds
        _fetchUsers(_defaultUsersPerPageCount, _timeRequest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (text){
                setState(() {
                  _searchName = text;
                  users.clear();
                });
                if(text.isNotEmpty){
                  _fetchUsers(_defaultUsersPerPageCount, _timeRequest);
                }
              },
            ),
            Expanded(
              child: getBody(),
            ),
          ]
      ),
    );
  }

  Widget getBody() {
    print('BUILDING DEED LIST BODY');
    if (users.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  _fetchUsers(_defaultUsersPerPageCount, _timeRequest);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error loading deeds, tap to try again"),
              ),
            ));
      } else {
        return Center(
          child: Text('No Deeds matching your criteria!'),
        );
      }
    } else {
      List<Widget> children = [];

      for(int index = 0; index < users.length; index++){
        if(index % 10 == 0){
          children.add(new BannerAdWidget());
        }
        children.add(new UserItem(users[index]));
        //If is last element, add ad widget
        if(index == users.length - 1){
          children.add(new BannerAdWidget());
          children.add(LayoutUtils.listEndItemBuilder(message: 'No more users found!'));
        }
      }

      //TODO use ListView.builder like in : https://flutter.dev/docs/cookbook/lists/mixed-list. Is it worth it? Have tried and didn't work
      return ListView(
        controller: _scrollController,
        children: children,
      );
    }
  }

  List<User> _parseUsers(String responseBody) {
    print('PARSING...');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    print('DECODED USERS');

    var calced = parsed.map<User>((json) => User.fromJson(json)).toList();
    print('DID LAST THING');
    return calced;
  }

  Future<void> _fetchUsers(int limit, int before) async {
    try {
      setState(() {
        _loading = true;
      });

      int skip = users.length;

      String url = Globals.backendURL + '/users?name=' + _searchName;

      url += skip != 0 ? '&start=$skip' : '';
      print(url);
      final response = await http.Client().get(url);
      print('GOT USERS');
      List<User> parsedDeeds = _parseUsers(response.body);
      print('Number of users found: ' + parsedDeeds.length.toString());

      if(parsedDeeds.length == 0){
        timesFoundZeroUsers += 1;
      } else {
        timesFoundZeroUsers = 0;
      }

      setState(() {
        //_hasMore = parsedDeeds.length == _defaultPhotosPerPageCount; //THIS NEEDS TO BE CHANGED!!! It can keep requesting Deeds infinitely if there aren't enough!
        _hasMore = false;
        _loading = false;
        users.addAll(parsedDeeds);
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}

class UserItem extends StatelessWidget {
  UserItem(this._user);
  final User _user;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        _user.name.length > 20 ? _user.name.substring(0, 19) + '...' : _user.name,
        style: _biggerFont,
      ),
      trailing: ImageUtil.buildIcon(_user.avatarURL, 36.0, 36.0),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: _user)));
      },
    );
  }
}
