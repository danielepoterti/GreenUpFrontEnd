import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:green_up/providers/chargepoints_provider.dart';
import 'package:green_up/services/geolocator_service.dart';
import 'package:green_up/services/map_helper.dart';
import 'package:green_up/services/map_marker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MapScreen extends StatefulWidget {
  AsyncSnapshot<dynamic> snapshot;
  MapScreen({@required this.snapshot});
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  //var to handle cluster updating
  //TODO: fix duplicated variables
  double previousZoom = 0;
  double currentZoomLevel = 0;
  GoogleMapController conti;

  List<double> box = [0, 0, 0, 0];

  bool isInit = true;

  /// Set of displayed markers and cluster markers on the map
  final Set<Marker> _markers = Set();

  /// Minimum zoom at which the markers will cluster
  final int _minClusterZoom = 0;

  /// Maximum zoom at which the markers will cluster
  final int _maxClusterZoom = 19;

  /// [Fluster] instance used to manage the clusters
  Fluster<MapMarker> _clusterManager;

  /// Current map zoom. Initial zoom will be 15, street level
  double _currentZoom = 15;

  /// Map loading flag
  bool _isMapLoading = true;

  /// Markers loading flag
  bool _areMarkersLoading = true;

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  /// Inits [Fluster] and all the markers with network images and updates the loading state.
  void _initMarkers() async {
    print('_initMarkers---------------------------');
    final List<MapMarker> markers = [];

    markers.addAll(data.markers);

    // for (LatLng markerLocation in _markerLocations) {
    //   final BitmapDescriptor markerImage =
    //       await MapHelper.getMarkerImageFromUrl(_markerImageUrl);

    //   markers.add(
    //     MapMarker(
    //       id: _markerLocations.indexOf(markerLocation).toString(),
    //       position: markerLocation,
    //       icon: markerImage,
    //     ),
    //   );
    // }

    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
    print('_initMarkers---------------------------');
  }

  Future<void> _updateZoomLevel([double updatedZoom]) async {
    LatLngBounds area = await conti.getVisibleRegion();
    box = [
      area.southwest.longitude,
      area.southwest.latitude,
      area.northeast.longitude,
      area.northeast.latitude
    ];
    currentZoomLevel = updatedZoom;
    // if (updatedZoom != currentZoomLevel) {
    //   previousZoom = currentZoomLevel;
    //   currentZoomLevel = updatedZoom;
    // }
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers() async {
    //if (currentZoomLevel != previousZoom) {
    if (_clusterManager == null) return;

    if (currentZoomLevel != null) {
      _currentZoom = currentZoomLevel;
    }

    setState(() {
      _areMarkersLoading = true;
    });
    print('here');
    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      currentZoomLevel,
      _clusterColor,
      _clusterTextColor,
      80,
      box,
    );
    print(updatedMarkers.length);
    _markers
      ..clear()
      ..addAll(updatedMarkers);

    setState(() {
      _areMarkersLoading = false;
    });
    //previousZoom = currentZoomLevel;
    //}
  }

  final GeolocatorService geo = GeolocatorService();
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kRoma = CameraPosition(
    target: LatLng(41.893056, 12.482778),
    zoom: 11,
  );

  String _style;

  void _setMapstyle(GoogleMapController controller) async {
    controller.setMapStyle(_style);
  }

  //List<Marker> markers = [];
  ChargePoints data;
  @override
  Future<void> didChangeDependencies() async {
    print('didChangeDependencies---------------------------');

    if (isInit) {
      data = Provider.of<ChargePoints>(context);
      _style = await DefaultAssetBundle.of(context)
          .loadString('./assets/map_style.json');
      await data.initIcons();
      await data.initChargers(context).then((_) => _initMarkers());
      //print(data.chargePoints);
      setState(() {
        isInit = !isInit;
      });
    }

    super.didChangeDependencies();
    print('didChangeDependencies---------------------------');
  }

  @override
  Widget build(BuildContext context) {
    //List<Marker> markers = Provider.of<List<Marker>>(context);

    var snapshot = widget.snapshot;

    //print(_markers);
    return new Scaffold(
      body: GoogleMap(
        initialCameraPosition: snapshot.hasData == false
            ? _kRoma
            : CameraPosition(
                target: LatLng(
                  snapshot.data.latitude,
                  snapshot.data.longitude,
                ),
                zoom: _currentZoom,
              ),
        markers: Set<Marker>.of(_markers),
        zoomControlsEnabled: false,
        onMapCreated: (GoogleMapController controller) {
          print('onMapCreated---------------------------');
          _setMapstyle(controller);
          conti = controller;
          try {
            _controller.complete(controller);
          } catch (e) {
            // print("map rebuilded");
            throw e;
          }

          setState(() {
            _isMapLoading = false;
          });

          print('onMapCreated---------------------------');
        },
        //onCameraMove only update zoom level
        onCameraMove: (position) => _updateZoomLevel(position.zoom),
        //onCameraIdle is fired when camera stop moving
        onCameraIdle: () => _updateMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        buildingsEnabled: false,
      ),
    );
  }
}
