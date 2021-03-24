import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_up/providers/chargepoints_provider.dart';
import 'package:green_up/services/geolocator_service.dart';
import 'package:provider/provider.dart';
import 'screens/map_screen.dart';
import 'screens/searchbar.dart';
import 'wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // FutureProvider<List<Marker>>(
        //   create: (_) async => await ChargePoints().markers,
        //   initialData: [],
        // ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return ChargePoints();
          },
        )
      ],
      child: MaterialApp(
        title: 'GreenUp Demo',
        home: FutureBuilder(
          future: GeolocatorService.getLocation(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? Wrapper(snapshot: snapshot)
                : Center(); //schermata caricamento (#2)
          },
        ),
      ),
    );
  }
}
//MapScreen(snapshot: snapshot)