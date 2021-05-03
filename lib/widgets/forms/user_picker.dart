import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/utils/image.dart' as ImageUtils;

//TODO make work more like Deeds list!
class UserPickerScreen extends StatefulWidget {
  final List<User> preSelectedUsers;

  UserPickerScreen({this.preSelectedUsers});

  @override
  _UserPickerScreenState createState() => _UserPickerScreenState(preSelectedUsers: preSelectedUsers);
}

class _UserPickerScreenState extends State<UserPickerScreen> {
  //From Deeds for query
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _nextPageThreshold = 5;
  int timesFoundZeroUsers = 0;
  int timesFoundZeroUsersThreshold = 5;

  String _searchName;

  //Unique
  final _filterFormKey = GlobalKey<FormState>();
  List<User> selectedUsers = [];      //The selected users to return
  List<User> _userSuggestions = [];   //The suggested users

  _UserPickerScreenState({List<User> preSelectedUsers}){
    if(preSelectedUsers != null && preSelectedUsers.length > 0){
      selectedUsers = preSelectedUsers;
    }
  }

  List<User> _parseUsers(String responseBody) {
    print('PARSING...');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    print('DECODED USERS');

    var calced = parsed.map<User>((json) => User.fromJson(json)).toList();
    print('DID LAST THING');
    print(calced);
    return calced;
  }

  void _fetchUserSuggestions(String name){
    String url = 'http://192.168.1.33:3000/users?name=' + name + '&start=' + _userSuggestions.length.toString();

    http.Client().get(url).then((value) {
      List<User> parsedUsers = _parseUsers(value.body);
      if(parsedUsers.length == 0){
        /*setState(() {
          timesFoundZeroUsers += 1;
        });*/
        timesFoundZeroUsers += 1;
      } else {
        setState(() {
          _userSuggestions.addAll(parsedUsers);
        });
      }
    });
  }

  bool _checkIfUserExists(User user, List<User> users){
    for(int i = 0; i < users.length; i++){
      if(users[i].uuid == user.uuid){
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Users'),
      ),
      body: Form(
          key: _filterFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //Text(displayText),
                //Container for row of selected users
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 30.0,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal, //Makes list horizontal
                      itemCount: selectedUsers.length,
                      itemBuilder: (context, index){
                        return Chip(
                          label: Text(selectedUsers[index].name),
                          avatar: ImageUtils.Image.buildIcon(selectedUsers[index].avatarURL, 25.0, 25.0), //TODO don't hard-code doubles
                          onDeleted: (){
                            setState(() {
                              selectedUsers.removeAt(index);
                            });
                          },
                        );
                      }
                  ),
                ),
                TextFormField(
                  onChanged: (text){
                    setState(() {
                      _searchName = text;
                    });
                    if(text.isNotEmpty){
                      _fetchUserSuggestions(text);
                    } else {
                      setState(() {
                        _userSuggestions.clear();
                      });
                    }
                  },
                ),
                Expanded(
                  //child: Text('Y'),
                  child: ListView.builder(
                    //padding: EdgeInsets.all(10.0),
                    itemCount: _userSuggestions.length,
                    itemBuilder: (BuildContext context, int index) {
                      //if (index == _userSuggestions.length - _nextPageThreshold && timesFoundZeroUsers < timesFoundZeroUsersThreshold) {
                      if (index == _userSuggestions.length - _nextPageThreshold && timesFoundZeroUsers < timesFoundZeroUsersThreshold) {
                        _fetchUserSuggestions(_searchName);
                      }
                      final User option = _userSuggestions.elementAt(index);
                      return ListTile(
                        title: Text(option.name, style: const TextStyle(color: Colors.black)),
                        trailing: ImageUtils.Image.buildIcon(option.avatarURL, 36.0, 36.0),
                        onTap: (){
                          //selectedUsers.add(option);
                          //print(selectedUsers.length);
                          if(!_checkIfUserExists(option, selectedUsers)){
                            //users.add(selectedUser);
                            setState(() {
                              selectedUsers.add(option);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text('You have already selected this user'),
                              duration: const Duration(seconds: 3),
                            ));
                          }
                        },
                      );
                    },
                  ),
                  //Filter be Deeder https://www.woolha.com/tutorials/flutter-using-autocomplete-widget-examples
                ),
                //Submit button
                //TODO use this pattern (sorta like callback, but between pages https://flutter.dev/docs/cookbook/navigation/returning-data
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return the selected users as the result.
                      if (_filterFormKey.currentState.validate()) {
                        _filterFormKey.currentState.save();
                        Navigator.pop(context, selectedUsers);
                      }
                    },
                    child: Text('Apply Selected Users'),
                  ),
                )
              ]
          )
      ),
    );
  }
}
