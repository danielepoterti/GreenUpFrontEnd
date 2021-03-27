import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GeolocatorService {
  static Future<PermissionStatus> getPermission() async {
    //print('-----');
    //print(await Permission.locationAlways.request());
    return await Permission.location.request();
  }

  static Future<Position> getLocation() async {
    return getPermission().then((result) async {
      //print(Permission.locationAlways.request());
      if (result == PermissionStatus.granted) {
        //va gestita anche la parte iOS

        //Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
        //Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } else
        return null;
    });
  }
}
