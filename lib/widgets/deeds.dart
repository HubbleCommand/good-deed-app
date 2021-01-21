import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/models/geo.dart';

import 'package:good_deed/widgets/deed.dart';

import 'package:geotools/geotools.dart';

class DeedsPage extends StatelessWidget {
  static const String routeName = '/deeds';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deeds"),
        ),
        drawer: GDDrawer(),
        body: Deeds());
  }
}

class Deeds extends StatefulWidget {
  @override
  _DeedsState createState() => _DeedsState();
}

class _DeedsState extends State<Deeds> {
  //final _deeds = <String>[];
  final _deeds = <Deed>[];
  //final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  String title;
  String description;

  Dialog _buildDeedDialog(){
    return Dialog(
        insetPadding: EdgeInsets.all(10),
        child: Stack(
            clipBehavior:Clip.none,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.lightBlue
                ),
                padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Text("You can make cool stuff!",
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center
                ),
              ),
              Column(
                children: [
                  Text(
                    'This is a deed title',
                  ),
                ],
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network('https://picsum.photos/250?image=9')

                  ],

                )
              )
            ]
        )
    );
  }

  Widget _buildRow(Deed deed) {
    //final alreadySaved = _saved.contains(pair);

    LatLong eiffelTower = LatLong.fromDecimal(48.85805556, 2.29416667);
    LatLong statueOfLiberty = LatLong.fromDecimal(40.68972222, 72.04444444);

    return ListTile(
      //dense:true, //Makes stuff closer together & text smaller
      //isThreeLine: true, //Gives more space for subtitle (here, description), however can fuck / not fuck with other formatting (i.e. trailing size)
      //Distance from user
      leading: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (GeoUtils.distanceInMeters(eiffelTower, statueOfLiberty) / 1000).roundToDouble().toString() + ' km',
              textAlign: TextAlign.center,
            ),
          ],
        )
      ),
      //Title
      title: Text(
        deed.title.length > 10 ? deed.title.substring(0, 9) + '...' : deed.title,
        style: _biggerFont,
      ),
      //Description
      subtitle: Text(
        deed.description.length > 15 ? deed.description.substring(0, 14) + '...' : deed.description,
      ),
      //Trailing User Avatar images
      trailing: Container(
        //padding: const EdgeInsets.all(8.0),
        //height: 500.0,
        //width: 500.0,
        // alignment: FractionalOffset.center,
        child: new Stack(
          //alignment:new Alignment(x, y)
          clipBehavior:Clip.none,
          children: <Widget>[
            new Icon(Icons.monetization_on, size: 36.0, color: const Color.fromRGBO(218, 165, 32, 1.0)),
            new Positioned(
              left: 20.0,
              child: new Icon(Icons.monetization_on, size: 36.0, color: const Color.fromRGBO(218, 165, 32, 1.0)),
            ),
          ],
        ),
      ),
      onTap: () {
        /*showDialog(
          context: context,
          builder: (BuildContext context){
            return _buildDeedDialog();
          }
        );*/
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedPage(deed: deed)));
      },
    );
  }

  Widget _buildDeeds() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          for (var i = 0; i < 10; i++) {
            _deeds.add(new Deed(
                deedId         : i.hashCode,
                deederId       : 1,
                deededId       : 1,
                location       : new Point(x:1,y:1,format:'w'),
                time           : 1,
                title: "Bog" + i.toString(),
                description: "Bog description " + i.toString(),
                pictureSrc  : 'https://i.imgur.com/BoN9kdC.png'
            ));
          }

          return _buildRow(_deeds[i]);
        }
      );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  return Dialog(  //Using Dialog instead of AlertDialog for formatting (https://stackoverflow.com/questions/53913192/flutter-change-the-width-of-an-alertdialog)
                    insetPadding: EdgeInsets.all(10),
                    child: Stack(
                      //overflow: Overflow.visible, //This is deprecated, use clipBehavior as done below
                      clipBehavior:Clip.none,
                      children: <Widget>[
                        Text(
                          'Create new Deed',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        Positioned(
                          right: -10.0,
                          top: -15.0,
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
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
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
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'User'
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please choose a user!';
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
                    ));
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
  // Create a global key that uniquely identifies the Form widget and allows validation of the form.
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>.
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
                // Validate returns true if the form is valid, or false otherwise.
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

                  //Can now post data
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
