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
  final List<String> pictures;  //Or just use string?

  //Deed({ this.deedId, this.deederId, this.deededId, this.location, this.time, this.title, this.description, String pictureSrc }): picture = new NetworkImage(pictureSrc);
  Deed({ this.deedId, this.deeder, this.deeded, this.location, this.time, this.title, this.description, this.pictures });

  factory Deed.fromJson(Map<String, dynamic> json) {
    //Check if have minimum to create Deed
    return new Deed(
      deedId        : json['deedId'] as int,  //Shouldn't need anything else for null safety
      deeder        : json.containsKey('deeder') ? User.fromJson((json['deeder'])) : null,
      deeded        : json.containsKey('deeded') ? User.fromJson((json['deeded'])) : null,
      location      : json.containsKey('location') ? LatLong.fromJson((json['location'])) : null,
      time          : json['time'] as int,
      title         : json['title'] as String,
      description   : json['description'] as String,
      pictures      : json.containsKey('pictures') == true ? List.from(json['pictures']) : null,
    );
  }
}