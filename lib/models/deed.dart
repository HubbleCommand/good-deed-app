import 'package:good_deed/globals.dart';
import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/geo.dart';
import 'package:latlong/latlong.dart';

class Deed {
  final String uuid;
  final User poster;
  final List<User> didders;
  final List<User> gotters;
  final LatLng location;
  final int time;
  final String title;
  final String description;
  List<String> pictures;

  Deed({ this.uuid, this.poster, this.didders, this.gotters, this.location, this.time, this.title, this.description, this.pictures });

  factory Deed.fromJson(Map<String, dynamic> json) {

    //print(json);
    //TODO Check if have minimum to create Deed
    double lat = 0;
    double long = 0;
    if(json.containsKey('location')){
      lat = GeoUtils.sanitizeCoord(json['location']['lat']);
      long = GeoUtils.sanitizeCoord(json['location']['long']);
    }

    return new Deed(
      uuid          : json.containsKey('uuid') ? json['uuid'] as String : null,
      //didders       : json['didders'].cast<User>(),
      //didders       : List.from(json['didders']),
      didders       : List<User>.from(json['didders'].map((x) => User.fromJson(x))),
      gotters       : List<User>.from(json['gotters'].map((x) => User.fromJson(x))),
      poster: User.fromJson(json['posters'][0]),  //TODO once only one poster is resturned, remove [0]!

      //location      : json.containsKey('location') ? LatLong.fromJson((json['location'])) : null,
      location      : json.containsKey('location') ? LatLng(lat, long) : null,
      time          : json.containsKey('time') ? json['time'] as int : null,
      title         : json['title'] as String,
      description   : json['description'] as String,
      //pictures      : json.containsKey('pictures') == true ? List.from(json['pictures']) : null,
      pictures      : json.containsKey('pictures') == true ? json['pictures'].cast<String>() : null,
    );
  }
}