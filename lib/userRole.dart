import 'package:flutter/material.dart';
import 'package:searchjob/employee/employeeSignUp.dart';
import 'package:searchjob/employer/employerSignUp.dart';
class userRole extends StatefulWidget {
  @override
  _userRoleState createState() => _userRoleState();
}

class _userRoleState extends State<userRole> {
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
      Image.asset("assets/images/background.jpg"),
      Scaffold(
      backgroundColor: Colors.transparent,
        body: isLoading==false?
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   Container(
                     margin: EdgeInsets.only(top: 90, right: 20, left: 20),
                     child: Center(child: Text('Continue As', style: TextStyle(color: Colors.brown, fontSize: 30),)),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: 80),
                     height: 50,
                     width: 300,
                     child: FlatButton(
                       color: Colors.brown[400],
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                       onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder: (context) => employeesignUp()));
                       },
                       child: Text(
                         'Employee',
                         style: TextStyle(color: Colors.white, fontSize: 20 ),
                       ),
                     ),
                   ),
                   Container(
                     margin: EdgeInsets.only(top: 40),
                     height: 50,
                     width: 300,
                     child: FlatButton(
                       color: Colors.white60,
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                       onPressed: () {
                         Navigator.push(context,MaterialPageRoute(builder: (context) => employersignUp()));
                       },
                       child: Text(
                         'Employer',
                         style: TextStyle(color: Colors.brown, fontSize: 20 ),
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           )
            : Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
        ), ),
        )
       ]
      ),
    );
  }
}