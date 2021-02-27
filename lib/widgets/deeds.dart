import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/widgets/deed.dart';
import 'package:geotools/geotools.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/forms/deed.dart';

class DeedsPage extends StatelessWidget {
  static const String routeName = '/deeds';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Deeds"),
        ),
        drawer: GDDrawer(),
        //body: Deeds());
        body: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                //child: Deeds(),
                child: DeedsList2(),
              ),
            ]
        ),
        floatingActionButton: InkWell(
          splashColor: Colors.blue,
          child: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Create new deed',
            onPressed: (){
              Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new NewDeedForm()));
            },
          ),
        ),
      )
    );
  }
}

//TODO look at this: https://medium.com/@sharmadhiraj.np/infinite-scrolling-listview-on-flutter-88d7a5e2bb4
List<Deed> parseDeeds(String responseBody) {
  print('PARSING...');
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  print('DECODED DEEDS');

  var calced = parsed.map<Deed>((json) => Deed.fromJson(json)).toList();
  print('DID LAST THING');
  return calced;
}

Future<List<Deed>> fetchDeeds() async {
  final response = await http.Client().get('http://192.168.1.33:3000/deeds');
  print('GOT DEEDS');
  return compute(parseDeeds, response.body);
}

//TODO make stateful!
class Deeds extends StatelessWidget{
  Deeds({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*return Scaffold(
      body: FutureBuilder<List<Deed>>(
        future: fetchDeeds(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? DeedsList2(deeds: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );*/
    return Scaffold(
      body: DeedsList2()
    );
  }
}

class DeedsList2 extends StatefulWidget {
  DeedsList2({Key key}) : super(key: key);

  @override
  DeedsList2State createState() => DeedsList2State();
}

class DeedsList2State extends State<DeedsList2> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultPhotosPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<Deed> futureDeeds2;
  int timesFoundZeroDeeds = 0;
  int timesFoundZeroDeedsThreshold = 5;

  int _timeRequest;

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 0;
    _error = false;
    _loading = true;
    futureDeeds2 = [];

    _timeRequest = DateTime.now().millisecondsSinceEpoch;

    fetchDeeds(10, _timeRequest);
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    if (futureDeeds2.isEmpty) {
      if (_loading) {
        return Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircularProgressIndicator(),
            ));
      } else if (_error) {
        return Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  _loading = true;
                  _error = false;
                  fetchDeeds(10, _timeRequest);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error while loading photos, tap to try agin"),
              ),
            ));
      }
    } else {
      return ListView.builder(
          itemCount: futureDeeds2.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            //if (index == futureDeeds2.length - _nextPageThreshold) {
            if (index == futureDeeds2.length - _nextPageThreshold && timesFoundZeroDeeds < timesFoundZeroDeedsThreshold) {
              fetchDeeds(10, _timeRequest);
            }
            if(timesFoundZeroDeeds >= timesFoundZeroDeedsThreshold){
              //TODO make an end item to show that at end of list : https://flutter.dev/docs/cookbook/lists/mixed-list
              //return new EndItem(index);
              //return new Text(index.toString() + ' End');
            }
            if (index == futureDeeds2.length) {
              if (_error) {
                return Center(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _loading = true;
                          _error = false;
                          fetchDeeds(10, _timeRequest);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text("Error while loading photos, tap to try agin"),
                      ),
                    ));
              } else {
                return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: CircularProgressIndicator(),
                    ));
              }
            }
            //final Deed deedLoc = futureDeeds2[index];
            return DeedItem(futureDeeds2[index]);
          });
    }
    return Container();
  }

  Future<void> fetchDeeds(int limit, int before) async {
    try {
      int skip = (_pageNumber) * 10; //TODO needs to use the actual number of deeds!
      skip = futureDeeds2.length;
      //String url = 'http://192.168.1.33:3000/deeds?limit=$limit&before=$before&start=$skip';
      //String url = 'http://192.168.1.33:3000/deeds';
      String url = '';
      if(skip == 0){
        url = 'http://192.168.1.33:3000/deeds?limit=$limit&before=$before';
      } else {
        url = 'http://192.168.1.33:3000/deeds?limit=$limit&before=$before&start=$skip';
      }

      print(url);
      final response = await http.Client().get(url);
      print('GOT DEEDS');
      //return compute(parseDeeds, response.body);
      List<Deed> parsedDeeds = parseDeeds(response.body);
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
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}

class DeedsList extends StatelessWidget {
  final List<Deed> deeds;

  DeedsList({Key key, this.deeds}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: deeds.length,
      itemBuilder: (context, index) {
        return DeedItem(deeds[index]);
      },
    );
  }
}

