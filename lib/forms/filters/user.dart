import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/filters/location.dart';
import 'package:good_deed/models/filters/user.dart';
import 'package:good_deed/models/user.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import '../map_picker.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;

class UserFilterScreen extends StatefulWidget {
  final FilterUser filter;

  UserFilterScreen({this.filter});

  @override
  _UserFilterScreenState createState() => _UserFilterScreenState(filter: filter);
}

class _UserFilterScreenState extends State<UserFilterScreen> {
  FilterUser filter;
  final _filterFormKey = GlobalKey<FormState>();

  _UserFilterScreenState({this.filter});

  @override
  void initState() {
    // TODO: implement initState
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Users'),
      ),
      body: Form(
          key: _filterFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [

                      //Filter be Deeder
                      //https://www.woolha.com/tutorials/flutter-using-autocomplete-widget-examples
                      Autocomplete<User>(
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
                          print('You just selected $selection');
                          print(selection);
                        },
                        displayStringForOption: (User option) => 'Deeder : ' + option.name,
                        optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<User> onSelected, Iterable<User> options){
                          return Align(
                            alignment: Alignment.topLeft,
                            child: Material(
                              child: Container(
                                //width: 300,
                                color: Colors.teal,
                                child: ListView.builder(
                                  padding: EdgeInsets.all(10.0),
                                  itemCount: options.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final User option = options.elementAt(index);

                                    return Container(
                                      //color: Colors.white,
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
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                //Submit button
                //TODO use this pattern (sorta like callback, but between pages https://flutter.dev/docs/cookbook/navigation/returning-data
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return "Nope!" as the result.
                      if (_filterFormKey.currentState.validate()) {
                        _filterFormKey.currentState.save();
                        Navigator.pop(context, this.filter);
                      }
                    },
                    child: Text('Apply Filters'),
                  ),
                )
              ]
          )
      ),
    );
  }
}
