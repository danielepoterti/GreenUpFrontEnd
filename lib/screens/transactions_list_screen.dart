import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: SafeArea(
            child: AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 44.0,
                      child: FadeInAnimation(
                        child: EmptyCard(
                          width: MediaQuery.of(context).size.width,
                          height: 88.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Stack(children: [
          Container(
            //color: Colors.blue,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),

            height: 131,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              "Ricariche effetuate:",
              style:
                  GoogleFonts.roboto(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          )
        ]),
      ]),
    );
  }
}

class EmptyCard extends StatelessWidget {
  final double width;
  final double height;

  const EmptyCard({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0.0, 4.0),
          ),
        ],
      ),
    );
  }
}

class AutoRefresh extends StatefulWidget {
  final Duration duration;
  final Widget child;

  AutoRefresh({
    Key key,
    @required this.duration,
    @required this.child,
  }) : super(key: key);

  @override
  _AutoRefreshState createState() => _AutoRefreshState();
}

class _AutoRefreshState extends State<AutoRefresh> {
  int keyValue;
  ValueKey key;

  Timer _timer;

  @override
  void initState() {
    super.initState();

    keyValue = 0;
    key = ValueKey(keyValue);

    _recursiveBuild();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: widget.child,
    );
  }

  void _recursiveBuild() {
    _timer = Timer(
      widget.duration,
      () {
        setState(() {
          keyValue = keyValue + 1;
          key = ValueKey(keyValue);
          _recursiveBuild();
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
