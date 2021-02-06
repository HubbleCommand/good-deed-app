import 'package:geotools/geotools.dart';

class User { // / or Deedee
  final int userId;
  final String name;
  final String contact;
  final LatLong home;
  final String avatar;

  User({this.userId, this.name, this.contact, this.home, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return new  User(
      userId  : json['userId'] as int,
      name    : json['name'] as String,
      contact : json['contact'] as String,
      home    : json.containsKey('home') ? LatLong.fromJson(json['home']) : null,
      avatar  : json['avatar'] as String,
    );
  }
}
