import 'package:flutter/material.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/utils/page_builder.dart';
import 'package:good_deed/widgets/views/deed.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart' as FBAuth;
import 'dart:convert';
import '../globals.dart';

//TODO convert DeedPage and UserPage to a single DetailPage
//OR just remove these two
//We may want to pass a whole deed, OR just the ID. If just the ID is passed, then we need to go fetch the deed

class DeedPage extends StatefulWidget {
  static const String routeName = '/deed';

  final double userProfileIconDimensions = 25.0;

  final Deed deed;
  final String deedUUID;

  DeedPage({Key key, this.deed, this.deedUUID}) : super(key: key);

  @override
  DeedPageState createState() => DeedPageState(deed: this.deed, deedUUID: this.deedUUID);
}

class DeedPageState extends State<DeedPage> {
  Deed deed;
  String deedUUID;

  bool _error;
  bool _loading = true;

  bool _deedLiked = false;

  DeedPageState({deed, deedUUID}){
    this.deed = deed;
    this.deedUUID = deedUUID;
    print("DEED UUID : ");
    print(deedUUID);
  }

  Future<void> _fetchDeed(String uuid) async {
    String url = Globals.backendURL + '/deedsv2/deed/' + uuid;

    var urlUri = Uri.parse(url);
    final response = await http.Client().get(urlUri);
    print(response.body);

    final parsed = jsonDecode(response.body);
    print(parsed);

    setState(() {
      deed = Deed.fromJson(parsed);
      _loading = false;
    });
    print(deed);
    print(deed.uuid);
    print(deed.toString());
  }

  @override
  void initState() {
    super.initState();
    //print('Deed UUID : ' + this.deedUUID);
    _error = false;
    _loading = true;
    //_fetchDeed(this.deedUUID);


    if(this.deed != null){
      _loading = false;
    } else if (this.deedUUID != null){
      _fetchDeed(this.deedUUID);
    } else {
      //Oops! We shouldn't be here!
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder.build(
      context: context,
      basePath: '/deeds',
      body : _loading ? Container(child: Center(child: new CircularProgressIndicator(),)) :
        //NOTE : DeedView's ListView MUST be encapsulated with something that defines it's size, like the Expanded used here
        //https://flutteragency.com/add-a-listview-to-a-column/
        //Expanded(child: new DeedView(deed: this.deed,),),
        new DeedView(deed: this.deed,)
    );
  }
}
