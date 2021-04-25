import 'package:latlong/latlong.dart';

class FilterUser {
  int userId;
  String name;
  String contact;
  LatLng location;
  double radius;

  FilterUser({this.userId, this.name, this.contact, this.location, this.radius});

  String toUrlQuery({String preface}){
    String query = '';

    query += this.userId == null ? '': '&id=$userId';
    query += this.name == null ? '': '&name=$name';
    query += this.contact == null ? '': '&contact=$contact';
    //query += this.location == null ? '': '&location=$location';
    if(this.location != null){
      double longitude = location.longitude;
      double latitude = location.latitude;
      query += '&longitude=$longitude&latitude=$latitude';
    }
    query += this.radius == null ? '': '&radius=$radius';

    return query;
  }

  @override
  String toString() {
    return 'User: {name: ${name}}';
  }
}
