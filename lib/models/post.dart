import 'dart:convert';

import 'package:good_deed/models/user.dart';
import 'package:geotools/geotools.dart';

class Post {
  final int postId;
  final User user;
  final LatLong location;
  final int time;
  final String title;
  final String content;
  final List<String> pictures;

  Post({ this.postId, this.user, this.location, this.time, this.title, this.content, this.pictures });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId    : json['postId'] as int,
      time      : json['time'] as int,
      user      : json['deeded'] ? User.fromJson((json['deeded'])) : null,
      location  : json['location'] ? LatLong.fromJson((json['location'])) : null,
      title     : json['title'] as String,
      content   : json['content'] as String,
      pictures  : jsonDecode(json['time']) as List<String>,
    );
  }
}
