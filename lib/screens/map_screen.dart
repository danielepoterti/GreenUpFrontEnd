import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:green_up/services/geolocator_service.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  final GeolocatorService geo = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kRoma = CameraPosition(
    target: LatLng(41.893056, 12.482778),
    zoom: 11,
  );

  void _setMapstyle(GoogleMapController controller) async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('./assets/map_style.json');
    controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = Provider.of<List<Marker>>(context);

    print(markers);
    return new Scaffold(
      body: FutureBuilder(
        future: geo.getLocation(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? GoogleMap(
                  initialCameraPosition: snapshot.hasData == false
                      ? _kRoma
                      : CameraPosition(
                          target: LatLng(
                            snapshot.data.latitude,
                            snapshot.data.longitude,
                          ),
                          zoom: 16,
                        ),
                  markers: Set<Marker>.of(markers),
                  zoomControlsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    _setMapstyle(controller);
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  buildingsEnabled: false,
                )
              : Center(); // issue (#2)
        },
      ),
    );
  }
}
