import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final String street;
  final String houseNumber;
  final String zipCode;
  final String city;
  final String country;

  Address({
    @required this.street,
    @required this.houseNumber,
    @required this.zipCode,
    @required this.city,
    @required this.country,
  });
}

enum Status {
  available,
  occupied,
  unavailable,
}

enum PlugType {
  type1,
  type2,
  type3,
  chademo,
}

enum PowerType {
  ac,
  dc,
}

class ChargePoint {
  final String id;           // chargeId
  final Address address;     // indirizzo
  final Status status;       // status (si suppone un solo plug)
  final PlugType plug;       // tipo plug
  final double maxPower;     // numero kW massimi
  final PowerType powerType; // AC o DC
  final double cost;         // costo a chilowatt
  final LatLng position;     // coordinate geografiche

  ChargePoint({
    @required this.id,
    @required this.address,
    @required this.status,
    @required this.plug,
    @required this.maxPower,
    @required this.powerType,
    @required this.cost,
    @required this.position,
  });
}
