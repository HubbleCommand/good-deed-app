import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geotools/geotools.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:http/http.dart' as http;

// Create a Form widget.
class NewDeedForm extends StatefulWidget {

  @override
  NewDeedFormState createState() {
    return NewDeedFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewDeedFormState extends State<NewDeedForm> {
  // Create a global key that uniquely identifies the Form widget and allows validation of the form.
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  var _passKey = GlobalKey<FormFieldState>();

  Deed _deed;
  int _deededId;
  int _deederId;
  String _title;
  String _description;
  String _picture;

  bool _isVisible = true;

  //TODO use
  User _deeded;
  User _deeder;

  //Future<Deed> createDeed(String title) async {
  Future<bool> createDeed(Deed deed) async {
    final response = await http.Client().post(
      //Uri.https('jsonplaceholder.typicode.com', 'albums'),
      'http://192.168.1.33:3000/deeds',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': deed.title,
        'description: ' : deed.description,
        'doer: ' : deed.deeder.userId.toString(),
        'reciever: ' : deed.deeded.userId.toString(),
        'time' : 0.toString(),
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      //return Deed.fromJson(jsonDecode(response.body));
      return true;
    } else {
      //throw Exception('Failed to create album.');
      return false;
    }
  }

  Future<bool> checkIfUserExists (String id)  {

  }

  Future<bool> findUser (String namePart)  {

  }

  @override
  Widget build(BuildContext context) {
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
      drawer: GDDrawer(),
      body: SingleChildScrollView (
        child:
          Form(
            key: _formKey,
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
                    //onFieldSubmitted: (String value){_title=value;},
                    onSaved: (value) {
                      setState(() {
                        _title = value;
                      });
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Find who did the deed'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please choose a User';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _deederId = value.hashCode;
                        _deeder = new User(
                          userId  : 1,
                          name    : 'Bob',
                          contact : 'bob@gmail.com',
                          home    : LatLong.fromDecimal(48.85805556, 2.29416667),
                          avatar: 'https://image.shutterstock.com/image-vector/user-icon-man-business-suit-600w-1700749465.jpg',
                        );
                      });
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Find who recieved the deed'
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please choose a User';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        _deededId = value.hashCode;
                        _deeded = new User(
                          userId  : 2,
                          name    : 'Alice',
                          contact : 'alice@gmail.com',
                          home    : LatLong.fromDecimal(48.85805556, 2.29416667),
                          avatar: 'https://image.shutterstock.com/image-vector/business-woman-icon-avatar-symbol-600w-790518412.jpg',
                        );
                      });
                    }
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child:
                  Visibility (
                    visible: _isVisible,
                    child: Card(
                      child: new ListTile(
                        title: Center(
                          child: ElevatedButton(
                            onPressed: /*_processing ? false :*/ () async {
                              print("BOO");
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState.validate()) {
                                setState(() { //Hide submit button once is submitted, avoids spamming in the app
                                  _isVisible = false;
                                });

                                _formKey.currentState.save();

                                print('Title: ' + _title);
                                print('Description: ' + _description);
                                print('Deeder: ' + _deederId.toString());
                                print('Deeded: ' + _deededId.toString());
                                //print('Picture: ' + _picture);

                                //Can now post data : https://flutter.dev/docs/cookbook/networking/send-data
                                Deed newDeed = new Deed(
                                    deedId          : -1,
                                    deeder          : _deeder,
                                    deeded: _deeded,
                                    location        : new LatLong.fromDecimal(48.85805556, 2.29416667),
                                    title           : _title,
                                    description     : _description,
                                    pictures: ['https://picsum.photos/200']
                                );
                                if(await createDeed(newDeed)) {
                                  //Deed is created and can return to deeds

                                } else {

                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ,
      )
    );

    // Build a Form widget using the _formKey created above.
    /*return
      Stack(
        children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Enter your username'
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onFieldSubmitted: (String value){email=value;},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    print("BOO");
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState.validate()) { // If the form is valid
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('Processing Data'),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(
                          label: 'ACTION',
                          onPressed: () { },
                        ),
                      ));

                      //Can now post data
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        )
        ],
      );*/
  }
}
