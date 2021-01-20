import 'geo.dart';

class Deed {
  final int deedId;
  final int deederId;
  final int deededId;
  final Point location;
  final int time;

  Deed({ this.deedId, this.deederId, this.deededId, this.location, this.time });

  factory Deed.fromJson(Map<String, dynamic> json) {
    return Deed(
      deedId    : json['deedId'],
      deederId  : json['deederId'],
      deededId  : json['deededId'],
      location  : json['location'],
      time      : json['time'],
    );
  }
}