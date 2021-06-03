import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_up/models/chargepoint_model.dart';
import 'package:green_up/services/map_marker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;

class ChargePoints with ChangeNotifier {
  BitmapDescriptor _iconAvailable;
  BitmapDescriptor _iconOccupied;
  BitmapDescriptor _iconUnavailable;
  BitmapDescriptor _iconPromo1;
  BitmapDescriptor _iconPromo2;
  BitmapDescriptor _iconPromo3;
  BitmapDescriptor _iconPromo4;
  BitmapDescriptor _iconPromo5;
  BitmapDescriptor _iconPromo6;
  BitmapDescriptor _iconPromo7;
  BitmapDescriptor _iconPromo8;

  List<ChargePoint> _chargePoints = [];

  List<ChargePoint> get chargePoints {
    return [..._chargePoints];
  }

  ChargePoint chargePointfromMapMarker(MapMarker marker) {
    return _chargePoints.where((element) => element.id == marker.id).first;
  }

  Future<BitmapDescriptor> _setMarkerIcon(Status status) async {
    //apparentemente se si usano i byte le dimensioni non si buggano su iOS, tengo cosi per sicurezza
    //int width = Platform.isAndroid ? 128 : 128;
    String path;
    switch (status) {
      case Status.available:
        path = 'assets/images/chargingAvailable128px.png';
        break;
      case Status.unavailable:
        path = 'assets/images/chargingUnavailable.png';
        break;
      case Status.occupied:
        path = 'assets/images/chargingOccupied.png';
        break;
      case Status.promo1:
        path = 'assets/images/promo_1.png';
        break;
      case Status.promo2:
        path = 'assets/images/promo_2.png';
        break;
      case Status.promo3:
        path = 'assets/images/promo_3.png';
        break;
      case Status.promo4:
        path = 'assets/images/promo_4.png';
        break;
      case Status.promo5:
        path = 'assets/images/promo_5.png';
        break;
      case Status.promo6:
        path = 'assets/images/promo_6.png';
        break;
      case Status.promo7:
        path = 'assets/images/promo_7.png';
        break;
      case Status.promo8:
        path = 'assets/images/promo_8.png';
        break;
    }

    Uint8List byte = await getBytesFromAsset(path, 100);
    return BitmapDescriptor.fromBytes(byte);
  }

  initChargers(BuildContext context) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('getChargingStations');
    final results = await callable();

    final Map resultsMap = json.decode(results.data);

    final List<ChargePoint> loadedChargers = [];

