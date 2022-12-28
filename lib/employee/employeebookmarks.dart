import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employee/viewJob.dart';
import 'package:searchjob/employer/viewEmployee.dart';

class bookmarks extends StatefulWidget {
  @override
  _bookmarksState createState() => _bookmarksState();
}

class _bookmarksState extends State<bookmarks> {
  User? user=  FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  bool i =false;
  String btn= 'Apply';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
            ),
          ),
        ),
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.brown[600],
          title: Text("Bookmarks"),
        ),
        backgroundColor: Colors.transparent,
        body: isLoading==false?
        SizedBox(
            child: ListView(
                children: [

                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Employees")
                          .doc(user!.uid)
                          .collection('Bookmarks')
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
                            physics: new ClampingScrollPhysics(),
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
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text('Job: ' + doc['title'],
                                            style: TextStyle(color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        doc['status']!= 'closed'?
                                        StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance.collection('Employees')
                                                .doc(user!.uid)
                                                .collection('Bookmarks')
                                                .doc(doc.id)
                                                .snapshots(),
                                            builder: (context, snapsh) {
                                              if (snapsh.hasError) {
                                                return Text('Something went wrong');
                                              }

                                              if (snapsh.connectionState == ConnectionState.waiting) {
                                                return Center(child: CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
                                              }
                                              return InkWell(
                                                  onTap: (){
                                                    if(snapsh.data!.exists== false){
                                                      FirebaseFirestore.instance.collection('Employees')
                                                          .doc(user!.uid)
                                                          .collection('Bookmarks')
                                                          .doc(doc.id)
                                                          .set({  'employer': doc['employer'],
                                                        'applicants': doc['applicants'],
                                                        'title': doc['title'],
                                                        'min': doc['min'],
                                                        'max': doc['max'],
                                                        'timeperiod': doc['timeperiod'],
                                                        'range': doc['range'],
                                                        'office': doc['office'],
                                                        'city': doc['city'],
                                                        'state': doc['state'],
                                                        'about': doc['about'],
                                                        'status': doc['status'],
                                                        'date': doc['date'],
                                                        'time': doc['time'],
                                                        'id': doc.id});
                                                    }
                                                    else {
                                                      FirebaseFirestore.instance.collection('Employees')
                                                          .doc(user!.uid)
                                                          .collection('Bookmarks')
                                                          .doc(doc.id)
                                                          .delete();
                                                    }
                                                  },
                                                  child: Container(
                                                      margin: EdgeInsets.only(top: 2),
                                                      child: snapsh.data!.exists== false?
                                                      Icon(Icons.bookmark_border, color: Colors.black, size: 34,)
                                                          : Icon(Icons.bookmark, color: Colors.black, size: 34,)
                                                  )
                                              );
                                            }
                                        ) :Container()
                                      ],
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('₹${doc['min']}- ₹${doc['max']}', style: TextStyle(color: Colors.black, fontSize: 20),),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('${doc['timeperiod']} ${doc['range']}', style: TextStyle(color: Colors.black, fontSize: 20),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing:
                                  doc['status']== 'closed'?
                                  Text(doc["status"].toUpperCase(), style: TextStyle(color: Colors.redAccent, fontSize: 26),)
                                      :  Text(''),
                                /*  Column(
                                    children: [
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('Employees')
                                              .doc(user!.uid)
                                              .collection('Bookmarks')
                                              .doc(doc.id)
                                              .snapshots(),
                                          builder: (context, snapsh) {
                                            return InkWell(
                                                onTap: (){
                                                  if(snapsh.data!.exists== false){
                                                    FirebaseFirestore.instance.collection('Employees')
                                                        .doc(user!.uid)
                                                        .collection('Bookmarks')
                                                        .doc(doc.id)
                                                        .set({  'employer': doc['employer'],
                                                      'applicants': doc['applicants'],
                                                      'title': doc['title'],
                                                      'min': doc['min'],
                                                      'max': doc['max'],
                                                      'timeperiod': doc['timeperiod'],
                                                      'range': doc['range'],
                                                      'office': doc['office'],
                                                      'city': doc['city'],
                                                      'state': doc['state'],
                                                      'about': doc['about'],
                                                      'status': doc['status'],
                                                      'date': doc['date'],
                                                      'time': doc['time'],
                                                      'id': doc.id});
                                                  }
                                                  else {
                                                    FirebaseFirestore.instance.collection('Employees')
                                                        .doc(user!.uid)
                                                        .collection('Bookmarks')
                                                        .doc(doc.id)
                                                        .delete();
                                                  }
                                                },
                                                child: Container(
                                                    margin: EdgeInsets.only(top: 2),
                                                    child: snapsh.data!.exists== false?
                                                    Icon(Icons.bookmark_border, color: Colors.black, size: 34,)
                                                        : Icon(Icons.bookmark, color: Colors.black, size: 34,)
                                                )
                                            );
                                          }
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance.collection('Employees')
                                              .doc(user!.uid)
                                              .collection('Applications')
                                              .doc(doc.id)
                                              .snapshots(),
                                          builder: (context, snap) {
                                            return Container(
                                              height: 20,
                                              width: 90,
                                              child: FlatButton(
                                                  color: Colors.brown[400],
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                  onPressed: () async {
                                                    if(snap.data!.exists== false) {
                                                      setState(() {
                                                        isLoading=true;
                                                      });
                                                      await FirebaseFirestore.instance.collection('Employees').doc(user!.uid).get().then((employe){
                                                        FirebaseFirestore.instance.collection('Employers')
                                                            .doc(doc['employer'])
                                                            .collection('Applicants')
                                                            .doc(user!.uid)
                                                            .set({
                                                          'bookmark': false,
                                                          'jobtitle': doc['title'],
                                                          'Date': DateTime.now(),
                                                          'uid' : user!.uid,
                                                          'name' : employe['name'],
                                                          'photo' : employe['photo'],
                                                          'role' : "employee",
                                                          'field': employe['field'],
                                                          'experience': employe['experience'],
                                                          'about': employe['about'],
                                                          'dob': employe['dob'],
                                                          'age': employe['age'],
                                                          'Email': employe['Email'],
                                                          'rating': employe['rating'],
                                                        });
                                                        FirebaseFirestore.instance.collection('Employers')
                                                            .doc(doc['employer'])
                                                            .collection('Jobs')
                                                            .doc(doc.id)
                                                            .collection('applicants')
                                                            .doc(user!.uid)
                                                            .set({
                                                          'Date': DateTime.now(),
                                                          'uid' : user!.uid,
                                                          'name' : employe['name'],
                                                          'photo' : employe['photo'],
                                                          'role' : "employee",
                                                          'field': employe['field'],
                                                          'experience': employe['experience'],
                                                          'about': employe['about'],
                                                          'dob': employe['dob'],
                                                          'age': employe['age'],
                                                          'Email': employe['Email'],
                                                          'rating': employe['rating'],
                                                        });

                                                        FirebaseFirestore.instance.collection('Jobs')
                                                            .doc(doc.id)
                                                            .collection('Applicants')
                                                            .doc(user!.uid)
                                                            .set({
                                                          'Date': DateTime.now(),
                                                          'uid' : user!.uid,
                                                          'name' : employe['name'],
                                                          'photo' : employe['photo'],
                                                          'role' : "employee",
                                                          'field': employe['field'],
                                                          'experience': employe['experience'],
                                                          'about': employe['about'],
                                                          'dob': employe['dob'],
                                                          'age': employe['age'],
                                                          'Email': employe['Email'],
                                                          'rating': employe['rating'],
                                                        });
                                                      });
                                                      FirebaseFirestore.instance.collection('Employees')
                                                          .doc(user!.uid)
                                                          .collection('Applications')
                                                          .doc(doc.id)
                                                          .set({
                                                        'employer': doc['employer'],
                                                        'applicants': doc['applicants'],
                                                        'title': doc['title'],
                                                        'min': doc['min'],
                                                        'max': doc['max'],
                                                        'timeperiod': doc['timeperiod'],
                                                        'range': doc['range'],
                                                        'office': doc['office'],
                                                        'city': doc['city'],
                                                        'state': doc['state'],
                                                        'about': doc['about'],
                                                        'status': doc['status'],
                                                        'date': doc['date'],
                                                        'time': doc['time'],
                                                        'id': doc.id
                                                      });
                                                      setState(() {
                                                        btn= 'Withdraw';
                                                      }); setState(() {
                                                        isLoading=false;
                                                      });}
                                                    else{
                                                      setState(() {
                                                        isLoading=true;
                                                      });
                                                      FirebaseFirestore.instance.collection('Employers')
                                                          .doc(doc['employer'])
                                                          .collection('Applicants')
                                                          .doc(user!.uid)
                                                          .delete();
                                                      FirebaseFirestore.instance.collection('Employers')
                                                          .doc(doc['employer'])
                                                          .collection('Jobs')
                                                          .doc(doc.id)
                                                          .collection('applicants')
                                                          .doc(user!.uid)
                                                          .delete();
                                                      FirebaseFirestore.instance.collection('Jobs')
                                                          .doc(doc.id)
                                                          .collection('Applicants')
                                                          .doc(user!.uid)
                                                          .delete();

                                                      FirebaseFirestore.instance.collection('Employees')
                                                          .doc(user!.uid)
                                                          .collection('Applications')
                                                          .doc(doc.id)
                                                          .delete();
                                                      setState(() {
                                                        btn= 'Apply';
                                                      }); setState(() {
                                                        isLoading=false;
                                                      });
                                                    }
                                                    if(FirebaseFirestore.instance.collection('Jobs').doc(doc.id).collection('Applicants').get()!= null)
                                                    {
                                                      FirebaseFirestore.instance.collection('Jobs')
                                                          .doc(doc.id).collection('Applicants')
                                                          .get().then((QuerySnapshot value) {
                                                        FirebaseFirestore.instance.collection('Jobs')
                                                            .doc(doc.id).update({
                                                          'applicants': value.size
                                                        });
                                                        FirebaseFirestore.instance.collection('Employers')
                                                            .doc(doc['employer'])
                                                            .collection('Jobs')
                                                            .doc(doc.id)
                                                            .update({
                                                          'applicants': value.size,
                                                        });
                                                        FirebaseFirestore.instance.collection('Employees')
                                                            .doc(user!.uid)
                                                            .collection('Applications')
                                                            .doc(doc.id)
                                                            .update({
                                                          'applicants': value.size,
                                                        });
                                                      }); }
                                                    else{
                                                      FirebaseFirestore.instance.collection('Jobs')
                                                          .doc(doc.id).collection('Applicants')
                                                          .get().then((QuerySnapshot value) {
                                                        FirebaseFirestore.instance.collection('Jobs')
                                                            .doc(doc.id).update({
                                                          'applicants': 0
                                                        });
                                                        FirebaseFirestore.instance.collection('Employers')
                                                            .doc(doc['employer'])
                                                            .collection('Jobs')
                                                            .doc(doc.id)
                                                            .update({
                                                          'applicants': 0,
                                                        });
                                                        FirebaseFirestore.instance.collection('Employees')
                                                            .doc(user!.uid)
                                                            .collection('Applications')
                                                            .doc(doc.id)
                                                            .update({
                                                          'applicants': 0,
                                                        });
                                                      });
                                                    }
                                                  },
                                                  child: snap.data!.exists== true?
                                                  Text('Withdraw', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold ),
                                                  )
                                                      :  Text('Apply', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold ),
                                                  )
                                              ),
                                            );
                                          }
                                      ),

                                    ],
                                  ),*/
                                  onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['applicants'], doc['employer'], 'fromjob')));},
                                ),
                              );
                            }).toList(),
                          )
                            :Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            child: ListTile(
                              tileColor: Colors.black12,
                              leading: Icon(Icons.bookmark_border, size: 70,),
                              title: Text('You have no bookmarked Jobs.'),
                            ),
                          ),
                        );
                      }
                  ),
                ])
        )
            : Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
        ), ),
      )
    ]
    );
  }
}

