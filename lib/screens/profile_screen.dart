import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //physics: PageScrollPhysics(),
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              Container(
                color: const Color(0xff44a688),
                height: MediaQuery.of(context).size.height +
                    2000000000000, //L'altezza del container deve essere maggiore di quella dello schermo
              ),
              Positioned(
                top: 200,
                child: Container(
                  height: 800,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                ),
              ),
              Positioned(
                  top: 125,
                  left: (MediaQuery.of(context).size.width / 2) - 75,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  )),
              Positioned(
                  top: 130,
                  left: (MediaQuery.of(context).size.width / 2) - 70,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/skri.jpg',
                      width: 140,
                      height: 140,
                    ),
                  )),
              Positioned(
                top: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'INFORMAZIONI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(children: [
                        Icon(
                          Icons.person_rounded,
                          size: 20,
                        ),
                        Text('Michele Banfi', style: TextStyle(fontSize: 20))
                      ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.call,
                            size: 20,
                          ),
                          Text(
                            '3388306095',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.email,
                              size: 20,
                            ),
                            Text(
                              'michi.banfi01@gmail.com',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'MACCHINE',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              size: 20,
                            ),
                            Text(
                              '<PICKER>',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'DATI PERSONALI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 20,
                            ),
                            Text(
                              'Modifica i dati personali',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 20,
                            ),
                            Text(
                              'Modifica i dati di fatturazione',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'DATI PERSONALI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'DATI PERSONALI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'DATI PERSONALI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'DATI PERSONALI',
                        style: TextStyle(
                            color: const Color(0xff44a688),
                            fontSize: 25,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
