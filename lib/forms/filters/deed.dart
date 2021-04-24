import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/models/filters/location.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/forms/user.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import '../map_picker.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;

class DeedFilterScreen extends StatefulWidget {
  final FilterDeed filter;

  DeedFilterScreen({this.filter});

  @override
  _DeedFilterScreenState createState() => _DeedFilterScreenState(filter: filter);
}

class _DeedFilterScreenState extends State<DeedFilterScreen> {
  FilterDeed filter;
  final _filterFormKey = GlobalKey<FormState>();

  _DeedFilterScreenState({this.filter});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(this.filter == null){
      filter = new FilterDeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Deeds'),
      ),
      body: Form(
          key: _filterFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        //Filter by title
                        TextFormField(
                          initialValue: this.filter.title == null ? null : this.filter.title,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            //labelText: this.filter.title == null ? 'Title' : this.filter.title,
                            labelText: 'Title',
                          ),
                          /*validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },*/
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
                          initialValue: this.filter.description == null ? null : this.filter.description,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            //labelText: this.filter.description == null ? 'Description' : this.filter.description,
                            labelText: 'Description',
                          ),
                          /*validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },*/
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
                        //Filter be Deeder
                        /*Row(
                          children: [
                            Align(
                              alignment:  Alignment.center,
                              child: Text('Deeder '),
                            ),
                            Expanded(
                              child: new UserSelectorFormWidget(
                                onUserSelectedCallback: (User selectedUser){
                                  this.filter.deeder = selectedUser;
                                }
                              ),
                            ),
                          ],
                        ),

                        //Filter by Deeded
                        Row(
                          children: [
                            Text('Deeded '),
                            Expanded(
                              child: new UserSelectorFormWidget(
                                onUserSelectedCallback: (User selectedUser){
                                  this.filter.deeded = selectedUser;
                                },
                              ),
                            ),
                          ],
                        ),*/

                        //Filter be Deeder
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment:  Alignment.topLeft,
                                child: Text('Deeder'),
                              ),
                              new UserSelectorFormWidget(
                                  onUserSelectedCallback: (User selectedUser){
                                    this.filter.deeder = selectedUser;
                                  }
                              ),
                            ],
                          ),
                        ),

                        //Filter by Deeded
                        Divider(),
                        Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              Align(
                                alignment:  Alignment.topLeft,
                                child: Text('Deeded'),
                              ),
                              new UserSelectorFormWidget(
                                onUserSelectedCallback: (User selectedUser){
                                  this.filter.deeded = selectedUser;
                                },
                              ),
                            ],
                          ),
                        ),


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
