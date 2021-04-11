import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoadingButton extends StatefulWidget {
  @override
  LoadingButtonState createState() => LoadingButtonState();
}

class LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) {
        if (controller.status == AnimationStatus.forward) {
          controller.reverse();
          print('press not finished');
          return Fluttertoast.showToast(
              msg: "Tieni premuto per iniziare la ricarica",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              /*timeInSecForIosWeb: 1*/);
        }
      },
      /*onTap: () => {print('tap')},*/
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            height: 56,
            width: 56,
            child: CircularProgressIndicator(
              value: 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
            ),
          ),
          SizedBox(
            height: 56,
            width: 56,
            child: CircularProgressIndicator(
              value: controller.value,
              valueColor:
                  AlwaysStoppedAnimation<Color>(const Color(0xff44a688)),
            ),
          ),
          Icon(
            Icons.flash_on,
            size: 36,
          )
        ],
      ),
    );
  }
}
