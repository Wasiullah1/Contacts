import 'dart:async';

import 'package:contacts/Models/currentappuser.dart';
import 'package:contacts/Screens/home.dart';
import 'package:contacts/Screens/homescreen.dart';
import 'package:contacts/Screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      CurrentAppUser.currentUserData.getCurrentUserData(user.uid);
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginScreen())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              // child: SvgPicture.asset(
              //   'assets/logo-keep.svg',
              // ),
              ),
        ],
      ),
    );
  }
}
