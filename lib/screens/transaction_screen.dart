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
  GifController controller;
  
  @override
  void initState() {
    super.initState();
    
    controller = GifController(vsync: this);
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
     
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          GifImage(
            controller: controller,
            image: MapHelper.chargingGif,
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
