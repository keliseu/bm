import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '/cities/boston/stops.dart';

class bostonMAPAPP extends StatefulWidget {
  @override
  _BostonMapAppState createState() => _BostonMapAppState();
}

class _BostonMapAppState extends State<bostonMAPAPP> {
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  bool _initialLocationSet = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        if (!_initialLocationSet) {
          _mapController.move(_currentPosition!, 15);
          _initialLocationSet = true;
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(42.3601, -71.0589), // Default to Boston
          initialZoom: 20.0,
          minZoom: 13.0,
          maxZoom: 20.0,

        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'us.bm.maps.us',
            // tileBuilder: (context, tileWidget, tile) {
            //   return DecoratedBox(
            //     decoration: BoxDecoration(
            //       border: Border.all(color: Colors.black12, width: 0.5),
            //     ),
            //     position: DecorationPosition.foreground,
            //     child: tileWidget,
            //   );
            // },
            // get rid of grid ^^
            // retina down vv
            tileProvider: NetworkTileProvider(),
            retinaMode: true,
          ),
          MarkerLayer(
            markers: [
              if (_currentPosition != null)
                Marker(
                  point: _currentPosition!,
                  width: 25,
                  height: 25,
                  child: const Icon(
                    Icons.radio_button_checked,
                    color: Colors.black,
                    size: 25.0,
                  ),
                ),
              ...bostonStops.map((stop) => Marker(
                point: stop.location,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(stop.name),
                          content: Text('This is a ${stop.type == StopType.bus ? "bus stop" : "train station"}.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(
                    stop.type == StopType.bus ? Icons.directions_bus : Icons.train,
                    color: stop.type == StopType.bus ? Colors.green : Colors.red,
                    size: 40.0,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white60,
        child: const Icon(Icons.my_location),
        onPressed: () {

          if (_currentPosition != null) {
            double newZoom = _mapController.camera.zoom + 2; // Increase zoom by 2 levels
            newZoom = newZoom.clamp(15.0, 18.0); // Ensure zoom is within bounds
            _mapController.move(_currentPosition!, newZoom);
          }
        },
      ),
    );
  }
}