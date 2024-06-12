
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter/material.dart';

class MuseumMap extends StatefulWidget {
  @override
  _MuseumMapState createState() => _MuseumMapState();
}

class _MuseumMapState extends State<MuseumMap> {
  double _xPosition = 100.0;
  double _yPosition = 200.0;
  final double _mapWidth = 386.0; // Set this to the width of your map image
  final double _mapHeight = 386.0; // Set this to the height of your map image

  // Variables to hold the GPS bounds of the museum
  late double _minLat;
  late double _maxLat;
  late double _minLng;
  late double _maxLng;

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermissions();
  }

  Future<void> _checkAndRequestPermissions() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      _getCurrentLocation();
      _startLocationUpdates();
    } else if (status.isDenied || status.isPermanentlyDenied) {
      var result = await Permission.location.request();
      if (result.isGranted) {
        _getCurrentLocation();
        _startLocationUpdates();
      } else {
        // Handle the case when the user denies the permission
        openAppSettings();
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _setBoundingBox(position.latitude, position.longitude);
    _updateUserPosition(position.latitude, position.longitude);
    print("Current latitude: ${position.latitude}");
    print("Current longitude: ${position.longitude}");
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Minimum change in distance (meters) before updates are sent
      ),
    ).listen((Position position) {
      _updateUserPosition(position.latitude, position.longitude);
      print("New latitude: ${position.latitude}");
      print("New longitude: ${position.longitude}");
      print("===" * 10);
    });
  }

  void _setBoundingBox(double lat, double lng) {


    const double distance = 30.0; // 500 meters

    // Calculate latitude bounds (1 degree latitude ~ 111.32 km)
    double latDelta = distance / 111320.0; // meters to degrees
    _minLat = lat - latDelta;
    _maxLat = lat + latDelta;
    print("Museum minLat: $_minLat");
    print("Current maxLat: $_maxLat");

    // Calculate longitude bounds (1 degree longitude ~ varies with latitude)
    double lngDelta = distance / (111320.0 * cos(lat * (pi / 180.0)));
    _minLng = lng - lngDelta;
    _maxLng = lng + lngDelta;
    print("Museum minLng: $_minLng");
    print("Current maxLng: $_maxLng");
  }

  void _updateUserPosition(double lat, double lng) {
    // Convert GPS coordinates to image coordinates
    double x = _mapWidth * (lng - _minLng) / (_maxLng - _minLng);
    double y = _mapHeight * (1 - (lat - _minLat) / (_maxLat - _minLat)); // Invert y-axis

    // Ensure the position is within the map boundaries
    setState(() {
      _xPosition = x.clamp(0.0, _mapWidth - 48.0); // 48 is the width of the pin
      _yPosition = y.clamp(0.0, _mapHeight - 48.0); // 48 is the height of the pin
    });
  }


@override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Museum Map'),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/museum_map.jpg',
              width: _mapWidth,
              height: _mapHeight,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: _xPosition,
              top: _yPosition,
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.red,
                size: 48.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}