import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_up/models/chargepoint_model.dart';
import 'package:green_up/services/map_marker.dart';

class ChargePoints with ChangeNotifier {
  BitmapDescriptor _iconAvailable;
  BitmapDescriptor _iconOccupied;
  BitmapDescriptor _iconUnavailable;

  List<ChargePoint> _chargePoints = [
    // ChargePoint(
    //   id: 'cp01',
    //   address: Address(
    //     city: 'Nova Milanese',
    //     country: 'Italia',
    //     houseNumber: '18',
    //     street: 'Via Sarajevo',
    //     zipCode: '20834',
    //   ),
    //   status: Status.available,
    //   plug: PlugType.type2,
    //   maxPower: PowerSupply.kW22,
    //   powerType: PowerType.ac,
    //   cost: 0,
    //   position: const LatLng(45.594100, 9.192028),
    // ),
    // ChargePoint(
    //   id: 'cp02',
    //   address: Address(
    //     city: 'Nova Milanese',
    //     country: 'Italia',
    //     houseNumber: '18',
    //     street: 'Via Sarajevo',
    //     zipCode: '20834',
    //   ),
    //   status: Status.available,
    //   plug: PlugType.type2,
    //   maxPower: PowerSupply.kW22,
    //   powerType: PowerType.ac,
    //   cost: 0,
    //   position: const LatLng(45.59348806009438, 9.191465264449239),
    // ),
  ];

  List<ChargePoint> get chargePoints {
    return [..._chargePoints];
  }

  Future<BitmapDescriptor> _setMarkerIcon(Status status) async {
    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        status == Status.available
            ? 'assets/images/chargingAvailable128px.png'
            : status == Status.unavailable
                ? 'assets/images/chargingAvailable.png'
                : status == Status.occupied
                    ? 'assets/images/chargingAvailable.png'
                    : '');
  }

  initChargers(BuildContext context) async {
    final url = Uri.https(
      'michelebanfi.github.io',
      'data/data.geojson',
    );

    // final json =
    //     await DefaultAssetBundle.of(context).loadString("assets/data.json");
    // Map positionMap = jsonDecode(json);

    try {
      final response = await http.get(url);
      final positionMap = json.decode(response.body);
      final List<ChargePoint> loadedChargers = [];

      positionMap['features'].forEach((element) {
        return loadedChargers.add(
          ChargePoint(
            id: element['properties']['id'].toString(),
            address: null,
            status: Status.available,
            plug: null,
            maxPower: null,
            powerType: null,
            cost: null,
            position: LatLng(element['geometry']['coordinates'][0][1],
                element['geometry']['coordinates'][0][0]),
          ),
        );
      });
      _chargePoints = loadedChargers;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  initIcons() async {
    _iconAvailable = await _setMarkerIcon(Status.available);
    _iconOccupied = await _setMarkerIcon(Status.occupied);
    _iconUnavailable = await _setMarkerIcon(Status.unavailable);
  }

  List<MapMarker> get markers {
    List<MapMarker> chargeMarkers = [];

    _chargePoints.forEach((element) {
      chargeMarkers.add(
        MapMarker(
          
          id: element.id,
          position: element.position,
          icon: element.status == Status.available
              ? _iconAvailable
              : element.status == Status.unavailable
                  ? _iconUnavailable
                  : element.status == Status.occupied
                      ? _iconOccupied
                      : BitmapDescriptor.defaultMarker,
        ),
      );
    });

    return [...chargeMarkers];
  }

  ChargePoint findById(String id) {
    return _chargePoints.firstWhere((element) => element.id == id);
  }
}
