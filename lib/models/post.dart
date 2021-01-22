import 'package:good_deed/models/user.dart';
import 'package:geotools/geotools.dart';

class Post {
  final int postId;
  final User user;
  final LatLong location;
  final int time;

  Post({ this.postId, this.user, this.location, this.time });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId    : json['postId'],
      user    : json['user'],
      location  : json['location'],
      time      : json['time']
    );
  }
}