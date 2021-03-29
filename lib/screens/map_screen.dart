import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:green_up/providers/chargepoints_provider.dart';
import 'package:green_up/services/geolocator_service.dart';
import 'package:green_up/services/map_helper.dart';
import 'package:green_up/services/map_marker.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  AsyncSnapshot<dynamic> snapshot;
  MapScreen({@required this.snapshot, Key key}) : super(key: key);
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
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
  //bool _isMapLoading = true;

  /// Markers loading flag
  //bool _areMarkersLoading = true;

  /// Color of the cluster circle
  final Color _clusterColor = Colors.blue;

  /// Color of the cluster text
  final Color _clusterTextColor = Colors.white;

  // initialize markers
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    markers.addAll(data.markers);
    _clusterManager = await MapHelper.initClusterManager(
      markers,
      _minClusterZoom,
      _maxClusterZoom,
    );

    await _updateMarkers();
  }

  // update current zoom level
  Future<void> _updateZoomLevel([double updatedZoom]) async {
    LatLngBounds area = await conti.getVisibleRegion();
    box = [
      area.southwest.longitude,
      area.southwest.latitude,
      area.northeast.longitude,
      area.northeast.latitude
    ];
    currentZoomLevel = updatedZoom;
  }

  /// Gets the markers and clusters to be displayed on the map for the current zoom level and
  /// updates state.
  Future<void> _updateMarkers() async {
    if (_clusterManager == null) return;

    if (currentZoomLevel != null) {
      _currentZoom = currentZoomLevel;
    }
    setState(() {
    //  _areMarkersLoading = true;
    });
    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      currentZoomLevel,
      _clusterColor,
      _clusterTextColor,
      80,
      box,
      handleMarkerClick,
    );
    _markers
      ..clear()
      ..addAll(updatedMarkers);
    setState(() {
    //  _areMarkersLoading = false;
    });
  }

  //callback that handle markers tap anz zoom on tapped marker
  void handleMarkerClick(double long, double lat) async {
    print(lat);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, long),
        zoom: 10.0,
      ),
    ));
  }

  //zoom on user current position
  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(
            widget.snapshot.data.latitude, widget.snapshot.data.longitude),
        zoom: 17.0,
      ),
    ));
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

  ChargePoints data;
  @override
  Future<void> didChangeDependencies() async {
    if (isInit) {
      data = Provider.of<ChargePoints>(context);
      _style = await DefaultAssetBundle.of(context)
          .loadString('./assets/map_style.json');
      await data.initIcons();
      await data.initChargers(context).then((_) => _initMarkers());
      setState(() {
        isInit = !isInit;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = widget.snapshot;
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      body: GoogleMap(
        padding: EdgeInsets.only(bottom: 85),
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
          _setMapstyle(controller);
          conti = controller;
          try {
            _controller.complete(controller);
          } catch (e) {
            throw e;
          }
          setState(() {
          //  _isMapLoading = false;
          });
        },
        onCameraMove: (position) => _updateZoomLevel(position.zoom),
        onCameraIdle: () => _updateMarkers(),
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
        compassEnabled: false,
        buildingsEnabled: false,
      ),
      floatingActionButton: snapshot.hasData == true
          ? Padding(
              padding: const EdgeInsets.only(bottom: 90.0),
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                onPressed: _currentLocation,
                child: Icon(
                  Icons.location_searching_sharp,
                  color: Colors.black,
                ),
              ),
            )
          : null,
    );
  }
}
