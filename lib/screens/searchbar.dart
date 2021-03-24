import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController textController = TextEditingController();
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
