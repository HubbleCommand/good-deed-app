import 'package:geotools/geotools.dart';

class User { // / or Deedee
  final int userId;
  final String name;
  final String contact;
  final LatLong home;
  final String avatar;

  User({this.userId, this.name, this.contact, this.home, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId  : json['userId'],
      name    : json['name'],
      contact : json['contact'],
      home    : json['home'],
      avatar: json['avatar'],
    );
  }
}