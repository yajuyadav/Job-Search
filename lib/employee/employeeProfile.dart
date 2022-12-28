import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/aboutUs.dart';
import 'package:searchjob/auth_services.dart';
import 'package:searchjob/employee/editProfile.dart';
import 'package:searchjob/employee/employeeReviews.dart';
import 'package:searchjob/employee/employeebookmarks.dart';
import 'package:searchjob/employee/jobsDone.dart';
import 'package:searchjob/help.dart';
import 'package:searchjob/loginscreen.dart';
import 'package:provider/provider.dart';
class employeeProfile extends StatefulWidget {
  @override
  _employeeProfileState createState() => _employeeProfileState();
}

class _employeeProfileState extends State<employeeProfile> {
  final String str= 'employee';
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading==false?
      SizedBox(
        child: ListView(
          children: [
            Container(
              width: double.infinity,
              height: 300.0,
              decoration: BoxDecoration(
                  color: Colors.brown[600]
              ),
              child: StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance.collection('Employees')
                      .doc(user!.uid)
                      .snapshots(),
                  builder:
                      (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                    }
                    DocumentSnapshot doc= snapshot.data!;
                    return Container(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: doc['photo'].substring(0, 6) != "assets" ?
                              CircleAvatar(
                                radius: 80.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(doc['photo']),
                              )
                                  : CircleAvatar(
                                radius: 80.0,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(doc['photo']),
                              ),
                            ),
                            Text(doc['name'], style: TextStyle(color: Colors.white, fontSize: 28), overflow: TextOverflow.ellipsis,),
                            Container(
                              margin:  EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(14))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Employee',
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),

                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GFRating(
                                borderColor: Colors.blue,
                                size: 34.0,
                                color: Colors.white,
                                value: doc['rating'],
                                onChanged: (double rating) {  },
                                // onChanged: (value) {setState(() {_rating = value;});},
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                leading: Icon(Icons.edit),
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Edit Profile"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => editProfile()));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Bookmarks"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => bookmarks()));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Reviews"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => employeeReviews(str, user!.uid)));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Jobs Done"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => jobsDone(str, user!.uid)));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("About Us"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => aboutUs()));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[100],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Help"),
                ),
                trailing: Icon(Icons.navigate_next),
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => help()));
                },
              ),
            ),
            Container(
              child: ListTile(
                tileColor: Colors.grey[300],
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text("Logout"),
                ),
                trailing: Icon(Icons.logout),
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (currentContext) => AlertDialog(
                      insetPadding: EdgeInsets.symmetric(vertical: 10),
                      title: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.brown[600]),
                          SizedBox(width: 5,),
                          Text('Log Out?'),
                        ],
                      ),
                      content: Text('Are you sure you want to Logout?'),
                      actions: <Widget>[
                        FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('No'),
                        ),
                        FlatButton(
                          onPressed: () async {
                            Navigator.of(context, rootNavigator: true).pop();

                            context.read<AuthService>().signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => loginscreen()),
                                    (route) => false);
                          },
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
      ), ),
    );
  }
}
