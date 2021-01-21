import 'package:flutter/cupertino.dart';
import 'package:good_deed/models/user.dart';
import 'geo.dart';

class Deed {
  final int deedId;
  /*
  final User deederId;
  final User deededId;
  */
  final int deederId;
  final int deededId;
  final Point location;
  final int time;
  final String title;
  final String description;
  final NetworkImage picture;  //Or just use string?

  Deed({ this.deedId, this.deederId, this.deededId, this.location, this.time, this.title, this.description, String pictureSrc }): picture = new NetworkImage(pictureSrc);

  factory Deed.fromJson(Map<String, dynamic> json) {
    return Deed(
      deedId        : json['deedId'],
      deederId      : json['deederId'],
      deededId      : json['deededId'],

      /*
      deederId      : User.fromJson(json)   json['deederId'],
      deededId      : json['deededId'],
       */
      location      : json['location'],
      time          : json['time'],
      title         : json['title'],
      description   : json['description'],
      pictureSrc    : json['avatar']
    );
  }
}