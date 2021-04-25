import 'package:good_deed/utils/geo.dart';
import 'package:latlong/latlong.dart';

class User { // / or Deedee
  final String userId;  //ID MUST be a string, as Firebase user ID is a string https://firebase.google.com/docs/reference/unity/class/firebase/auth/user-info-interface
  final String name;      //User's display name
  final String contact;   //TODO remove?
  final LatLng home;      //Home location
  final String avatar;    //Profile pic
  final String story;     //Quick intro to the user

  User({this.userId, this.name, this.contact, this.home, this.avatar, this.story});

  @override
  String toString() {
    return 'User: {name: $name, id: $userId}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    double lat = GeoUtils.sanitizeCoord(json['home']['lat']);
    double long = GeoUtils.sanitizeCoord(json['home']['long']);

    return new  User(
      userId  : json['uuid'] as String,
      name    : json['name'] as String,
      contact : json['contact'] as String,
      //home    : json.containsKey('home') ? LatLong.fromJson(json['home']) : null,
      //home    : json.containsKey('home') ? LatLng(json['home']['lat'], json['home']['long']) : null,
      home    : json.containsKey('home') ? LatLng(lat, long) : null,
      avatar  : json['avatar'] as String,
    );
  }
}
