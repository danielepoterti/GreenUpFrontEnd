import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class CircularButton extends StatefulWidget {
  final double progress;

  const CircularButton({Key key, this.progress}) : super(key: key);
  @override
  _CircularButtonState createState() => _CircularButtonState();
}

class _CircularButtonState extends State<CircularButton> {
  var iconSize = 56.0;
  IconData _icon = Icons.flash_on;
  bool _isDone = false;
  double _height = 0.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = lerpDouble(iconSize, 0, widget.progress);

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(8),
        height: 112,
        width: 112,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: const Color(0xff44a688)),
        child: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 112,
              child: CircularProgressIndicator(
                value: widget.progress,
                strokeWidth: 16,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 22.4),
              width: 112,
              height: 56,
              alignment: Alignment.center,
              child: Icon(
                _isDone ? Icons.check_circle : getIcon,
                size: iconSize,
                color: Colors.blue,
              ),
            ),
            AnimatedContainer(
              margin: EdgeInsets.symmetric(vertical: 22.4),
              alignment: Alignment.center,
              duration: Duration(milliseconds: 200),
              height: _height,
              width: 112,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Icon(Icons.flash_on,
                    size: iconSize, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get getIcon {
    setState(() {
      if (_height == 28) {
        print("_height");
      }
      if (_height == 0) {
        _icon = Icons.check_circle;
        _isDone = true;
      }
    });
    return _icon;
  }
}

class CirclerProgressPainter extends CustomPainter {
  double progress;
  CirclerProgressPainter({this.progress});
  @override
  void paint(Canvas canvas, Size size) {
    print(-math.pi / 2);
    print(2 * math.pi);

    canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.height / 2, size.width / 2),
            height: size.height,
            width: size.width),
        -math.pi / 2,
        2 * math.pi / (progress / 2 * math.pi),
        true,
        Paint()..color = Colors.red);
  }

  @override
  bool shouldRepaint(CirclerProgressPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CirclerProgressPainter oldDelegate) => false;
}