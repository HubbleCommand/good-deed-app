import 'package:latlong/latlong.dart';

class User { // / or Deedee
  final String userId;  //ID MUST be a string, as Firebase user ID is a string https://firebase.google.com/docs/reference/unity/class/firebase/auth/user-info-interface
  final String name;
  final String contact;
  final LatLng home;
  final String avatar;

  User({this.userId, this.name, this.contact, this.home, this.avatar});

  @override
  String toString() {
    return 'User: {name: $name, id: $userId}';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new  User(
      userId  : json['userId'] as String,
      name    : json['name'] as String,
      contact : json['contact'] as String,
      //home    : json.containsKey('home') ? LatLong.fromJson(json['home']) : null,
      home    : json.containsKey('home') ? LatLng(json['home']['lat'], json['home']['long']) : null,
      avatar  : json['avatar'] as String,
    );
  }
}
