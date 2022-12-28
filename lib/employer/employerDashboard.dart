import 'package:flutter/material.dart';
import 'package:searchjob/employer/employeesRequests.dart';
import 'package:searchjob/employer/employerHome.dart';
import 'package:searchjob/employer/employerSignUp.dart';
import 'package:searchjob/employer/employerprofile.dart';
import 'package:searchjob/employer/postedJobs.dart';
import 'package:searchjob/messages.dart';
class employerDashboard extends StatefulWidget {
  @override
  _employerDashboardState createState() => _employerDashboardState();
}

class _employerDashboardState extends State<employerDashboard> {
  int _currentIndex=0;
  List<Widget> _widgetOptions= <Widget> [
    employerHome(),
    employeesRequests(),
    postedJobs(),
    messages(),
    employerProfile(),
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
              title: Text('Applications'),
              backgroundColor: Colors.white
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.post_add_outlined, color: Colors.brown[300]),
              title: Text('Posts'),
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
