import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/utils/geo.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/forms/filter/deed.dart';
import 'package:good_deed/widgets/forms/posters/deed.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:good_deed/widgets/drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/utils/image.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/routes/deed.dart';

class DeedsPage extends StatelessWidget {
  static const String routeName = '/deeds';
  final FilterDeed filterDeed;

  DeedsPage({this.filterDeed});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deeds"),
        ),
        drawer: GDDrawer(),
        body: Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  //child: Deeds(),
                  child: DeedsList(filter: filterDeed,),
                ),
              ]
          ),
          floatingActionButton: InkWell(
            splashColor: Colors.blue,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'Create new deed',
              onPressed: (){
                if(FirebaseAuth.instance.currentUser != null){
                  print(FirebaseAuth.instance.currentUser);
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NewDeedForm()));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        //return PrivacyAlertDialog();
                        return AlertDialog(
                          title: Text('Sign in to contribute'),
                          content: Text('To be able to submit content, you must have an account & be signed in \n\nGo to the Drawer -> Account, and sign in or sign up with your preferred provider.'),
                        );
                      }
                  );
                }
              },
            ),
          ),
        )
    );
  }
}

//TODO look at this: https://medium.com/@sharmadhiraj.np/infinite-scrolling-listview-on-flutter-88d7a5e2bb4
class DeedsList extends StatefulWidget {
  final FilterDeed filter;
  DeedsList({Key key, this.filter}) : super(key: key);

  @override
  DeedsListState createState() => DeedsListState(filter: filter);
}

class DeedsListState extends State<DeedsList> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultDeedsPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<Deed> futureDeeds2;
  int timesFoundZeroDeeds = 0;
  int timesFoundZeroDeedsThreshold = 5;

  int _timeRequest;

  FilterDeed deedFilter;  //Filter param variable

  DeedsListState({FilterDeed filter}){
    this.deedFilter = filter;
  }

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 0;
    _error = false;
    _loading = true;
    futureDeeds2 = [];

    _timeRequest = DateTime.now().millisecondsSinceEpoch;

    _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //new BannerAdWidget(),
            LayoutUtils.widenButton(
              ElevatedButton(
                onPressed: () async {
                  this.futureDeeds2.clear();
                  //this.deedFilter = result;
                  _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
                },
                child: Text('Reload'),
              ),
            ),
            Expanded(
              child: getBody(),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final FilterDeed result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeedFilterScreen(filter: this.deedFilter)),
                  );
                  print('RECIEVED : ' + result.toUrlQuery());
                  setState(() {
                    this.futureDeeds2.clear();
                    this.deedFilter = result;
                    _fetchDeeds(_defaultDeedsPerPageCount, _timeRequest);
                  });
                },
                child: Text('Filter'),
              ),
            ),
          ]
      ),
    );
  }

  Widget getBody() {
    if (futureDeeds2.isEmpty) {
      if (_loading) {
        return _buildLoadingIndicator();
      } else if (_error) {
        //TODO this can appear when no deeds are found! This should ONLY appear when an actual error occurs in fetching deeds...
        return _buildErrorWidget(message: 'Error while fetching deeds, tap to try again');
      } else {
        return _buildErrorWidget(message: 'No more deeds, or no deeds matching criteria! \n Apply different filters, or tap to try again');
      }
    } else {
      return ListView.builder(
          itemCount: futureDeeds2.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            //if (index == futureDeeds2.length - _nextPageThreshold) {
            if (index == futureDeeds2.length - _nextPageThreshold && timesFoundZeroDeeds < timesFoundZeroDeedsThreshold) {
              _fetchDeeds(10, _timeRequest);
            }
            if(timesFoundZeroDeeds >= timesFoundZeroDeedsThreshold){
              //TODO make an end item to show that at end of list : https://flutter.dev/docs/cookbook/lists/mixed-list Is it worth it? Have tried and didn't work
            }
            if (index == futureDeeds2.length) {
              if (_error) {
                return _buildErrorWidget(message: 'Error while displaying photos, tap to try again');
              } else {
                return _buildLoadingIndicator();
              }
            }
            LatLng location;
            if(this.deedFilter != null){
              location = this.deedFilter.location != null ? this.deedFilter.location : null;
            }
            return DeedItem(futureDeeds2[index], userLocation: location,);
          }
      );
    }
  }

  Widget _buildErrorWidget({String message}){
    return Center(
        child: InkWell(
          onTap: () {
            setState(() {
              _loading = true;
              _error = false;
              _fetchDeeds(10, _timeRequest);
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(message, textAlign: TextAlign.center,),
          ),
        )
    );
  }

  Widget _buildLoadingIndicator(){
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ));
  }

  List<Deed> _parseDeeds(String responseBody) {
    print('PARSING...');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    print('DECODED DEEDS');

    var calced = parsed.map<Deed>((json) => Deed.fromJson(json)).toList();
    print('DID LAST THING');
    return calced;
  }

  Future<void> _fetchDeeds(int limit, int before) async {
    try {
      //THIS CAUSES ERRORS, cannot use setState immediately... (as this func is called in init state)
      /*setState(() {
        _loading = true;
      });*/
      _loading = true;
      int skip = futureDeeds2.length; //(_pageNumber) * _defaultDeedsPerPageCount; //needs to use the actual number of deeds!

      print(this.deedFilter);
      String url = Globals.backendURL + '/deedsv2?' ;
      url += (this.deedFilter != null && this.deedFilter.toUrlQuery().isNotEmpty) ? this.deedFilter.toUrlQuery() : '';
      url += skip != 0 ? '&start=$skip' : '';
      print(url);
      var urlUri = Uri.parse(url);
      final response = await http.Client().get(urlUri);
      print('GOT DEEDS');
      List<Deed> parsedDeeds = _parseDeeds(response.body);
      print('Number of deeds found: ' + parsedDeeds.length.toString());

      if(parsedDeeds.length == 0){
        timesFoundZeroDeeds += 1;
      } else {
        timesFoundZeroDeeds = 0;
      }

      setState(() {
        //_hasMore = parsedDeeds.length == _defaultPhotosPerPageCount; //THIS NEEDS TO BE CHANGED!!! It can keep requesting Deeds infinitely if there aren't enough!
        _hasMore = false;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        futureDeeds2.addAll(parsedDeeds);
      });
    } catch (e) {
      print('ERROR');
      print(e);
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}

class DeedItem extends StatelessWidget {
  DeedItem(this._deed, {this.userLocation = null});
  final Deed _deed;
  //final LatLng userLocation = Globals.mockedHome;  //TODO get actual location if available
  final LatLng userLocation;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //dense:true, //Makes stuff closer together & text smaller
      //isThreeLine: true, //Gives more space for subtitle (here, description), however can fuck / not fuck with other formatting (i.e. trailing size)
      //Distance from user. If no user location, don't include a leading Widget (null)
      leading: userLocation == null ? null : Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                (GeoUtils.distanceInMeters(userLocation, _deed.location) / 1000).roundToDouble().toString() + ' km',
                textAlign: TextAlign.center,
              ),
            ],
          )
      ),
      //Title
      title: Text(
        _deed.title.length > 20 ? _deed.title.substring(0, 19) + '...' : _deed.title,
        style: _biggerFont,
      ),
      //Description
      subtitle: Text(
        _deed.description.length > 30 ? _deed.description.substring(0, 29) + '...' : _deed.description,
      ),
      trailing: (_deed.pictures != null && _deed.pictures.length > 0) ? Container(
        child: ImageUtil.buildIcon(_deed.pictures.first, 36.0, 36.0),
      ) : null,
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedPage(deed: _deed)));
      },
    );
  }
}
