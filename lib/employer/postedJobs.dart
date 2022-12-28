import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchjob/employer/employerSignUp.dart';
import 'package:searchjob/employer/postJob.dart';
import 'package:searchjob/employer/viewJob.dart';
class postedJobs extends StatefulWidget {
  @override
  _postedJobsState createState() => _postedJobsState();
}

class _postedJobsState extends State<postedJobs> {
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading==false?
        ListView(
        children: [
          Container(
            child: ListTile(
              tileColor: Colors.brown[600],
              leading: Icon(Icons.add,color: Colors.white, size: 40,),
              title: Text("Post a Job", style: TextStyle(color: Colors.white, fontSize: 20),),
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => postJobs()));
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Employers')
                  .doc(user!.uid)
                  .collection("Jobs")
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder:
                  (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
                }
                return snapshot.data!.size>0?
                ListView(
                  shrinkWrap: true,
                  //physics: new ClampingScrollPhysics(),
                  children: snapshot.data!.docs.map((doc)
                  {
                    return Card(
                      color: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.brown[500]!, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text('Job: ' + doc['title'],
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Applicants: ${doc['applicants']}', style: TextStyle(color: Colors.black, fontSize: 20),),
                                ],
                              ),
                              Row(
                                children: [
                                  double.parse(doc['time'].split(':')[0])< 12?
                                  Text('Posted: '+ doc['date'] + " , " + doc['time'] + " AM")
                                      : Text('Posted: '+ doc['date'] + " , " + doc['time'] + " PM"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Text(
                          doc["status"].toUpperCase(), style: TextStyle(color: doc['status']== 'open'? Colors.green : Colors.redAccent, fontSize: 26),
                        ),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['applicants'])));
                        },
                        onLongPress: () async {
                          await showDialog(
                              context: context,
                              builder: (currentContext) => AlertDialog(
                            insetPadding: EdgeInsets.symmetric(vertical: 10),
                            title: Row(
                              children: [
                                Icon(Icons.warning_amber_outlined, color: Colors.yellowAccent),
                                SizedBox(width: 5,),
                                Text('Delete? '),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No'),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading==true;
                                  });
                                  Navigator.of(context, rootNavigator: true).pop();
                                  User? user= FirebaseAuth.instance.currentUser;
                                  await FirebaseFirestore.instance.collection("Employers").doc(user!.uid).collection('Jobs').doc(doc.id).delete();
                                  await FirebaseFirestore.instance.collection('Jobs').doc(doc.id).delete();
                                  await FirebaseFirestore.instance.collection('Jobs').doc(doc.id).collection('Applicants').get()
                                      .then((QuerySnapshot snapshot) {
                                        snapshot.docs.forEach((employee) {
                                          FirebaseFirestore.instance.collection('Employees')
                                              .doc(employee.id.replaceAll(doc.id, ''))
                                              .collection('Applications')
                                              .doc(doc.id).delete();
                                        });
                                  });
                                  await FirebaseFirestore.instance.collection('Employers').doc(user.uid).collection('Applicants').get()
                                      .then((QuerySnapshot snapshot) {
                                    snapshot.docs.forEach((employer) {
                                      if(employer.id.endsWith(doc.id)){
                                      FirebaseFirestore.instance.collection('Employers')
                                          .doc(user.uid)
                                          .collection('Applicants')
                                          .doc(employer.id).delete(); }
                                    });
                                  });
                                  await FirebaseFirestore.instance.collection('Jobs').doc(doc.id).collection('Applicants').get()
                                      .then((QuerySnapshot snapshot) {
                                    snapshot.docs.forEach((employee) {
                                      FirebaseFirestore.instance.collection('Employees')
                                          .doc(employee.id.replaceAll(doc.id, ''))
                                          .collection('Bookmarks')
                                          .doc(doc.id).delete();
                                    });
                                  });
                                  setState(() {
                                    isLoading=false;
                                  });
                                },
                                child: Text('Yes'),
                              ),
                            ],
                          ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                )
                    :Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    margin: EdgeInsets.only(top: 40),
                    height: 80,
                    child: ListTile(
                      tileColor: Colors.black12,
                      leading: Icon(Icons.add, size: 70,),
                      title: Text('Post a Job to hire Employees.'),
                    ),
                  ),
                );
              }
          ),
        ])
            : Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
        ), ),
    );
  }
}