import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocatorService {
  Future<PermissionStatus> getPermission() async {
    return await Permission.location.request();
  }

  Future<Position> getLocation() async {
    return getPermission().then((result) async {
      if (result == PermissionStatus.granted) {
        //va gestita anche la parte iOS
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else
        return null;
    });
  }
}
