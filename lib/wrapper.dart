import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'screens/searchbar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Wrapper extends StatefulWidget {
  AsyncSnapshot<dynamic> snapshot;
  Wrapper({@required this.snapshot});
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget _router() {
    if (_page == 0) {
      return (Stack(
        children: <Widget>[
          MapScreen(snapshot: widget.snapshot),
          Container(
              margin: EdgeInsets.all(20),
              child: Align(
                  alignment: FractionalOffset.topCenter, child: Search())),
        ],
      ));
    } else if (_page == 1) {
      return (Stack(
        children: <Widget>[
          MapScreen(snapshot: widget.snapshot),
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
          Container(
              margin: EdgeInsets.all(20),
              child: Align(
                  alignment: FractionalOffset.topCenter, child: Search())),
          Container(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              width: 200,
              height: 200,
            ),
          ),
        ],
      ));
    } else if (_page == 2) {
      return (Stack(
        children: <Widget>[
          MapScreen(snapshot: widget.snapshot),
          Container(
              margin: EdgeInsets.all(20),
              child: Align(
                  alignment: FractionalOffset.topCenter, child: Search())),
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      ));
    } else if (_page == 3) {
      return (Stack(
        children: <Widget>[
          MapScreen(snapshot: widget.snapshot),
          Container(
              margin: EdgeInsets.all(20),
              child: Align(
                  alignment: FractionalOffset.topCenter, child: Search())),
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      ));
    } else if (_page == 4) {
      return (Stack(
        children: <Widget>[
          MapScreen(snapshot: widget.snapshot),
          Container(
              margin: EdgeInsets.all(20),
              child: Align(
                  alignment: FractionalOffset.topCenter, child: Search())),
          Container(
            color: Colors.white.withOpacity(0.5),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 75.0,
          items: <Widget>[
            Icon(Icons.map, size: 30),
            Icon(Icons.schedule, size: 30),
            Icon(Icons.list, size: 30),
            Icon(
              Icons.credit_card,
              size: 30,
            ),
            Icon(Icons.person, size: 30),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            print(index);
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _router());
  }
}
