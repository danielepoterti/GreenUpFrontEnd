import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  String query = '';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
