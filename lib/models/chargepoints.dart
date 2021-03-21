import 'package:green_up/models/chargepoint.dart';

class ChargePoints {
  List<ChargePoint> _chargePoints = [];

  List<ChargePoint> get chargePoints {
    return [..._chargePoints];
  }

  ChargePoint findById(String id) {
    return _chargePoints.firstWhere((element) => element.id == id);
  }
}
