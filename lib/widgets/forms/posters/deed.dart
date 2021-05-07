import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/models/deed.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'dart:io';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/globals.dart';
import 'package:good_deed/widgets/forms/user.dart';

class NewDeedForm extends StatefulWidget {
  final User loggedInUser = Globals.mockedUser;

  @override
  NewDeedFormState createState() {
    return NewDeedFormState();
  }
}

class NewDeedFormState extends State<NewDeedForm> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _description;
  List<File> _pictures = [];
  List<bool> _lSelected = [true, false];
  LatLng selectedPoint;
  int _occuredMS;

  List<User> didders = [];
  List<User> gotters = [];

  User _otherUser;

  bool _isVisible = true;

  //TODO upload any images for the deed

  //Future<Deed> createDeed(String title) async {
  Future<bool> createDeed(Deed deed) async {

    Map<String, dynamic> vars = {
      'title': deed.title,
      'description' : deed.description,
      'poster'  : deed.poster,
      'latitude' : deed.location.latitude,
      'longitude' : deed.location.longitude,
      'gotters' : deed.gotters,
      'didders' : deed.didders,
      'time' : DateTime.now().millisecondsSinceEpoch, //0.toString(),
      'pictures' : deed.pictures
    };

    if(deed.location != null){
      if(deed.location.latitude != null && deed.location.longitude != null){
        vars['latitude'] = deed.location.latitude;
        vars['longitude'] = deed.location.longitude;
      }
    }

    final response = await http.Client().post(
        'http://192.168.1.33:3000/deedsv2',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        /*body: jsonEncode(<String, dynamic>{
        'title': deed.title,
        'description' : deed.description,
        //'doer: ' : deed.deeder.userId.toString(),
        //'reciever: ' : deed.deeded.userId.toString(),
        //'didders' : deed.didders.map((e) => e.uuid)
        'poster'  : deed.poster,
        //'didders' : jsonEncode(deed.didders.map((e) => e.uuid)),  //TODO or use .join of the Iterable<String> instead of jsonEncode
        //'gotters' : '[' + deed.gotters.map((e) => e.uuid).join(', ') + ']',
        //'gotters' : deed.gotters.map((e) => e.uuid),
        'latitude' : deed.location.latitude,
        'longitude' : deed.location.longitude,
        'gotters' : deed.gotters,
        'didders' : deed.didders,
        'time' : DateTime.now().millisecondsSinceEpoch, //0.toString(),
        'pictures' : deed.pictures
      }),*/
        body: jsonEncode(vars)
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var markers = [Marker(
      width: 80,
      height: 80,
      point: selectedPoint,
      builder: (ctx) => Container(
        //child: FlutterLogo(),
        child: Icon(Icons.adjust),
      ),
    )];

    return new Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("New Deed"),
            //Padding(padding: EdgeInsets.all(5.0)),
            Icon(Icons.add)
          ],
        ),
      ),
      //drawer: GDDrawer(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            /// Button group, chose if you were deeder or deeded
            Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /*ToggleButtons(
                        borderRadius: BorderRadius.circular((20)),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Deeder'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Deeded'),
                          ),
                        ],
                        onPressed: (int index) {
                          setState(() {
                            for (int buttonIndex = 0; buttonIndex < _lSelected.length; buttonIndex++) {
                              if (buttonIndex == index) {
                                _lSelected[buttonIndex] = true;
                              } else {
                                _lSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: _lSelected,
                      ),*/
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              labelText: 'Enter the Title of your deed'
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                                labelText: 'Enter the description of your deed'
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                _description = value;
                              });
                            }
                        ),
                      ),
                      Text('Didders'),
                      Row(
                        children: [
                          Expanded(
                            child: new UserSelectorFormWidget(
                                onUserSelectedCallback: (User selectedUser){
                                  setState(() {
                                    //Check that user doesn't already exist!

                                    this.didders.add(selectedUser);
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
                            itemCount: this.didders.length,
                            itemBuilder: (context, index){
                              return Chip(
                                label: Text(this.didders[index].name),
                                avatar: ImageUtils.Image.buildIcon(this.didders[index].avatarURL, 25.0, 25.0), //TODO don't hard-code doubles
                                onDeleted: (){
                                  setState(() {
                                    this.didders.removeAt(index);
                                  });
                                },
                              );
                              //return Text('A');
                            }
                        ),
                      ),

                      //Filter by Deeded
                      Text('Gotters'),
                      Row(
                        children: [
                          Expanded(
                            child: new UserSelectorFormWidget(
                                onUserSelectedCallback: (User selectedUser){
                                  setState(() {
                                    //Check that user doesn't already exist!
                                    this.gotters.add(selectedUser);
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
                            itemCount: this.gotters.length,
                            itemBuilder: (context, index){
                              return Chip(
                                label: Text(this.gotters[index].name),
                                avatar: ImageUtils.Image.buildIcon(this.gotters[index].avatarURL, 25.0, 25.0), //TODO don't hard-code doubles
                                onDeleted: (){
                                  setState(() {
                                    this.gotters.removeAt(index);
                                  });
                                },
                              );
                              //return Text('A');
                            }
                        ),
                      ),
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
                              _occuredMS = date.millisecondsSinceEpoch;
                            },
                              //currentTime: DateTime.now()
                              currentTime: _occuredMS == null ? DateTime.now() : _occuredMS,
                            );
                          },
                          child: Text('Time Deed Occured'),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Expanded(
              //height: 500, //When using container
              flex: 3,
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13.0,
                    onTap: (LatLng latlng){
                      setState(() {
                        selectedPoint = latlng;
                      });
                    }),
                layers: [
                  TileLayerOptions(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayerOptions(markers: markers)
                ],
              ),
            ),
            Visibility (
              visible: _isVisible,
              child: LayoutUtils.widenButton(
                ElevatedButton(
                  onPressed: /*_processing ? false :*/ () async {
                    print("BOO");
                    // Validate returns true if the form is valid, or false otherwise.
                    //if(_otherUser != null || _deeded != null){
                    /*if(_otherUser == null){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Select a user as a Deeder or Deeded!'),
                        duration: const Duration(seconds: 3),
                      ));
                    }*/
                    //if (_formKey.currentState.validate() && (_deeder != null || _deeded != null)) {
                    //if (_formKey.currentState.validate() && _otherUser != null) {
                    if (_formKey.currentState.validate()) {
                      setState(() { //Hide submit button once is submitted, avoids spamming in the app
                        //_isVisible = false;
                      });

                      _formKey.currentState.save();

                      print('Title: ' + _title);
                      print('Description: ' + _description);
                      //print('Deeder: ' + _deederId.toString());
                      //print('Deeded: ' + _deededId.toString());
                      //print('Picture: ' + _picture);

                      /*User locDeeder;
                      User locDeeded;

                      if(_lSelected[0]){
                        locDeeder = _otherUser;
                        locDeeded = widget.loggedInUser;
                      } else {
                        locDeeder = widget.loggedInUser;
                        locDeeded = _otherUser;
                      }*/

                      //Can now post data : https://flutter.dev/docs/cookbook/networking/send-data
                      Deed newDeed = new Deed(
                        //deedId          : -1,
                        //deeder          : locDeeder,
                        //deeded          : locDeeded,
                          poster: Globals.mockedUser,
                          //didders : jsonEncode(deed.didders.map((e) => e.uuid)),
                          //gotters : jsonEncode(deed.gotters.map((e) => e.uuid)),
                          didders: this.didders,
                          gotters: this.gotters,
                          location        : selectedPoint,
                          title           : _title,
                          description     : _description,
                          pictures: ['https://picsum.photos/200']
                      );
                      if(await createDeed(newDeed)) {
                        //Deed is created and can return to deeds
                        print('DID GOOD');
                      } else {
                        print('SHIT');
                      }
                      setState(() { //Hide submit button once is submitted, avoids spamming in the app
                        _isVisible = true;
                      });
                      //Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Cannot create deed, missing info'),
                        duration: const Duration(seconds: 3),
                      ));
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
      //)
    );
  }
}
