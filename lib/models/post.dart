import 'geo.dart';

class Post {
  final int postId;
  final int userId;
  final Point location;
  final int time;

  Post({ this.postId, this.userId, this.location, this.time });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId    : json['postId'],
      userId    : json['userId'],
      location  : json['location'],
      time      : json['time']
    );
  }
}