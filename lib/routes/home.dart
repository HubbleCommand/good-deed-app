import 'package:flutter/material.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return PageBuilder.build(
      context :context,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //https://www.dropbox.com/s/efqvccharfgjcuf/wot.jpg?dl=0
            //ImageUtils.Image.buildIcon('https://previews.dropbox.com/p/thumb/ABIwuHVkjqiR4GG-ArxcYWkO4YOR89DzyDZCSMTRogWAuMnF_4YNw0F_BGrtxQ6efMoPHJ5f-FwMlLCWXY-5_SbEcDuorNpWiDeUbpq8ZuoUQqxraNEzm3lK52GUWFwiEwUuePq6eeEXXHlnvAOsTXNxEz_EMchyCrxWArd-ximdv2gIt3b3O91XRatOWLguaJ5wJQUJxeBdmVUalrDkvijJnqbpTiA8Tzkli6fDU6tWDUTXdfFLGwnVB4DT3N2nd1LW1kQ6EaYYMaarWfOGtN-dv9JhNibSJocaUfsI61x9TKN9W9gffz2DykdDLJCWIV-wajoe01bV0Y8HHA0y1_0bJae6pIDWRtSr9Mu4PVGGDQ/p.jpeg?fv_content=true&size_mode=5', 36.0, 36.0),
            Icon(Icons.public_sharp, size: 250),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Divider(),
            ),
            DeedCountWidget(),
          ],
        ),
      ),
      basePath : '/home',
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
  String uri = Globals.backendURL + '/deedsv2/count?after=${now.millisecondsSinceEpoch}';
  var urlUri = Uri.parse(uri);
  //TODO check what's going on here, sometimes it doesn't work without the headers!
  /*var response = await client.get(urlUri,
      headers: {
        "Accept": "application/json",
        "Access-Control-Allow-Origin": "*"
      });*/
  var response = await client.get(urlUri);
  var body = convert.jsonDecode(response.body);

  //Ensures that if connection error between NodeJS and Neo4j, that loading spinner doesn't turn infinitely
  //int deedCount = (pick(body, 'error', 'code').asStringOrNull() == 'ServiceUnavailable') ? -1 : body['count'];
  int deedCount = -1;
  try{
    deedCount = body['count'];
  } on Exception {

  }

  client.close();

  return deedCount;
}
