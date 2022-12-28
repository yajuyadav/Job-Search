import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employer/viewEmployee.dart';

class myEmployees extends StatefulWidget {
  String from, uid;
  myEmployees(this.from, this.uid);
  @override
  _myEmployeesState createState() => _myEmployeesState();
}

class _myEmployeesState extends State<myEmployees> {
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  late String title;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
            ),
          ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[600],
            title: Text("Employees"),
          ),
          backgroundColor: Colors.transparent,
          body: isLoading == false
              ? SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Employers')
                            .doc(widget.uid)
                        .collection('Employees')
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
                          return snapshot.data!.size>0?
                            Expanded(
                            child: SingleChildScrollView(
                              child: ListView(
                                shrinkWrap: true,
                                physics: new ClampingScrollPhysics(),
                                children: snapshot.data!.docs.map((doc)
                                {
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 12, left: 2,right: 2),
                                    color: Colors.brown[600]!,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: StreamBuilder<DocumentSnapshot>(
                                      stream:  FirebaseFirestore.instance.collection('Jobs')
                                          .doc(doc['jobId'])
                                          .snapshots(),
                                      builder: (context, snap) {
                                        if (snap.hasError) {
                                          return Text('Something went wrong');
                                        }

                                        if (snap.connectionState == ConnectionState.waiting) {
                                          return Center(child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                                        }
                                        DocumentSnapshot job= snap.data!;
                                        return ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    doc['photo'].substring(0, 6) != "assets" ?
                                                    CircleAvatar(
                                                      radius: 30.0,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: NetworkImage(doc['photo']),
                                                    )
                                                        : CircleAvatar(
                                                      radius: 30.0,
                                                      backgroundColor: Colors.transparent,
                                                      backgroundImage: AssetImage(doc['photo']),
                                                    ),
                                                    SizedBox(width: 4,),
                                                    Flexible(
                                                      child: Text(doc['name'],
                                                        style: TextStyle(color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 20),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(0.0),
                                                        child: GFRating(
                                                          borderColor: Colors.green,
                                                          size: 34.0,
                                                          color: Colors.white,
                                                          value: doc['rating'],
                                                          onChanged: (double rating) {  },
                                                          // onChanged: (value) {setState(() {_rating = value;});},
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Padding(
                                                  padding: const EdgeInsets.all(12.0),
                                                  child: Text( 'Job: '+  job['title'], style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,)
                                              ),
                                          trailing: doc['current']=='hired'?  Text('WORKING', style: TextStyle(color: Colors.green, fontSize: 26),)
                                          : Text('DONE', style: TextStyle(color: Colors.redAccent, fontSize: 26),),
                                          onTap: () async {
                                            if(widget.from=='employer'){
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                viewEmployee(doc['uid'], doc['name'], doc['photo'], doc['Email'], job['title']
                                , doc['age'], doc['about'],doc['field'],doc['experience'], doc['rating'], doc['jobId'])));
                                } },

                                        );
                                      }
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          )
                              :Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              child: ListTile(
                                tileColor: Colors.black12,
                                leading: Icon(Icons.hourglass_empty, size: 70,),
                                title: Text('No previous Employees to show.'),
                              ),
                            ),
                          );
                        }
                    ),
                  ])
          )
              : Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
          )),
        ),
      ],
    );
  }
}

