import 'package:good_deed/models/user.dart';
import 'package:latlong/latlong.dart';

class FilterDeed{
  int deedId;
  User deeder;
  User deeded;
  LatLng location;
  double radius;
  int timeBefore;
  int timeAfter;
  String title;
  String description;

  FilterDeed({ this.deedId, this.deeder, this.deeded, this.location, this.radius, this.timeBefore, this.timeAfter, this.title, this.description });

  String toUrlQuery({String preface}){
    String query = '';

    query += this.deedId == null ? '': '&id=$deedId';
    query += this.deeder == null ? '': '&deeder=${deeder.userId}';
    query += this.deeded == null ? '': '&deeded=${deeded.userId}';
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

    return query;
  }

  @override
  String toString() {
    return title;
  }
}