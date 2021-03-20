import 'package:flutter/material.dart';

import 'package:green_up/services/geolocator_service.dart';


import 'screens/map_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final geoService = GeolocatorService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenUp Demo',
      home: MapScreen(),
    );
  }
}
