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
import 'package:good_deed/utils/image.dart' as ImageUtils;

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
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultDeedsPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<User> futureDeeds2;
  int timesFoundZeroDeeds = 0;
  int timesFoundZeroDeedsThreshold = 5;

  int _timeRequest;

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 0;
    _error = false;
    _loading = true;
    futureDeeds2 = [];

    _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //TODO also only fetch when there is search terms
        // ... call method to load more deeds
        _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: getBody(),
            ),
            SizedBox(
              //To filter users, ONLY be name? Then just need one form thing above to put name & autocomplete
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  /*final FilterUser result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeedFilterScreen(filter: this.deedFilter)),
                  );
                  print('RECIEVED');
                  print(result.toUrlQuery());
                  setState(() {
                    this.futureDeeds2.clear();
                    this.deedFilter = result;
                    _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
                  });*/
                  // Respond to button press
                },
                child: Text('Filter'),
              ),
            ),
          ]
      ),
    );
  }

  Widget getBody() {
    print('BUILDING DEED LIST BODY');
    if (futureDeeds2.isEmpty) {
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
                  _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
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

      for(int index = 0; index < futureDeeds2.length; index++){
        if(index % 10 == 0){
          children.add(new BannerAdWidget());
        }
        children.add(new UserItem(futureDeeds2[index]));
        //If is last element, add ad widget
        if(index == futureDeeds2.length - 1){
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

  Future<void> _fetchDeeds(int limit, int before) async {
    try {
      setState(() {
        _loading = true;
      });

      int skip = (_pageNumber) * _defaultDeedsPerPageCount; //TODO needs to use the actual number of deeds!
      skip = futureDeeds2.length;

      String url = Globals.backendURL + '/users?' ;

      url += skip != 0 ? '&start=$skip' : '';
      print(url);
      final response = await http.Client().get(url);
      print('GOT DEEDS');
      List<User> parsedDeeds = _parseUsers(response.body);
      print('Number of users found: ' + parsedDeeds.length.toString());

      if(parsedDeeds.length == 0){
        timesFoundZeroDeeds += 1;
      } else {
        timesFoundZeroDeeds = 0;
      }

      setState(() {
        //_hasMore = parsedDeeds.length == _defaultPhotosPerPageCount; //THIS NEEDS TO BE CHANGED!!! It can keep requesting Deeds infinitely if there aren't enough!
        _hasMore = false;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        futureDeeds2.addAll(parsedDeeds);
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
      trailing: ImageUtils.Image.buildIcon(_user.avatarURL, 36.0, 36.0),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new UserPage(user: _user)));
      },
    );
  }
}
