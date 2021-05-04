import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          Container(
            color: const Color(0xff44a688),
            height: MediaQuery.of(context).size.height,
          ),
          Positioned(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: MediaQuery.of(context).size.height - 200,
            ),
          )),
          Positioned(
            top: 125,
            left: (MediaQuery.of(context).size.width / 2) - 75,
            child: Image.asset(
              'assets/images/github.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
