import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final String street;
  final String houseNumber;
  final String zipCode;
  final String city;
  final String country;

  Address({
    this.street,
    this.houseNumber,
    this.zipCode,
    this.city,
    this.country,
  });
}

enum Status {
  available,
  occupied,
  unavailable,
  promo1,
  promo2,
  promo3,
  promo4,
  promo5,
  promo6,
  promo7,
  promo8
}

enum PlugType {
  type1,
  chademo,
  ccsCombo2,
  type2,
  type3A,
  type2S,
}

// enum PowerType {
//   ac,
//   dc,
// }

enum PowerSupply {
  kW7,
  kW22,
  kW50,
}

class ChargePoint {
  final String id; // chargeId
  final Address address; // indirizzo
  final Status status; // status (si suppone un solo plug)
  final PlugType plug; // tipo plug
  final PowerSupply maxPower; // numero kW massimi
  // final PowerType powerType; // AC o DC
  final String powerType;
  final double cost; // costo a chilowatt
  final LatLng position;
  final String owner; // coordinate geografiche
  final bool promo;

  ChargePoint({
    @required this.id,
    @required this.address,
    @required this.status,
    @required this.plug,
    @required this.maxPower,
    @required this.powerType,
    @required this.cost,
    @required this.position,
    @required this.owner,
    @required this.promo
  });
}
