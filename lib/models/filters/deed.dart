import 'package:latlong/latlong.dart';
import 'package:good_deed/models/user.dart';

class FilterDeed{
  List<User> posters = [];
  List<User> didders = [];
  List<User> gotters = [];
  LatLng location;
  double radius;
  int timeBefore;
  int timeAfter;
  String title;
  String description;

  FilterDeed({ this.posters, this.didders, this.gotters, this.location, this.radius, this.timeBefore, this.timeAfter, this.title, this.description });

  String _buildUserArrayURL(List<User> users, String listName){
    String query = '&$listName=';
    for(User user in users){
      query += '${user.uuid},';
    }
    return query.substring(0, query.length - 1);
  }

  String toUrlQuery({String preface}){
    String query = '';

    //query += this.deeder == null ? '': '&deeder=${deeder.uuid}';
    //query += this.deeded == null ? '': '&deeded=${deeded.uuid}';
    //query += this.location == null ? '': '&location=$location';
    if(this.location != null){
      double longitude = location.longitude;
      double latitude = location.latitude;
      query += '&longitude=$longitude&latitude=$latitude';
    }
    query += this.radius == null ? '': '&radius=$radius';
    query += this.timeBefore == null ? '': '&before=$timeBefore';
    query += this.timeAfter == null ? '': '&after=$timeAfter';
    query += this.title == null ? '': '&title=$title';
    query += this.description == null ? '': '&description=$description';

    query += this.description == null ? '': '&description=$description';

    if(this.posters != null && this.posters.isNotEmpty){
      query += _buildUserArrayURL(this.posters, 'posters');
    }

    if(this.gotters != null && this.gotters.isNotEmpty){
      query += _buildUserArrayURL(this.gotters, 'gotters');
    }

    if(this.didders != null && this.didders.isNotEmpty){
      query += _buildUserArrayURL(this.didders, 'didders');
    }

    return query;
  }

  @override
  String toString() {
    //return title;
    return 'posters:${this.posters}, didders:${this.didders}, gotters:${this.gotters}, location:${this.location}, radius:${this.radius}, timeBefore:${this.timeBefore}, timeAfter:${this.timeAfter}, title:${this.title}, description:${this.description}';
  }
}