class EndItem extends StatelessWidget {
  EndItem(this._index);
  final int _index;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_index.toString() + ' End'),
    );
  }
}

class DeedItem extends StatelessWidget {
  DeedItem(this._deed);
  final Deed _deed;
  final LatLong statueOfLiberty = LatLong.fromDecimal(40.68972222, 72.04444444);  //Mocked User Location
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
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
                (GeoUtils.distanceInMeters(statueOfLiberty, _deed.location) / 1000).roundToDouble().toString() + ' km',
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
      //Trailing User Avatar images
      trailing: Container(
        child: new Stack(
          clipBehavior:Clip.none,
          children: <Widget>[
            ImageUtils.Image.buildIcon(_deed.deeder.avatar, 36.0, 36.0),
            new Positioned(
              left: 20.0,
              child:ImageUtils.Image.buildIcon(_deed.deeded.avatar, 36.0, 36.0),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedPage(deed: _deed)));
      },
    );
  }

}

//TODO turn to stateless? Maybe not, as setState() is easy way to redraw / add elements to list without rebuilding / re-rendering everything / whole list!
class DeedsOld extends StatefulWidget {
  @override
  _DeedsState createState() => _DeedsState();
}

class _DeedsState extends State<DeedsOld> {
  final _deeds = <Deed>[];
  //final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  final LatLong statueOfLiberty = LatLong.fromDecimal(40.68972222, 72.04444444);  //Mocked User Location
  //String title;
  //String description;

  Widget _buildRow(Deed deed) {
    //final alreadySaved = _saved.contains(pair);

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
              (GeoUtils.distanceInMeters(statueOfLiberty, deed.location) / 1000).roundToDouble().toString() + ' km',
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
        child: new Stack(
          clipBehavior:Clip.none,
          children: <Widget>[
            ImageUtils.Image.buildIcon(deed.deeder.avatar, 36.0, 36.0),
            new Positioned(
              left: 20.0,
              child:ImageUtils.Image.buildIcon(deed.deeded.avatar, 36.0, 36.0),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DeedPage(deed: deed)));
      },
    );
  }

  Widget _buildDeeds() {
    //https://flutter.dev/docs/cookbook/lists/long-lists
    //So, based on these:
    //  -https://googleflutter.com/flutter-add-item-to-listview-dynamically/
    //  -https://stackoverflow.com/questions/51343567/append-items-dynamically-to-listview
    //Setting state to update _deeds will add items, so pretty easy?
    //Just need to add controller, so that can see when close to bottom to retrieve like 10 more deeds
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _deeds.length,
        itemBuilder: (context, i) {
          return _buildRow(_deeds[i]);
        }
      );
  }

  _buildFilterForm(Key key){
    return Form(
      key: key,
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
                  onFieldSubmitted: (String value){/*title=value;*/},
                ),
              ),
            ]
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    //Build sample deeds
    //TODO use http or dio to get deeds, with filters
    _deeds.clear(); //Need to clear the current deeds? TODO make sure this works well with setState(), or just call it first in setState()!
    for (var i = 0; i < 10; i++) {
      _deeds.add(
          new Deed(
              deedId          : i,
              deeder          : new User(
                userId  : 1,
                name    : 'Bob',
                contact : 'bob@gmail.com',
                home    : LatLong.fromDecimal(48.85805556, 2.29416667),
                avatar: 'https://image.shutterstock.com/image-vector/user-icon-man-business-suit-600w-1700749465.jpg',
              ),
              deeded          : new User(
                userId  : 2,
                name    : 'Alice',
                contact : 'alice@gmail.com',
                home    : LatLong.fromDecimal(48.85805556, 2.29416667),
                avatar: 'https://image.shutterstock.com/image-vector/business-woman-icon-avatar-symbol-600w-790518412.jpg',
              ),
              location        : new LatLong.fromDecimal(48.85805556, 2.29416667),
              time            : 1,
              title           : "Deed " + i.toString(),
              description     : "Deed description " + i.toString(),
              //picture         : 'https://i.imgur.com/BoN9kdC.png'
              pictures: ['https://picsum.photos/200']
          )
      );
    }

    final _formKey = GlobalKey<FormState>();
    final _filterFormKey = GlobalKey<FormState>();

    //TODO Most of this needs to be moved! Only keep the Expanded with _buildDeeds() as child! -> Everything else is NOT related to displaying deeds, which is the purpose of this stateful widget!
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
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return Dialog(
                      child: Stack(
                        children: [
                          Text(
                            'Filter Deeds',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          _buildFilterForm(_filterFormKey)
                        ],
                      ),
                    );
                  }
                );
                // Respond to button press
              },
              child: Text('Filter'),
            ),
          ),
        ]
      ),
    );
  }
}
