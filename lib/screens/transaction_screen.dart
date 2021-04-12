import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_up/services/map_helper.dart';

class Transaction extends StatefulWidget {
  @override
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction>
    with SingleTickerProviderStateMixin {
  GifController controllerGif;

  @override
  void initState() {
    controllerGif = GifController(vsync: this);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controllerGif.repeat(min:0, max: 185,  period: Duration(seconds: 4));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SizedBox(
            child: GifImage(
              controller: controllerGif,
              image: MapHelper.chargingGif,
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    MapHelper.selectedForTransaction.address.street,
                    style: GoogleFonts.roboto(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
