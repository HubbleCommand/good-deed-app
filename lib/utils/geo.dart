import 'dart:math';
import 'package:latlong/latlong.dart';

class GeoUtils {
  static double sanitizeCoord(dynamic coord){
    if(coord.runtimeType == int){
      int coordLoc = coord as int;
      return coordLoc.toDouble();
    } else if (coord.runtimeType == double){
      return coord;
    } else if (coord.runtimeType == String){
      return double.parse(coord);
    } else {
      return null;  //TODO throw
    }
  }

  static bool sameLocation(final LatLng pA, final LatLng pB) {
    if (pA == null) {
      throw ArgumentError.value(pA, "pA", "cannot be null");
    }
    if (pB == null) {
      throw ArgumentError.value(pB, "pB", "cannot be null");
    }
    return (pA.latitude == pB.latitude) &&
        (pA.longitude == pB.longitude);
  }

  static double distanceInMeters(final LatLng pA, final LatLng pB) {
    if (pA == null) {
      throw ArgumentError.value(pA, "pA", "cannot be null");
    }
    if (pB == null) {
      throw ArgumentError.value(pB, "pB", "cannot be null");
    }
    const int R = 6371; // Radius of the earth

    final double lat1 = pA.latitude;
    final double lat2 = pB.latitude;

    final double lon1 = pA.longitude;
    final double lon2 = pB.longitude;

    final double latDistance = _toRadians(lat2 - lat1);
    final double lonDistance = _toRadians(lon2 - lon1);

    final double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = R * c * 1000; // convert to meters

    //double height = el1 - el2;
    final double height = 0;

    distance = pow(distance, 2) + pow(height, 2);

    return sqrt(distance);
  }

  static double _toRadians(double pDecimal) {
    return pDecimal / 180 * pi;
  }
}
