import 'dart:async';
import 'package:fluster/fluster.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:green_up/providers/chargepoints_provider.dart';
import 'package:green_up/services/geolocator_service.dart';
import 'package:green_up/services/map_helper.dart';
import 'package:green_up/services/map_marker.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'searchbar.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  dynamic snapshot;
  MapScreen({@required this.snapshot}) {}
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controllerChargePointCard;
  Animation<Offset> _offsetAnimation;

  //TODO: fix duplicated variables
  double previousZoom = 0;
  double currentZoomLevel = 0;
  GoogleMapController conti;
  bool autocompleteVisible = false;
  List<Widget> autocomplete;

  List<double> box = [0, 0, 0, 0];

  bool isInit = true;
  bool isChargePointPressed = false;

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

  List<MapMarker> markerss = [];
  List<MapMarker> nearby = [];

  // initialize markers
  void _initMarkers() async {
    final List<MapMarker> markers = [];
    markers.addAll(data.markers);
    markerss.addAll(data.markers);
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
      handleMarkerClickCluster,
      handleMarkerClickMarker,
    );
    _markers
      ..clear()
      ..addAll(updatedMarkers);
    setState(() {
      //  _areMarkersLoading = false;
    });
  }

  void handleAutocompleteClick(element) {
    handleMarkerClickCluster(double.parse(element['coo']['long']),
        double.parse(element['coo']['lat']));
    setState(() {
      autocompleteVisible = false;
    });
  }

  List getAutocomplete(List list) {
    List<Widget> appoggio = [];
    list.forEach((element) {
      appoggio.add(SizedBox(
        height: 7,
      ));
      appoggio.add(InkWell(
          onTap: () => {handleAutocompleteClick(element)},
          child: Container(
            height: 40,
            width: 500,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Center(child: Text(element['name'])),
          )));
    });
    setState(() {
      autocompleteVisible = true;
      autocomplete = appoggio;
    });
  }

  Widget _autocomplete() {
    if (autocompleteVisible) {
      return (Container(
          width: 300,
          child: MediaQuery.removePadding(
              removeBottom: true,
              context: context,
              child: ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: autocomplete,
              ))));
    } else {
      return Container();
    }
  }

  //callback that handle markers tap anz zoom on tapped marker
  void handleMarkerClickCluster(double long, double lat) async {
    // print('MARKER PRESSED');
    // setState(() {
    //   isChargePointPressed = true;
    // });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(lat, long),
          zoom: 13.0,
        ),
      ),
    );
  }

  void handleMarkerClickMarker(double long, double lat) async {
    nearby.clear();
    for (var i = 0; i < markerss.length; i++) {
      if (getDistanceFromLatLonInKm(
              lat, long, markerss[i].latitude, markerss[i].longitude) <
          1.0) {
        nearby.add(markerss[i]);
      }
    }
    final GoogleMapController controller = await _controller.future;
    await controller
        .animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              bearing: 0,
              target: LatLng(lat, long),
              zoom: 17.0,
            ),
          ),
        )
        .then((value) => setState(() {
              isChargePointPressed = true;
            }));
    _controllerChargePointCard.forward();
    print('MARKER PRESSED');
  }

  //calculate distance between two coordinates
  double getDistanceFromLatLonInKm(
      double lat1, double lon1, double lat2, double lon2) {
    double R = 6371.0; // Radius of the earth in km
    double dLat = deg2rad(lat2 - lat1); // deg2rad below
    double dLon = deg2rad(lon2 - lon1);
    var a = sin(dLat / 2) * sin(dLat / 2) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double d = R * c; // Distance in km
    return d;
  }

  double deg2rad(double deg) {
    return deg * (pi / 180.0);
  }

  //zoom on user current position
  void _currentLocation() async {
//     new_latitude  = latitude  + (dy / r_earth) * (180 / pi);
// new_longitude = longitude + (dx / r_earth) * (180 / pi) / cos(latitude * pi/180);
    // double newLatitude =
    //     widget.snapshot.latitude + (10.0 / 6378.0) * (180.0 / pi);
    //print(newLatitude);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(widget.snapshot.latitude, widget.snapshot.longitude),
        zoom: 17.0,
      ),
    ));
  }

  void handlePrefix() {
    setState(() {
      autocompleteVisible = false;
    });
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

  @override
  void initState() {
    _controllerChargePointCard = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controllerChargePointCard,
        curve: Curves.elasticInOut,
      ),
    );
    super.initState();
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
  void dispose() {
    super.dispose();
    _controllerChargePointCard.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var snapshot = widget.snapshot;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: GoogleMap(
            padding: EdgeInsets.only(bottom: 85),
            initialCameraPosition: snapshot == null
                ? _kRoma
                : CameraPosition(
                    target: LatLng(
                      snapshot.latitude,
                      snapshot.longitude,
                    ),
                    zoom: _currentZoom,
                  ),
            markers: Set<Marker>.of(_markers),
            zoomControlsEnabled: false,
            onCameraMoveStarted: () {
              if (isChargePointPressed)
                setState(() {
                  isChargePointPressed = false;
                });
              _controllerChargePointCard.reverse();
            },
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
          floatingActionButton: snapshot != null
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
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Search(
                        callback: getAutocomplete,
                        prefixTap: handlePrefix,
                        width: MediaQuery.of(context).size.width - 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _autocomplete(),
              ],
            ),

            //children: autocomplete,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 180),
                    child: Container(
                      child: Row(
                        children: [
                          SlideTransition(
                            position: _offsetAnimation,
                            child: SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ScrollSnapList(
                                  initialIndex: 0,
                                  itemCount: nearby.length,
                                  itemBuilder: itemBuilder,
                                  itemSize:
                                      (MediaQuery.of(context).size.width - 40) +
                                          10,
                                  onItemFocus: (index) => print(index)),
                            ),
                            //     Card(
                            //   shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.all(
                            //       Radius.circular(13),
                            //     ),
                            //   ),
                            //   elevation: 5,
                            //   child: SizedBox(
                            //     child: InkWell(
                            //       onTap: () {
                            //         // setState(() {
                            //         //   isChargePointPressed = false;
                            //         // });
                            //       },
                            //     ),
                            //     width: 300,
                            //     height: 100 +
                            //         MediaQuery.of(context).size.height /
                            //             100 *
                            //             8,
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Card(
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(13),
        ),
      ),
      elevation: 5,
      child: SizedBox(
        child: Stack(children: [
          Positioned(
            bottom: 20,
            right: 20,
            child: ClipOval(
              child: Material(
                color: const Color(0xff44a688), // button color
                child: InkWell(
                  //splashColor: Colors.red, // inkwell color
                  child: SizedBox(
                    width: 56,
                    height: 56,
                    child: Icon(
                      Icons.directions_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ),
          Positioned(
            //left: 5,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text(
                    "VIA PIRELLI GIOVANNI BATTISTA 35-via Bordoni Antonio",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          )
        ]),
        width: (MediaQuery.of(context).size.width - 40),
        height: 300,
      ),
    );
  }
}
