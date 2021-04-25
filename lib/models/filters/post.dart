import 'package:good_deed/models/user.dart';
import 'package:latlong/latlong.dart';

class FilterPost {
  final int postId;
  final User user;
  final LatLng location;
  double radius;
  int timeBefore;
  int timeAfter;
  final String title;
  final String content;

  FilterPost({ this.postId, this.user, this.location, this.radius, this.timeBefore, this.timeAfter, this.title, this.content });

  String toUrlQuery({String preface}){
    String query = '';

    query += this.postId == null ? '': '&id=$postId';
    query += this.user == null ? '': '&user=$user';
    if(this.location != null){
      double longitude = location.longitude;
      double latitude = location.latitude;
      query += '&longitude=$longitude&latitude=$latitude';
    }
    query += this.radius == null ? '': '&radius=$radius';
    query += this.timeBefore == null ? '': '&before=$timeBefore';
    query += this.timeAfter == null ? '': '&after=$timeAfter';
    query += this.title == null ? '': '&title=$title';
    query += this.content == null ? '': '&content=$content';

    return query;
  }
}
