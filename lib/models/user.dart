import 'geo.dart';

class User { // / or Deedee
  final int userId;
  final String name;
  final String contact;
  final Point home;

  User({this.userId, this.name, this.contact, this.home});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId  : json['userId'],
      name    : json['name'],
      contact : json['contact'],
      home    : json['home'],
    );
  }
}