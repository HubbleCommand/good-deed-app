import 'dart:convert';

import 'package:good_deed/models/user.dart';
import 'package:latlong/latlong.dart';

class Post {
  final int postId;
  final User user;
  final LatLng location;
  final int time;
  final String title;
  final String content;
  final List<String> pictures;

  Post({ this.postId, this.user, this.location, this.time, this.title, this.content, this.pictures });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId    : json['postId'] as int,
      time      : json['time'] as int,
      user      : json.containsKey('user') ?  User.fromJson(json['user']) : null,
      //location  : json.containsKey('location') ? LatLng.fromJson(json['location']) : null,
      location  : json.containsKey('location') ? LatLng(json['location']['lat'], json['location']['long']) : null,
      title     : json['title'] as String,
      content   : json['content'] as String,
      //pictures  : List.from(json['pictures']) as List<String>,
      /*pictures: List.fromMap(Map<String, dynamic> data) {
        likes = data['likes'].cast<String>();
      }*/
      pictures: json['pictures'].cast<String>()
    );
  }
}
