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
    zoom: 11,
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
      body: FutureBuilder(
        future: getLocation(),
        builder: (context, snapshot) {
          print(snapshot.data);
          return snapshot.connectionState == ConnectionState.done
              ? GoogleMap(
                  initialCameraPosition: snapshot.hasData == false
                      ? _kRoma
                      : CameraPosition(
                          target: LatLng(
                              snapshot.data.latitude, snapshot.data.longitude),
                          zoom: 16,
                        ),
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _setMapstyle(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                )
              : Center();
        },
      ),
    );
  }
}
