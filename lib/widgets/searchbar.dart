import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:green_up/services/map_helper.dart';
import '../services/anim_search_widget.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  LatLng location;
  double width;
  String query = '';
  Function callback;
  Function prefixTap;
  Function suffixTap;
  Search({this.callback, this.prefixTap, this.width, this.location});
  @override
  _SearchState createState() => _SearchState(callback, prefixTap);
}

class _SearchState extends State<Search> {
  Function callback;
  Function prefixTap;
  _SearchState(this.callback, this.prefixTap);
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textController.addListener(handleTextChanges);
  }

  List getBbox(int km) {
    //calcolo molto approssimativo quindi stiamo stretti con i km
    double R = 6371.0;
    double lat = widget.location.latitude;
    double long = widget.location.longitude;
    double newLat = lat + (km / R) * (180 / pi);
    double newLong = long + (km / R) * (180 / pi) / cos(lat * pi / 180);
    return [newLat, newLong];
  }

  // callback fired every time input change
  void handleTextChanges() async {
    List ne = getBbox(200);
    List sw = getBbox(-200);
    if (textController.text.length > 2) {
      final url = Uri.parse(
          'https://photon.komoot.io/api/?q=${textController.text}&limit=5&bbox=${sw[1]},${sw[0]},${ne[1]},${ne[0]}');
      final response = await http.get(url);
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["features"];
      this.callback(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: AnimSearchBar(
          key: MapHelper.keyAnimationSearch,
          width: widget.width,
          textController: textController,
          suffixIcon: Icon(Icons.search),
          autoFocus: true,
          onPrefixTap: () => {
            setState(() {
              textController.clear();
            }),
            this.prefixTap()
          },
          onSuffixTap: () {
            setState(() {
              textController.clear();
            });
          },
        ));
  }
}
