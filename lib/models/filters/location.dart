import 'package:latlong/latlong.dart';

class FilterLocation {
  final LatLng location;
  final double radius;

  FilterLocation({this.location, this.radius});

  String toUrlQuery({String preface}){
    String query = '';

    if(this.location != null){
      double longitude = location.longitude;
      double latitude = location.latitude;
      query += '&longitude=$longitude&latitude=$latitude';
    }
    query += this.radius == null ? '': '&radius=$radius';

    return query;
  }
}
