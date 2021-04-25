import 'package:good_deed/models/user.dart';
import 'package:good_deed/utils/geo.dart';
import 'package:latlong/latlong.dart';

class Deed {
  //final int deedId; //TODO check if this is needed
  final User deeder;
  final User deeded;
  final LatLng location;
  final int time;
  final String title;
  final String description;
  final List<String> pictures;  //Or just use string?

  //Deed({ this.deedId, this.deeder, this.deeded, this.location, this.time, this.title, this.description, this.pictures });
  Deed({ this.deeder, this.deeded, this.location, this.time, this.title, this.description, this.pictures });

  factory Deed.fromJson(Map<String, dynamic> json) {
    //TODO Check if have minimum to create Deed

    double lat = 0;
    double long = 0;
    if(json.containsKey('location')){
      lat = GeoUtils.sanitizeCoord(json['location']['lat']);
      long = GeoUtils.sanitizeCoord(json['location']['long']);
    }

    return new Deed(
      //deedId        : json['deedId'] as int,  //Shouldn't need anything else for null safety
      deeder        : json.containsKey('deeder') ? User.fromJson((json['deeder'])) : null,
      deeded        : json.containsKey('deeded') ? User.fromJson((json['deeded'])) : null,
      //location      : json.containsKey('location') ? LatLong.fromJson((json['location'])) : null,
      location      : json.containsKey('location') ? LatLng(lat, long) : null,
      time          : json['time'] as int,
      title         : json['title'] as String,
      description   : json['description'] as String,
      pictures      : json.containsKey('pictures') == true ? List.from(json['pictures']) : null,
    );
  }
}