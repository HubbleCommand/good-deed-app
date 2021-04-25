import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/models/filters/user.dart';
import 'package:good_deed/models/user.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:good_deed/utils/image.dart' as ImageUtils;

//Reusable user selector widget
class UserSelectorFormWidget extends StatefulWidget {
  final FilterUser filter;
  final Function onUserSelectedCallback;

  UserSelectorFormWidget({this.filter, @required this.onUserSelectedCallback});

  @override
  _UserSelectorFormWidgetState createState() => _UserSelectorFormWidgetState(filter: filter);
}

class _UserSelectorFormWidgetState extends State<UserSelectorFormWidget> {
  FilterUser filter;

  _UserSelectorFormWidgetState({this.filter});

  @override
  void initState() {
    super.initState();
    if(this.filter == null){
      filter = new FilterUser();
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

  List<User> _userSuggestions = [];

  void _getUserSuggestions(String name){
    print("GETTING SUGGESTIONS");
    String url = 'http://192.168.1.33:3000/users?name=' + name ;

    http.Client().get(url).then((value) {
      List<User> parsedUsers = _parseUsers(value.body);
      setState(() {
        _userSuggestions.clear();
        _userSuggestions.addAll(parsedUsers);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<User>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          print('EMPTY');
          return const Iterable<User>.empty();
        }
        _getUserSuggestions(textEditingValue.text);
        print('WTF');
        return  _userSuggestions.map((val){
          print(val);
          return val;
        });
      },
      onSelected: (User selection) {
        print(selection.toString());
        print('You just selected $selection');
        widget.onUserSelectedCallback(selection);
      },
      displayStringForOption: (User option) => option.name,
      optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<User> onSelected, Iterable<User> options){
        return Material(
          child: Container(
            //color: Colors.teal,
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                final User option = options.elementAt(index);
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Text(option.name, style: const TextStyle(color: Colors.black)),
                      trailing: ImageUtils.Image.buildIcon(option.avatar, 36.0, 36.0),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
