import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/widgets/forms/image_picker.dart';
import 'package:good_deed/widgets/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/widgets/forms/user_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'package:positioned_tap_detector_2/positioned_tap_detector_2.dart';
import 'dart:developer';

class NewDeedForm extends StatefulWidget {

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
  LatLng selectedPoint;
  int _occuredMS = DateTime.now().millisecondsSinceEpoch;

  List<User> didders = [];
  List<User> gotters = [];

  Future<bool> createDeed(Deed deed) async {
    print(deed.didders);
    print(deed.gotters);
    Map<String, dynamic> vars = {
      'title': deed.title,
      'description' : deed.description,
      //'latitude'    : deed.location != null ? deed.location.latitude : null,
      //'longitude'   : deed.location != null ? deed.location.longitude: null,
      //Only send UUIDs, takes WAY less space
      'poster'      : deed.poster.uuid,
      'gotters'     : [],
      //'didders'     : deed.didders,
      'didders'     : [],
      'time'        : deed.time,
      'pictures'    : deed.pictures
    };
    deed.gotters.forEach((user) { vars['gotters'].add(user.uuid); });
    deed.didders.forEach((user) { vars['didders'].add(user.uuid); });

    FBAuth.IdTokenResult userAuthed = await FBAuth.FirebaseAuth.instance.currentUser.getIdTokenResult();

    if(deed.location != null){
      if(deed.location.latitude != null && deed.location.longitude != null){
        vars['latitude'] = deed.location.latitude;
        vars['longitude'] = deed.location.longitude;
        vars['token'] = userAuthed.token;
      }
    }
    print("VARS: ");
    print(vars.toString());

    final response = await http.Client().post(
        Uri.parse(Globals.backendURL + '/deedsv2'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(vars)
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  Future<String> uploadImage(filename) async {
    FBAuth.IdTokenResult userAuthed = await FBAuth.FirebaseAuth.instance.currentUser.getIdTokenResult();

    var request = http.MultipartRequest('POST', Uri.parse(Globals.backendURL + '/ftp/upload'))
      ..fields["token"] = userAuthed.token
    ;
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    return res.stream.bytesToString();
  }

  Widget _buildUserAreaThingy({String displayText, List<User> users}){
    return ElevatedButton(
      onPressed: () async {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var markers = [Marker(
      width: 80,
      height: 80,
      point: selectedPoint,
      builder: (ctx) => Container(
        child: Icon(Icons.adjust),
      ),
    )];

    return new Scaffold(
      appBar: AppBar(
        title: Text("New Deed"),
      ),
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
                      LayoutUtils.widenButton(_buildUserAreaThingy(displayText: 'Choose Didders', users: this.didders)),
                      LayoutUtils.widenButton(_buildUserAreaThingy(displayText: 'Choose Gotters', users: this.gotters)),
                      LayoutUtils.widenButton(
                        ElevatedButton(
                          onPressed: () async {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) {
                                print('confirm $date');
                                _occuredMS = date.millisecondsSinceEpoch;
                              },
                              //currentTime: _occuredMS == null ? DateTime.now() : _occuredMS,
                              currentTime: _occuredMS == null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(_occuredMS),
                            );
                          },
                          child: Text('Time Deed Occured'),
                        ),
                      ),
                      LayoutUtils.widenButton(
                        ElevatedButton(
                          onPressed: () async {
                            final List<File> result = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ImagePickerFormWidget(pictures: this._pictures,)),
                            );
                            setState(() {
                              this._pictures = result;
                            });
                          },
                          child: Text('Select Images'),
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Expanded(
              flex: 3,
              child: FlutterMap(
                options: MapOptions(
                    center: LatLng(45.5231, -122.6765),
                    zoom: 13.0,
                    onTap: (TapPosition tapPosition, LatLng latlng){
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
            LayoutUtils.widenButton(ElevatedButton(
              onPressed: () async {
                print("BOO");
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();

                  final overlay = LoadingOverlay.of(context);
                  overlay.show();
                  try {
                    //First, we need to send the image to the server & get their URLs
                    List<String> _resultingImages = [];
                    if(this._pictures != null && this._pictures.isNotEmpty){
                      for(File image in this._pictures){
                        print(image);
                        var res = await uploadImage(image.path);
                        var body = json.decode(res)["uid"];
                        print(body);
                        _resultingImages.add(body);//_resultingImages.add(Globals.backendURL + body);
                      }
                    }

                    FBAuth.User fbUser = FBAuth.FirebaseAuth.instance.currentUser;
                    //Can now post data : https://flutter.dev/docs/cookbook/networking/send-data
                    Deed newDeed = new Deed(
                        poster          : new User(name: fbUser.displayName, avatarURL: fbUser.photoURL, uuid: fbUser.uid),
                        didders         : this.didders,
                        gotters         : this.gotters,
                        location        : selectedPoint,
                        title           : _title,
                        description     : _description,
                        pictures        : _resultingImages,
                        time            : _occuredMS
                    );
                    print(newDeed);
                    print(inspect(newDeed));
                    if(await createDeed(newDeed)) {
                      print('DID GOOD');
                    } else {
                      print('SHIT');
                    }
                    overlay.hide();
                    Navigator.of(context).pop();
                  } catch (e) {
                    print(e);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Error creating deed!'),
                      duration: const Duration(seconds: 3),
                    ));
                    overlay.hide();
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Cannot create deed, missing info'),
                    duration: const Duration(seconds: 3),
                  ));
                }
              },
              child: Text('Submit'),
            ),),
          ],
        ),
      ),
    );
  }
}
