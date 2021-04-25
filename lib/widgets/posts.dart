import 'package:flutter/material.dart';
import 'package:good_deed/models/filters/post.dart';
import 'package:good_deed/models/post.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:good_deed/widgets/views/post.dart';
import 'package:good_deed/widgets/views/user.dart';
import 'drawer.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/forms/filters/deed.dart';
import 'package:good_deed/globals.dart';
import 'package:good_deed/models/filters/deed.dart';
import 'package:good_deed/utils/geo.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'adds.dart';
import 'drawer.dart';
import 'package:good_deed/models/deed.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/image.dart' as ImageUtils;
import 'package:good_deed/forms/deed.dart';

class PostsPage extends StatelessWidget {
  static const String routeName = '/posts';
  final FilterPost filterPost;

  PostsPage({this.filterPost});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Posts"),
        ),
        drawer: GDDrawer(),
        body: Scaffold(
          body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  //child: Deeds(),
                  child: PostsList(filter: filterPost,),
                ),
              ]
          ),
          floatingActionButton: InkWell(
            splashColor: Colors.blue,
            child: FloatingActionButton(
              child: Icon(Icons.add),
              tooltip: 'Create new post',
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
class PostsList extends StatefulWidget {
  final FilterPost filter;
  PostsList({Key key, this.filter}) : super(key: key);

  @override
  PostsListState createState() => PostsListState(filter: filter);
}

class PostsListState extends State<PostsList> {
  bool _hasMore;
  int _pageNumber;
  bool _error;
  bool _loading;
  final int _defaultPostsPerPageCount = 10;
  final int _nextPageThreshold = 5;
  List<Post> posts;
  int timesFoundZeroPosts = 0;
  int timesFoundZeroPostsThreshold = 5;

  int _timeRequest;

  ScrollController _scrollController = new ScrollController();

  FilterPost postFilter;  //Filter param variable

  PostsListState({FilterPost filter}){
    this.postFilter = filter;
  }

  @override
  void initState() {
    super.initState();
    _hasMore = true;
    _pageNumber = 0;
    _error = false;
    _loading = true;
    posts = [];

    _timeRequest = DateTime.now().millisecondsSinceEpoch;

    _fetchPosts(_defaultPostsPerPageCount, _timeRequest);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // ... call method to load more deeds
        _fetchPosts(_defaultPostsPerPageCount, _timeRequest);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: getBody(),
            ),
            SizedBox(
              width: double.infinity,
              //TODO filter page...
              /*child: ElevatedButton(
                onPressed: () async {
                  final FilterPost result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeedFilterScreen(filter: this.postFilter)),
                  );
                  print('RECIEVED');
                  print(result.toUrlQuery());
                  setState(() {
                    this.posts.clear();
                    this.postFilter = result;
                    _fetchUsers(_defaultPostsPerPageCount, _timeRequest);
                  });
                  // Respond to button press
                },
                child: Text('Filter'),
              ),*/
            ),
          ]
      ),
    );
  }

  Widget getBody() {
    print('BUILDING POST LIST BODY');
    if (posts.isEmpty) {
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
                  _fetchPosts(_defaultPostsPerPageCount, _timeRequest);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text("Error loading posts, tap to try again"),
              ),
            ));
      } else {
        return Center(
          child: Text('No posts matching your criteria!'),
        );
      }
    } else {
      List<Widget> children = [];

      for(int index = 0; index < posts.length; index++){
        if(index % 10 == 0){
          children.add(new BannerAdWidget());
        }
        children.add(new PostItem(posts[index]));
        //If is last element, add ad widget
        if(index == posts.length - 1){
          children.add(new BannerAdWidget());
          children.add(LayoutUtils.listEndItemBuilder(message: 'No more posts!'));
        }
      }

      //TODO use ListView.builder like in : https://flutter.dev/docs/cookbook/lists/mixed-list. Is it worth it? Have tried and didn't work
      return ListView(
        controller: _scrollController,
        children: children,
      );
    }
  }

  List<Post> _parsePosts(String responseBody) {
    print('PARSING...');
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    print('DECODED POSTS');

    var calced = parsed.map<Post>((json) => Post.fromJson(json)).toList();
    print('DID LAST THING');
    return calced;
  }

  Future<void> _fetchPosts(int limit, int before) async {
    try {
      setState(() {
        _loading = true;
      });

      int skip = (_pageNumber) * _defaultPostsPerPageCount; //TODO needs to use the actual number of deeds!
      skip = posts.length;

      String url = Globals.backendURL + '/posts?' ;
      url += (this.postFilter != null && this.postFilter.toUrlQuery().isNotEmpty) ? this.postFilter.toUrlQuery() : '';
      url += skip != 0 ? '&start=$skip' : '';
      print(url);
      final response = await http.Client().get(url);
      print('GOT DEEDS');
      List<Post> parsedDeeds = _parsePosts(response.body);
      print('Number of deeds found: ' + parsedDeeds.length.toString());

      if(parsedDeeds.length == 0){
        timesFoundZeroPosts += 1;
      } else {
        timesFoundZeroPosts = 0;
      }

      setState(() {
        //_hasMore = parsedDeeds.length == _defaultPhotosPerPageCount; //THIS NEEDS TO BE CHANGED!!! It can keep requesting Deeds infinitely if there aren't enough!
        _hasMore = false;
        _loading = false;
        _pageNumber = _pageNumber + 1;
        posts.addAll(parsedDeeds);
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
        _error = true;
      });
    }
  }
}

class PostItem extends StatelessWidget {
  PostItem(this._post);
  final Post _post;
  final _biggerFont = TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //dense:true, //Makes stuff closer together & text smaller
      //isThreeLine: true, //Gives more space for subtitle (here, description), however can fuck / not fuck with other formatting (i.e. trailing size)
      //Distance from user. If no user location, don't include a leading Widget (null)
      //Title
      title: Text(
        _post.title.length > 20 ? _post.title.substring(0, 19) + '...' : _post.title,
        style: _biggerFont,
      ),
      //Trailing User Avatar images
      trailing: ImageUtils.Image.buildIcon(_post.pictures.first, 36.0, 36.0),
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new PostPage(post: _post)));
      },
    );
  }
}
