import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bm/cityChoosingSetup.dart';

class setupPage2 extends StatefulWidget {
  const setupPage2({super.key});

  @override
  _SetupPage2State createState() => _SetupPage2State();
}

class _SetupPage2State extends State<setupPage2> {
  bool _locationPermissionGranted = false;

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showCustomDialog('Please enable location services.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showCustomDialog('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showCustomDialog('Allow location so that we can send you wherever you please.');
      return;
    }

    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      setState(() {
        _locationPermissionGranted = true;
      });
    }
  }

  void _showCustomDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Location Permission Required',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Ndot',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                Colors.white,
                Color(0xFFF8F8F8),
                Color(0xFFF0F0F0),
                Color(0xFFE8E8E8),
                Color(0xFFE0E0E0),
                Color(0xFFD8D8D8),
                Color(0xFFD0D0D0),
                Color(0xFFC8C8C8),
              ]
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Allow Location',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 48,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please allow bm to use your location for the best route accuracy.',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _locationPermissionGranted ? 'Location permission granted' : 'Location permission not granted',
                  style: TextStyle(
                    fontFamily: 'Ndot',
                    fontWeight: FontWeight.w400,
                    color: _locationPermissionGranted ? Colors.green : Colors.red,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              height: 50,
              margin: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: _locationPermissionGranted
                    ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const cityChoosingSetup()),
                  );
                }
                    : () {
                  _checkLocationPermission();
                  if (!_locationPermissionGranted) {
                    _showCustomDialog('Please grant location permission to continue');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xfff000),
                ),
                child: const Center(
                  child: Text(
                    'continue',
                    style: TextStyle(
                      fontFamily: 'Ndot',
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}