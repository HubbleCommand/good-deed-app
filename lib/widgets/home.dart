import 'package:flutter/material.dart';
import 'package:good_deed/widgets/drawer.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:deep_pick/deep_pick.dart';

int _counter = 0; //TODO this should be in _MyHomePageState
class MyHomePage extends StatefulWidget {
  static const String routeName = "/home";
  //static String get routeName => _routeName;
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = counter;
  //int _deedCount;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        drawer: GDDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.public_sharp, size: 250),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Divider(),
              ),
              DeedCountWidget(),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.blue,
          onLongPress: () {
            // handle your long press functionality here
            setState(() {
              _counter = 0;
            });

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Reset your counter!'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'ACTION',
                onPressed: () { },
              ),
            ));
          },
          child: FloatingActionButton(
            child: Icon(Icons.add),
            //tooltip: 'Increment',
            onPressed: _incrementCounter,
          ),
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DeedCountWidget extends StatefulWidget {
  @override
  _DeedCountWidgetState createState() => _DeedCountWidgetState();
}

class _DeedCountWidgetState extends State<DeedCountWidget> {
  Future<int> _count;

  @override
  void initState() {
    super.initState();
    _count = getDeedCount().timeout(
      Duration(seconds:10),
      onTimeout: (){
        return -1;
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        FutureBuilder<int>(
          future: _count,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              if(snapshot.data < 0){
                return Column(
                  children: [
                    Text( "Can't connect ot find daily deeds...")
                  ],
                );
              }

              print('Data: ${snapshot.data}');
              NumberFormat numberFormat = NumberFormat.decimalPattern();
              return Column(
                children: [
                  Text(
                    "${numberFormat.format(snapshot.data)}",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text("That's how many deeds have been done in the last 24 hours!",)
                ],
              );
            } else {
              print(snapshot);
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}

Future<int> getDeedCount() async {
  var client = http.Client();
  DateTime now = new DateTime.now().subtract(new Duration(hours:24));
  String uri = 'http://192.168.1.33:3000/deeds/count?after=${now.millisecondsSinceEpoch}';
  var response = await client.get(uri);
  var body = convert.jsonDecode(response.body);
  print(body);

  //Ensures that if connection error between NodeJS and Neo4j, that loading spinner doesn't turn infinitely
  final errorCode = pick(body, 'error', 'code').asStringOrNull();
  print('Error code: $errorCode');
  if(pick(body, 'error', 'code').asStringOrNull() == 'ServiceUnavailable'){
    return -1;
  }

  //if(body['error']['code'] == 'ServiceUnavailable'){
  if(body.containsKey('error')){
    if(body['error'].containsKey('code')){
      if(body['error']['code'] == 'ServiceUnavailable'){
        return -1;
      }
    }
  }

  //int deedCount2 = (convert.jsonDecode(response.body)['error']['code'] == 'ServiceUnavailable') ? -1 : convert.jsonDecode(response.body)['count'];

  //Otherwise parse data and close client connection
  int deedCount = body['count'];
  client.close();

  return deedCount; //Without .toString(), 0 can be returned, which is falsey! But can change to Future<int> instead of string!
}
