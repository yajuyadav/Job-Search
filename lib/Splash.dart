import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:searchjob/employee/employeeDashboard.dart';
import 'package:searchjob/employer/employerDashboard.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String role = 'employee';
  @override
  void initState() {
    super.initState();
    _checkRole();
  }
  void _checkRole() async {
    User? user= FirebaseAuth.instance.currentUser;
    var snap= await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    setState(() {
      role = snap['role'];

    });
    if(role == 'employee'){
      navigateNext(employeeDashboard());
    } else if(role == 'employer'){
      navigateNext(employerDashboard());
    }
  }

  void navigateNext(Widget route) {
    Timer(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[300],
      body: Center(
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text('Welcome!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.white38),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return loginscreen();
  }
}
