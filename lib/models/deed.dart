import 'dart:convert';

import 'package:good_deed/models/user.dart';
import 'package:geotools/geotools.dart';

class Deed {
  final int deedId;
  final User deeder;
  final User deeded;
  final LatLong location;
  final int time;
  final String title;
  final String description;
  final String picture;  //Or just use string?

  //Deed({ this.deedId, this.deederId, this.deededId, this.location, this.time, this.title, this.description, String pictureSrc }): picture = new NetworkImage(pictureSrc);
  Deed({ this.deedId, this.deeder, this.deeded, this.location, this.time, this.title, this.description, this.picture });

  factory Deed.fromJson(Map<String, dynamic> json) {
    //JUST NEEDED TO CAST!!!
    return Deed(
      deedId        : json['deedId'] as int,
      deeder        : User.fromJson((json['deeder'])),
      deeded        : User.fromJson((json['deeded'])),
      //location      : LatLong.fromDecimal(json['location_x'] as double, json['location_y'] as double),
      location      : LatLong.fromJson((json['location'])),
      time          : json['time'] as int,
      title         : json['title'] as String,
      description   : json['description'] as String,
      picture       : json['picture'] as String
    );
  }

  jsonEncode(Deed deed){

  }
}