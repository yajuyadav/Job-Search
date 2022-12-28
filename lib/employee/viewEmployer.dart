import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employee/viewJob.dart';
import 'package:searchjob/employer/myEmployees.dart';
import 'package:searchjob/employer/reviews.dart';

class viewEmployer extends StatefulWidget {
  final String uid, name, photo;
  viewEmployer(this.uid, this.name, this.photo);
  @override
  _viewEmployerState createState() => _viewEmployerState();
}

class _viewEmployerState extends State<viewEmployer> {
  final String str= 'employee';
  User? user= FirebaseAuth.instance.currentUser;
  String btn= 'Apply';
  DateTime now= DateTime.now();
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: (){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[500],
            title: Row(
              children: [
                Container(
                  color: Colors.brown[500],
                  child: widget.photo.substring(0, 6) != "assets" ?
                  CircleAvatar(
                    radius: 26.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(widget.photo),
                  )
                      : CircleAvatar(
                    radius: 26.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage(widget.photo),
                  ),
                ),
                Text('  '+widget.name,  overflow: TextOverflow.ellipsis,),
              ],
            ),
          ),
          body: isLoading==false?
          StreamBuilder<DocumentSnapshot>(
              stream:  FirebaseFirestore.instance.collection('Employers')
                  .doc(widget.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                }
                DocumentSnapshot doc= snapshot.data!;
                return ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.grey, Colors.grey[300]!],
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                          ),
                          border: Border.all(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(doc['bio'],  style: TextStyle(color: Colors.black54, fontSize: 20),),
                      ),
                    ),

                    ListTile(
                      title: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.grey, Colors.grey[300]!],
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('EMAIL ', style: TextStyle(color: Colors.black, fontSize: 20),),
                              )),
                          Text('   '+ doc['Email'], style: TextStyle(color: Colors.black54, fontSize: 18),),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.grey[300]!],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: Text('Employees', style: TextStyle(color: Colors.black, fontSize: 20),),
                        trailing:  Icon(Icons.navigate_next, color: Colors.black,),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => myEmployees(str, widget.uid)));
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.grey, Colors.grey[300]!],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: ListTile(
                        title: Text('Reviews', style: TextStyle(color: Colors.black, fontSize: 20),),
                        trailing:  Icon(Icons.navigate_next, color: Colors.black,),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => reviews(str, widget.uid)));
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      color: Colors.green,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: GFRating(
                          borderColor: Colors.green[800],
                          size: 34.0,
                          color: Colors.white,
                          value: doc['rating'],
                          onChanged: (double rating) {  },
                          // onChanged: (value) {setState(() {_rating = value;});},
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 50,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text('More from the Employer  ', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, fontSize: 20),),
                            Icon(Icons.next_plan_outlined, color: Colors.brown[400],)
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Employers")
                            .doc(widget.uid)
                            .collection('Jobs')
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
                          return
                            Stack(
                              children: [
                                Center(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 20),
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
                                      ),
                                  ),
                                ),
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
                                              doc['status']== 'closed'?
                                              Container()
                                                  : StreamBuilder<DocumentSnapshot>(
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
                                              ),
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
                                        Text(doc["status"].toUpperCase(), style: TextStyle(color: Colors.redAccent, fontSize: 26),) :Text(''),
                                        /*    :  Column(
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
                                                                  .doc(user!.uid + doc.id)
                                                                  .set({
                                                                'bookmark': false,
                                                                'jobtitle': doc['title'],
                                                                'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
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
                                                                'rating': 0.0,
                                                              });
                                                              FirebaseFirestore.instance.collection('Employers')
                                                                  .doc(doc['employer'])
                                                                  .collection('Jobs')
                                                                  .doc(doc.id)
                                                                  .update({
                                                                'applicants': doc['applicants'] +1,
                                                              });
                                                              FirebaseFirestore.instance.collection('Employers')
                                                                  .doc(doc['employer'])
                                                                  .collection('Jobs')
                                                                  .doc(doc.id)
                                                                  .collection('applicants')
                                                                  .doc(user!.uid+ doc.id)
                                                                  .set({
                                                                'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
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
                                                                'rating': 0.0,
                                                              });

                                                              FirebaseFirestore.instance.collection('Jobs')
                                                                  .doc(doc.id)
                                                                  .collection('Applicants')
                                                                  .doc(user!.uid+ doc.id)
                                                                  .set({
                                                                'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
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
                                                                'rating': 0.0,
                                                              });
                                                              FirebaseFirestore.instance.collection('Jobs')
                                                                  .doc(doc.id)
                                                                  .update({
                                                                'applicants': doc['applicants']+1,
                                                              });
                                                            });
                                                            FirebaseFirestore.instance.collection('Employees')
                                                                .doc(user!.uid)
                                                                .collection('Applications')
                                                                .doc(doc.id)
                                                                .set({
                                                              'employer': doc['employer'],
                                                              'applicants': doc['applicants']+1,
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
                                                                .doc(user!.uid + doc.id)
                                                                .delete();
                                                            FirebaseFirestore.instance.collection('Employers')
                                                                .doc(doc['employer'])
                                                                .collection('Jobs')
                                                                .doc(doc.id)
                                                                .collection('applicants')
                                                                .doc(user!.uid + doc.id)
                                                                .delete();
                                                            FirebaseFirestore.instance.collection('Employers')
                                                                .doc(doc['employer'])
                                                                .collection('Jobs')
                                                                .doc(doc.id)
                                                                .update({
                                                              'applicants': doc['applicants']-1,
                                                            });
                                                            FirebaseFirestore.instance.collection('Jobs')
                                                                .doc(doc.id)
                                                                .collection('Applicants')
                                                                .doc(user!.uid + doc.id)
                                                                .delete();

                                                            FirebaseFirestore.instance.collection('Jobs')
                                                                .doc(doc.id)
                                                                .update({
                                                              'applicants': doc['applicants']-1,
                                                            });
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
                                        ), */
                                        onTap: (){Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['applicants'], widget.uid, 'fromemployer')));},
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                        }
                    ),
                  ],
                );
              }
          )
              : Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
          )),
        ));
  }
}
