import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kRoma = CameraPosition(
    target: LatLng(41.893056, 12.482778),
    zoom: 16,
  );

  Future<PermissionStatus> getPermission() async {
    return await Permission.location.request();
  }

  Future<Position> getLocation() async {
    return getPermission().then((result) async {
      if (result == PermissionStatus.granted) {
        //va gestita anche la parte iOS
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else
        return null;
    });
  }

  void _setMapstyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('./assets/map_style.json');
    controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    //final Position initialPosition = Provider.of<Position>(context);
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: _kRoma,
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _setMapstyle(controller);
          getLocation().then((value) {
            if (value != null) {
              controller.moveCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(value.latitude, value.longitude),
                    zoom: 16,
                  ),
                ),
              );
              controller.dispose();
            }
          });
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
      ),
    );
  }
}
