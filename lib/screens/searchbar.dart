import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String query = '';
  Function callback;
  Search(this.callback);
  @override
  _SearchState createState() => _SearchState(callback);
}

class _SearchState extends State<Search> {
  Function callback;
  _SearchState(this.callback);
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    textController.addListener(handleTextChanges);
  }

  // callback fired every time input change
  void handleTextChanges() async {
    final url = Uri.https(
      'michelebanfi.github.io',
      'data/place.json',
    );
    final response = await http.get(url);
    Map<String, dynamic> map = json.decode(response.body);
    List<dynamic> data = map["data"];
    this.callback(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 30),
        child: AnimSearchBar(
          width: 400,
          textController: textController,
          suffixIcon: Icon(Icons.search),
          onSuffixTap: () {
            setState(() {
              textController.clear();
            });
          },
        ));
  }
}
