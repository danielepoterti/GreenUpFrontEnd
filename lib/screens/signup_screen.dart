import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  final FlutterSecureStorage storage;
  final Function getLogin;
  SignUp(this.storage, this.getLogin);
  @override
  _SignUp createState() => _SignUp(storage, getLogin);
}

class _SignUp extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final Function getLogin;

  final FlutterSecureStorage storage;

  //constructor
  _SignUp(this.storage, this.getLogin);

  void register() async {
    bool isGood = true;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      isGood = false;
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      isGood = false;
      print(e);
    }
    //succesfully registered
    if (isGood) {
      String data =
          '{\"mail\": \"${emailController.text}\", \"psw\": \"${passwordController.text}\"}';
      await storage.write(key: 'login', value: data);
      this.getLogin(data);
    }
  }

  // void google() async {
  //   print(await signInWithGoogle());
  // }

  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;

  //   // Create a new credential
  //   final GoogleAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          title: Text('SignUp'),
          backgroundColor: const Color(0xff44a688),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xff44a688),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Image.asset(
                    'assets/images/github.png',
                    width: 150,
                    height: 150,
                  ),
                  Container(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 600,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      hintText: 'Email'),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25))),
                                      hintText: 'Password'),
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                              (states) =>
                                                  const Color(0xff44a688)),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18)))),
                                  onPressed: register,
                                  child: Text('SingUp')),
                              SizedBox(
                                height: 10,
                              ),
                              //ElevatedButton(onPressed: google, child: Text('Google')),
                            ],
                          ),
                        )),
                  )
                ],
              ),
            )));
  }
}
