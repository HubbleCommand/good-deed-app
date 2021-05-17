import 'package:flutter/cupertino.dart';

class User {
  final String uuid;      //ID MUST be a string, as Firebase user ID is a string https://firebase.google.com/docs/reference/unity/class/firebase/auth/user-info-interface
  final String name;      //User's display name
  final String contact;   //TODO remove?
  final String avatarURL;    //Profile pic
  final String story;     //Quick intro to the user

  User({@required this.uuid, @required this.name, @required this.avatarURL, this.contact = "",  this.story = ""});

  @override
  String toString() {
    return 'User: {name: $name, id: $uuid}';
  }

  Map<String, dynamic> toJson(){
    return {
      "name": this.name,
      "uuid": this.uuid,
      "avatarURL": this.avatarURL,
      "story": this.story,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return new  User(
      uuid        : json['uuid'] as String,
      name        : json['name'] as String,
      contact     : json['contact'] as String,
      avatarURL   : json['avatar'] as String,
      story       : json['story'] as String,
    );
  }
}
