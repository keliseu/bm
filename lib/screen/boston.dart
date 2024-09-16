import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';

class bostonMAPAPP extends StatefulWidget {
  const bostonMAPAPP({super.key});

  @override
  _bostonMAPAPPState createState() => _bostonMAPAPPState();
}

class _bostonMAPAPPState extends State<bostonMAPAPP> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildMap(),
          _buildLocationButton(context),
          _buildBottomNavigation(),
          _buildPopup(),
        ],
      ),
    );
  }



  bool _isNavBarVisible = true;
  bool _isPopupVisible = false;
  Map<String, dynamic>? _selectedStation;
  LatLng? _currentPosition;
  final MapController _mapController = MapController();
  bool _initialLocationSet = false;
  final String _apiKey = '';
  OpenRouteService? _openRouteService;
  LatLng? _destinationPoint;
  late GeoJsonParser geoJsonParser;
  List<Polygon> geoJsonPolygons = [];
  List<Polyline> customPolylines = [];
  List<Marker> geoJsonMarkers = [];
  List<Marker> stationMarkers = [];
  List<Marker> crMarkers = [];
  final List<String> miniNavItems = [
    'Subway', 'Bus', 'CR', 'tr', 'DD'
  ];
  final StreamController<bool> _navBarVisibilityController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _openRouteService = OpenRouteService(apiKey: _apiKey);
    _loadGeoJson();
    _loadStations();
  }


  @override
  void dispose() {
    _navBarVisibilityController.close();
    super.dispose();
  }

  void _updateNavBarVisibility(bool isVisible) {
    setState(() => _isNavBarVisible = isVisible);
    _navBarVisibilityController.add(isVisible);
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

  Future<void> _getRoute(LatLng start, LatLng end) async {
    try {
      final List<ORSCoordinate> routeCoordinates = await _openRouteService!
          .directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(
            latitude: start.latitude, longitude: start.longitude),
        endCoordinate: ORSCoordinate(
            latitude: end.latitude, longitude: end.longitude),
      );

      setState(() {});
    } catch (e) {
      print('Error fetching route: $e');
    }
  }



  void _showStationPopup(Map<String, dynamic> stationProperties) {
    setState(() {
      _isPopupVisible = true;
      _selectedStation = stationProperties;
    });
  }

  Future<void> _loadGeoJson() async {
    final String geoJsonString = await rootBundle.loadString(
        'data/us/massachusetts/greater_boston/mbta/rpt/mbtartl.json');
    final Map<String, dynamic> geoJsonData = json.decode(geoJsonString);

    geoJsonParser = GeoJsonParser();
    geoJsonParser.parseGeoJson(geoJsonData);

    setState(() {
      geoJsonPolygons = geoJsonParser.polygons;
      geoJsonMarkers = geoJsonParser.markers;
      customPolylines = _createColoredPolylines(geoJsonData);
    });
  }

  List<Polyline> _createColoredPolylines(Map<String, dynamic> geoJsonData) {
    List<Polyline> polylines = [];
    if (geoJsonData['type'] == 'FeatureCollection') {
      for (var feature in geoJsonData['features']) {
        if (feature['geometry']['type'] == 'LineString') {
          List<LatLng> points = (feature['geometry']['coordinates'] as List)
              .map((coord) => LatLng(coord[1].toDouble(), coord[0].toDouble()))
              .toList();

          Color color = _getColorFromProperties(feature['properties']);

          polylines.add(Polyline(
            points: points,
            color: color,
            strokeWidth: 3.0,
          ));
        }
      }
    }

    return polylines;
  }

  Future<void> _loadStations() async {
    final String stationsGeoJsonString = await rootBundle.loadString(
        'data/us/massachusetts/greater_boston/mbta/rpt/mbta_stations.json');
    final Map<String, dynamic> stationsGeoJsonData = json.decode(
        stationsGeoJsonString);

    setState(() {
      stationMarkers = _createStationMarkers(stationsGeoJsonData);
    });
  }

  List<Marker> _createStationMarkers(Map<String, dynamic> stationsGeoJsonData) {
    List<Marker> markers = stationMarkers;

    if (stationsGeoJsonData['type'] == 'FeatureCollection') {
      for (var feature in stationsGeoJsonData['features']) {
        if (feature['geometry']['type'] == 'Point') {
          var coordinates = feature['geometry']['coordinates'];
          LatLng point = LatLng(
              coordinates[1].toDouble(), coordinates[0].toDouble());

          markers.add(Marker(
            point: point,
            width: 30,
            height: 30,
            child: GestureDetector(
              onTap: () => _showStationPopup(feature['properties']),
              child: _buildStationMarker(feature['properties']),
            ),
          ));
        }
      }
    }
    return markers;
  }

  Widget _buildStationMarker(Map<String, dynamic> properties) {
    Color color = _getColorFromProperties(properties);
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(1),
        child: Image.asset(
          'assets/images/MBTA_LOGO.png',
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  Color _getColorFromProperties(Map<String, dynamic>? properties) {
    if (properties == null) return Colors.blue;

    switch (properties['route_id'] as String?) {
      case 'Red':
        return Color(0xFFFF3C3C);
      case 'Blue':
        return Color(0xFF002885);
      case 'Green-B':
      case 'C':
      case 'Green-D':
      case 'Green-E':
        return Color(0xFF09BF00);
      case 'Orange':
        return Color(0xFFD86F05);
      case 'Mattapan':
        return Color(0xFFFF3C3C);
      case 'Silver':
        return Color(0xFF999999);
      default:
        return Colors.brown;
    }
  }


  Widget _buildMap() {
    return GestureDetector(
      onPanStart: (_) => _updateNavBarVisibility(false),
      onPanEnd: (_) => _updateNavBarVisibility(true),
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(42.3601, -71.0589),
          initialZoom: 20.0,
          minZoom: 13.0,
          maxZoom: 20.0,
          onPointerDown: (_, __) => _updateNavBarVisibility(false),
          onPointerUp: (_, __) => _updateNavBarVisibility(true),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            subdomains: const ['a', 'b', 'c', 'd'],
            userAgentPackageName: 'us.bm.maps.us',
            retinaMode: true,
          ),
          PolygonLayer(polygons: geoJsonPolygons),
          PolylineLayer(polylines: customPolylines),
          MarkerLayer(markers: [
            ...stationMarkers,
            ...geoJsonMarkers,
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
            if (_destinationPoint != null)
              Marker(
                point: _destinationPoint!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
          ]),
        ],
      ),
    );
  }
  Widget _buildBottomNavigation() {
    return Stack(
      children: [
        Positioned(
          bottom: 80,
          left: 16,
          right: 16,
          child: StreamBuilder<bool>(
            stream: _navBarVisibilityController.stream,
            initialData: true,
            builder: (context, snapshot) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: snapshot.data! ? 60 : 0,
                child: _buildMiniNavBar(),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            child: _buildBottomNavBar(),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniNavBar() {
    final List<String> miniNavItems = ['Subway', 'Bus', 'CR', 'TR', 'DD'];
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(miniNavItems.length, (index) {
          return ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: EdgeInsets.all(8),
              minimumSize: Size(60, 25),
            ),
            child: _buildMiniNavBarButtonContent(index),
          );
        }),
      ),
    );
  }



  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(FontAwesomeIcons.mapPin, 'Explore'),
          _buildNavBarItem(FontAwesomeIcons.toilet, 'Restrooms'),
          _buildNavBarItem(FontAwesomeIcons.plus, 'Add'),
          _buildNavBarItem(Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Ndot',
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniNavBarButtonContent(int index) {
    final List<String> miniNavItems = ['Subway', 'Bus', 'CR', 'TR', 'DD'];
    final List<String> imageAssets = [
      'assets/images/icns/mbta/subway.png',
      'assets/images/icns/mbta/bus.png',
      'assets/images/icns/mbta/cr.png',
      'assets/images/icns/mbta/tr.png',
      'assets/images/dd.png',
    ];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 44,
            height: 32,
            child: Image.asset(
              imageAssets[index],
              fit: BoxFit.contain,
            ), ),
        ],
      ),
    );
  }

  Widget _buildRouteImage(String? routeId) {
    if (routeId == null) {
      return Text('Unknown Route');
    }
    String imagePath = 'assets/images/mbta/routes/$routeId.png';

    return Container(
      height: 50,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {

          return Text('Route: $routeId');
        },
      ),
    );
  }


  Widget _buildLocationButton(BuildContext context) {
    return Positioned(
      right: 16,
      top: 48,
      child: FloatingActionButton(
        backgroundColor: Colors.white60,
        child: const Icon(Icons.my_location, color: Colors.black,),
        onPressed: () {
          if (_currentPosition != null) {
            double newZoom = _mapController.camera.zoom + 2;
            newZoom = newZoom.clamp(15.0, 18.0);
            _mapController.move(_currentPosition!, newZoom);
          }
          Icon(Icons.my_location);
        },
      ),

    );
  }




  Widget _buildPopup() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      bottom: _isPopupVisible ? 0 : -MediaQuery.of(context).size.height / 6,
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height / 6,
      child: GestureDetector(
        onTap: () => setState(() => _isPopupVisible = false),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _selectedStation?['stop_name'] ?? 'Station',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildRouteImage(_selectedStation?['route_id']),
                  // Add more station information here
                ],
              ),
            ),
          ),
        ),
      ),
    );




}}