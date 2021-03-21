

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_up/models/chargepoint_model.dart';

class ChargePoints with ChangeNotifier {
  List<ChargePoint> _chargePoints = [
    ChargePoint(
      id: 'cp01',
      address: Address(
        city: 'Nova Milanese',
        country: 'Italia',
        houseNumber: '18',
        street: 'Via Sarajevo',
        zipCode: '20834',
      ),
      status: Status.available,
      plug: PlugType.type2,
      maxPower: PowerSupply.kW22,
      powerType: PowerType.ac,
      cost: 0,
      position: const LatLng(45.594100, 9.192028),
    ),
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

  Future<List<Marker>> get markers async {
    
    BitmapDescriptor iconAvailable = await _setMarkerIcon(Status.available);
    BitmapDescriptor iconOccupied = await _setMarkerIcon(Status.occupied);
    BitmapDescriptor iconUnavailable = await _setMarkerIcon(Status.unavailable);
    List<Marker> chargeMarkers = [];
    _chargePoints.forEach((element) {
      chargeMarkers.add(
        Marker(
          markerId: MarkerId(element.id),
          position: element.position,
          icon: element.status == Status.available
              ? iconAvailable
              : element.status == Status.unavailable
                  ? iconUnavailable
                  : element.status == Status.occupied
                      ? iconOccupied
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
