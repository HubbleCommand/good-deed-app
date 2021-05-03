import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/filters/location.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/forms/filter/user.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import '../map_picker.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;

import '../user.dart';
import '../user_picker.dart';

class DeedFilterScreen extends StatefulWidget {
  final FilterDeed filter;

  DeedFilterScreen({this.filter});

  @override
  _DeedFilterScreenState createState() => _DeedFilterScreenState(filter: filter);
}

class _DeedFilterScreenState extends State<DeedFilterScreen> {
  FilterDeed filter;
  final _filterFormKey = GlobalKey<FormState>();

  final _titleController;
  final _descriptionController;

  _DeedFilterScreenState({this.filter}):
        _titleController = new TextEditingController(),
        _descriptionController = new TextEditingController()
  ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.filter == null){
      filter = new FilterDeed(didders: [], gotters: [], posters: []);
    }
  }

  bool _checkIfUserExists(User user, List<User> users){
    for(int i = 0; i < users.length; i++){
      if(users[i].uuid == user.uuid){
        return true;
      }
    }
    return false;
  }

  //TODO remove, do on another page for proper scrolling & Autocomplete isn't that good
  Widget _buildUserAreaThingy({String displayText, List<User> users}){
    return Column(
      children: [
        Text(displayText),
        Row(
          children: [
            Expanded(
              child: new UserSelectorFormWidget(
                  onUserSelectedCallback: (User selectedUser){
                    setState(() {
                      if(!_checkIfUserExists(selectedUser, users)){
                        users.add(selectedUser);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('You have already selected this user'),
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    });
                  }
              ),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 30.0,
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal, //Makes list horizontal
              itemCount: users.length,
              itemBuilder: (context, index){
                return Chip(
                  label: Text(users[index].name),
                  avatar: ImageUtils.Image.buildIcon(users[index].avatarURL, 25.0, 25.0), //TODO don't hard-code doubles
                  onDeleted: (){
                    setState(() {
                      users.removeAt(index);
                    });
                  },
                );
              }
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Deeds'),
        actions: [
          //Reset button
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () { //When pressed, display reset message & reset filter state
                _descriptionController.clear(); //Clear both text form fields, setting state won't do it
                _titleController.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Reset filters'),
                  duration: const Duration(seconds: 3),
                ));
                setState(() {
                  this.filter = new FilterDeed(didders: [], gotters: [], posters: []);
                });
              },
              icon: Icon(
                Icons.replay,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: Form(
          key: _filterFormKey,
          child: Column(
            //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Filter by title
                        TextFormField(
                          controller: _titleController,
                          //initialValue: this.filter.title == null ? '' : this.filter.title,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Title',
                          ),
                          //TODO check if need onFieldSubmitted? Doesn't seem to do anything
                          onFieldSubmitted: (String value){
                            setState(() {
                              if(value.isNotEmpty){
                                this.filter.title = value;
                              }
                            });
                          },
                          onSaved: (value) {
                            setState(() {
                              if(value.isNotEmpty || value.length != 0){
                                this.filter.title = value;
                              }
                            });
                          },
                        ),
                        //Filter by description
                        TextFormField(
                          controller: _descriptionController,
                          //initialValue: this.filter.description == null ? '' : this.filter.description,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            labelText: 'Description',
                          ),
                          onSaved: (value) {
                            setState(() {
                              if(value.isNotEmpty || value.length != 0){
                                this.filter.description = value;
                              }
                            });
                          },
                        ),

                        //Filter by location
                        //https://pub.dev/packages/flutter_map
                        //https://github.com/fleaflet/flutter_map/blob/master/example/lib/pages/tap_to_add.dart
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Close the screen and return "Nope!" as the result.
                              final FilterLocation result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MapPickerScreen(filter: new FilterLocation(location: this.filter.location, radius: this.filter.radius))),
                              );
                              print(result.toUrlQuery());
                              setState(() {
                                this.filter.location = new LatLng(result.location.latitude, result.location.longitude);
                                this.filter.radius = result.radius;
                              });
                            },
                            child: Text('Location Filter'),
                          ),
                        ),
                        //https://www.woolha.com/tutorials/flutter-using-autocomplete-widget-examples

                        _buildUserAreaThingy(displayText: 'Didders', users: this.filter.didders),
                        _buildUserAreaThingy(displayText: 'Gotters', users: this.filter.gotters),
                        _buildUserAreaThingy(displayText: 'Posters', users: this.filter.posters),

                        //time pickers https://pub.dev/packages/flutter_datetime_picker
                        //Filter by time before
                        LayoutUtils.widenButton(
                          ElevatedButton(
                            onPressed: () async {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                //minTime: DateTime(2018, 3, 5),
                                /*maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                print('change $date');
                              },*/ onConfirm: (date) {
                                print('confirm $date');
                                this.filter.timeBefore = date.millisecondsSinceEpoch;
                              },
                                //currentTime: DateTime.now()
                                currentTime: this.filter.timeBefore == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(this.filter.timeBefore),
                              );
                            },
                            child: Text('Posted Before'),
                          ),
                        ),

                        //Filter by time after
                        LayoutUtils.widenButton(
                          ElevatedButton(
                            onPressed: () async {
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                onConfirm: (date) {
                                  print('confirm $date');
                                  this.filter.timeAfter = date.millisecondsSinceEpoch;
                                },
                                currentTime: this.filter.timeAfter == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(this.filter.timeAfter),
                              );
                            },
                            child: Text('Posted After'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Submit button
                //TODO use this pattern (sorta like callback, but between pages https://flutter.dev/docs/cookbook/navigation/returning-data
                LayoutUtils.widenButton(
                  ElevatedButton(
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