    resultsMap.forEach((key, element) {
      print(element["id"]);
      print(element["longitudine"]);

      return element["longitudine"] == null
          ? null
          : loadedChargers.add(
              ChargePoint(
                owner: element["titolare"].toString(),
                id: element["id"].toString(),
                address: Address(
                  city: element["citta"],
                  street: element["via"],
                ),
                //TODO: check status
                status: Status.available,
                plug: null,
                maxPower: null,
                powerType: element["tipo_ricar"].toString(),
                cost: null,
                position: LatLng(
                  double.parse(element["latitudine"]),
                  double.parse(element["longitudine"]),
                ),
                promo: false,
              ),
            );
    });
    loadedChargers.addAll([
      ChargePoint(
          id: "promo_1",
          address: Address(
              street: "Via Marsala - Il Viaggiator Goloso",
              houseNumber: "41/43",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo1,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.57537130526114, 9.26076281392811),
          owner: "EnelX",
          promo: true),
      ChargePoint(
          id: "promo_2",
          address: Address(
              street: "Via Firenze - Parcheggio",
              houseNumber: "1A",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo2,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.5839656849784, 9.273752830181062),
          owner: "EnelX",
          promo: true),
      ChargePoint(
          id: "promo_3",
          address: Address(
              street: "Via Monte S. Primo - Adidas Outlet",
              houseNumber: "3",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo3,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.59250327918994, 9.244396606525985),
          owner: "Adidas",
          promo: true),
      ChargePoint(
          id: "promo_4",
          address: Address(
              street: "Via Gian Battista Stucchi - Eurospin",
              houseNumber: "3",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo4,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.57566699372238, 9.308869923313619),
          owner: "Eurospin",
          promo: true),
      ChargePoint(
          id: "promo_5",
          address: Address(
              street: "Via Marsala - Coop",
              houseNumber: "24",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo5,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.576434129708986, 9.265031315588587),
          owner: "EnerCoop",
          promo: true),
      ChargePoint(
          id: "promo_6",
          address: Address(
              street: "Via Gerolamo Borgazzi - Penny Market",
              houseNumber: "60",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo6,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.56851593554008, 9.262994307245346),
          owner: "Penny Market",
          promo: true),
      ChargePoint(
          id: "promo_7",
          address: Address(
              street: "Via Trieste - Lidl",
              houseNumber: "60",
              zipCode: "20851",
              city: "Lissone",
              country: "Italia"),
          status: Status.promo7,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.60250166577997, 9.248932848026094),
          owner: "Lidl",
          promo: true),
      ChargePoint(
          id: "promo_7_1",
          address: Address(
              street: "Via Fratelli Bandiera - Lidl",
              houseNumber: "60",
              zipCode: "20835",
              city: "Muggiò",
              country: "Italia"),
          status: Status.promo7,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.574042597075625, 9.226413462448324),
          owner: "Lidl",
          promo: true),
      ChargePoint(
          id: "promo_8",
          address: Address(
              street: "Via della Guerrina - Iper",
              houseNumber: "108",
              zipCode: "20900",
              city: "Monza",
              country: "Italia"),
          status: Status.promo8,
          plug: PlugType.type2,
          maxPower: PowerSupply.kW22,
          powerType: "DC",
          cost: 0,
          position: LatLng(45.5863325273801, 9.312305128571909),
          owner: "Iper",
          promo: true),
    ]);
    _chargePoints = loadedChargers;
    notifyListeners();
  }

  initIcons() async {
    _iconAvailable = (await _setMarkerIcon(Status.available));
    _iconOccupied = await _setMarkerIcon(Status.occupied);
    _iconUnavailable = await _setMarkerIcon(Status.unavailable);
    _iconPromo1 = await _setMarkerIcon(Status.promo1);
    _iconPromo2 = await _setMarkerIcon(Status.promo2);
    _iconPromo3 = await _setMarkerIcon(Status.promo3);
    _iconPromo4 = await _setMarkerIcon(Status.promo4);
    _iconPromo5 = await _setMarkerIcon(Status.promo5);
    _iconPromo6 = await _setMarkerIcon(Status.promo6);
    _iconPromo7 = await _setMarkerIcon(Status.promo7);
    _iconPromo8 = await _setMarkerIcon(Status.promo8);
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
                      : element.status == Status.promo1
                          ? _iconPromo1
                          : element.status == Status.promo2
                              ? _iconPromo2
                              : element.status == Status.promo3
                                  ? _iconPromo3
                                  : element.status == Status.promo4
                                      ? _iconPromo4
                                      : element.status == Status.promo5
                                          ? _iconPromo5
                                          : element.status == Status.promo6
                                              ? _iconPromo6
                                              : element.status == Status.promo7
                                                  ? _iconPromo7
                                                  : element.status ==
                                                          Status.promo8
                                                      ? _iconPromo8
                                                      : BitmapDescriptor
                                                          .defaultMarker,
        ),
      );
    });

    return [...chargeMarkers];
  }

  List<MapMarker> get markersAC {
    List<MapMarker> chargeMarkers = [];

    _chargePoints.forEach((element) {
      if (element.powerType.contains("AC")) {
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
      }
    });

    return [...chargeMarkers];
  }

  List<MapMarker> get markersDC {
    List<MapMarker> chargeMarkers = [];

    _chargePoints.forEach((element) {
      if (element.powerType.contains("DC")) {
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
      }
    });

    return [...chargeMarkers];
  }

  ChargePoint findById(String id) {
    return _chargePoints.firstWhere((element) => element.id == id);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }
}
