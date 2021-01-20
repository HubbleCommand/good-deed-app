import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';

class DeedsPage extends StatelessWidget {
  static const String routeName = '/deeds';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deeds"),
        ),
        drawer: GDDrawer(),
        //body: Center(child: Text("Deeds")));
        body: Deeds());
  }
}

class Deeds extends StatefulWidget {
  @override
  _DeedsState createState() => _DeedsState();
}

class _DeedsState extends State<Deeds> {
  final _deeds = <String>[];
  //final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  String title;
  String description;

  Widget _buildRow(String pair) {
    //final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair,
        style: _biggerFont,
      ),
      /*trailing: Icon(   // NEW from here...
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),*/
      onTap: () {      // NEW lines from here...
        /*setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });*/
      },
    );
  }

  Widget _buildDeeds() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          /*if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);*/

          //_deeds.addAll(generateWordPairs().take(10)); /*4*/
          for (var i = 0; i < 10; i++) {
            var random = Random.secure();
            var values = List<int>.generate(10, (i) => random.nextInt(256));
            //_deeds.add(base64Url.encode(values));
            _deeds.add("Bog" + i.toString());
          }

          return _buildRow(_deeds[i]);
        });
  }

  @override
  Widget build(BuildContext context) {
    /*return Column(
      children: <Widget>[

        Expanded(
          child: _buildDeeds(),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Respond to button press
            },
            child: Text('Filter'),
          ),
        ),
      ],
    );*/
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildDeeds(),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Respond to button press
              },
              child: Text('Filter'),
            ),
          ),
        ],
      ),
        floatingActionButton: InkWell(
          splashColor: Colors.blue,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Create new deed',
            onPressed: (){
              //Move this into the InkWell? However doesnt seem to do anything when in InkWell tho
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return AlertDialog(
                      content: Stack(
                        //overflow: Overflow.visible, //This is deprecated, use clipBehavior as done below
                        clipBehavior:Clip.none,
                        children: <Widget>[
                          Text('Create new Deed'),
                          Positioned(
                            right: -40.0,
                            top: -40.0,
                            child: InkResponse(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                child: Icon(Icons.close),
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.title),
                                        labelText: 'Title'
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (String value){title=value;},
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      //prefixIcon: Icon(Icons.image),
                                      //prefixIcon: Icon(Icons.description),
                                      prefixIcon: Icon(Icons.subtitles),
                                      labelText: 'Description'
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (String value){description=value;},
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      //prefixIcon: Icon(Icons.image),
                                      //prefixIcon: Icon(Icons.description),
                                        prefixIcon: Icon(Icons.subtitles),
                                        labelText: 'User'
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    onFieldSubmitted: (String value){description=value;},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text("Submit"),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _formKey.currentState;
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    );
                  }
              );
            },
          ),
        )
    );
  }
}


// Create a Form widget.
class NewDeedPage extends StatefulWidget {
  static const String routeName = '/+deed';

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<NewDeedPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String email;
    // Build a Form widget using the _formKey created above.
    return Form(
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
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Processing Data'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'ACTION',
                      onPressed: () { },
                    ),
                  ));
                }

              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
