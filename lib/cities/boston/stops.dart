import 'package:latlong2/latlong.dart';

enum StopType { bus, train }

class Stop {
  final String name;
  final LatLng location;
  final StopType type;

  Stop({required this.name, required this.location, required this.type});
}

final List<Stop> bostonStops = [
  Stop(name: "Bus Stop 1", location: LatLng(42.3601, -71.0589), type: StopType.bus),
  Stop(name: "Train Station 1", location: LatLng(42.3555, -71.0607), type: StopType.train),
  // Add more stops as needed
];