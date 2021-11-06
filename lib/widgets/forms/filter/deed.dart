import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/filters/location.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:latlong2/latlong.dart';
import 'package:good_deed/widgets/forms/map_picker.dart';
import 'package:good_deed/widgets/forms/user_picker.dart';

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
    super.initState();
    if(this.filter == null){
      filter = new FilterDeed(didders: [], gotters: [], posters: []);
    }
  }

  //TODO remove, do on another page for proper scrolling & Autocomplete isn't that good
  Widget _buildUserAreaThingy({String displayText, List<User> users}){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () async {
          // Close the screen and return "Nope!" as the result.
          final List<User> result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserPickerScreen(preSelectedUsers: users,)),
          );
          print("RETURNED");
          //TODO fix, users = x doesn't work, not even in setState!
          users.clear();
          users.addAll(result);
          print(users);
        },
        child: Text(displayText),
      ),
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
                      print(this.filter);
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
