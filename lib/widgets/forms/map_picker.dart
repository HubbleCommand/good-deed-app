import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:good_deed/models/filters/location.dart';
import 'package:latlong/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  final FilterLocation filter;
  MapPickerScreen({this.filter});

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState(selectedPoint: filter.location, radius: filter.radius);
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng selectedPoint;
  double radius = 0;
  final _locationFormKey = GlobalKey<FormState>();

  _MapPickerScreenState({this.selectedPoint, this.radius});

  void _handleTap(LatLng latlng) {
    setState(() {
      selectedPoint = latlng;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(selectedPoint);
    print(radius);

    var markers = [Marker(
      width: radius == null ? 10 : radius /100,
      height: radius == null ? 10 : radius / 100,
      point: selectedPoint,
      builder: (ctx) => Container(
        child: FlutterLogo(),
      ),
    )];

    return Scaffold(
      appBar: AppBar(
        title: Text('Filter By Location'),
      ),
      body: Form(
          key: _locationFormKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Tap to select the area to filter in, along with the radius'),
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ ]'))],
                  initialValue: radius == null ? null : radius.toString(),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.title),
                    labelText: 'Distance',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      this.radius = double.parse(value);
                    });
                  },
                ),
                Flexible(
                  child: FlutterMap(
                    options: MapOptions(
                        center: LatLng(45.5231, -122.6765),
                        zoom: 13.0,
                        onTap: _handleTap),
                    layers: [
                      TileLayerOptions(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      ),
                      MarkerLayerOptions(markers: markers)
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Close the screen and return "Nope!" as the result.
                      if (_locationFormKey.currentState.validate()) {
                        _locationFormKey.currentState.save();

                        Navigator.pop(context, new FilterLocation(location: selectedPoint, radius: radius));
                      }
                    },
                    child: Text('Apply.'),
                  ),
                )
              ]
          )
      ),
    );
  }
}
