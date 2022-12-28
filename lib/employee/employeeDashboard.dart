import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:searchjob/employee/applications.dart';
import 'package:searchjob/employee/employeeProfile.dart';
import 'package:searchjob/employee/employeehome.dart';
import 'package:searchjob/employee/latestJobs.dart';
import 'package:searchjob/messages.dart';
class employeeDashboard extends StatefulWidget {
  @override
  _employeeDashboardState createState() => _employeeDashboardState();
}

class _employeeDashboardState extends State<employeeDashboard> {

  int _currentIndex=0;
  List<Widget> _widgetOptions= <Widget> [
    employeeHome(),
    latestJobs(),
    applications(),
    messages(),
    employeeProfile(),
  ];
  void onindexTap (int index) {
    setState(() {
      _currentIndex= index;
    });
  }

  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.shifting,
        fixedColor: Colors.brown,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, color: Colors.brown[300],),
              title: Text('Home'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, color: Colors.brown[300]),
              title: Text('Latest Jobs'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_copy_outlined, color: Colors.brown[300]),
              title: Text('My Applications'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline, color: Colors.brown[300]),
              title: Text('Messages'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline, color: Colors.brown[300]),
              title: Text('Profile'),
              backgroundColor: Colors.white
          ),
        ],
        currentIndex: _currentIndex,
        onTap: onindexTap,
      ),
    );
  }
}

