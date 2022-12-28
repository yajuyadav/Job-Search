import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/chatPage.dart';
import 'package:searchjob/employer/employerSignUp.dart';
import 'package:searchjob/employer/postJob.dart';
import 'package:searchjob/employer/viewEmployee.dart';
class employerHome extends StatefulWidget {
  @override
  _employerHomeState createState() => _employerHomeState();
}

class _employerHomeState extends State<employerHome> {
  User? user= FirebaseAuth.instance.currentUser;
  late bool i;
  bool isLoading= false;
  final String str= 'xyz';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading== false?
      ListView(
        children: [
          Container(
            color: Colors.white,
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text('Top Employee Profiles  ', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, fontSize: 20),),
                  Icon(Icons.next_plan_outlined, color: Colors.brown[400],)
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Employees')
              .where('rating', isGreaterThanOrEqualTo: 4)
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
                return Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: new ClampingScrollPhysics(),
                      children: snapshot.data!.docs.map((doc)
                      {
                        return InkWell(

                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => viewEmployee(doc.id, doc['name'], doc['photo'], doc['Email'], doc['name'], doc['age'], doc['about'],doc['field'],doc['experience'], doc['rating'], doc.id)));
                          },
                          child: Container(
                            color: Colors.white,
                            child: doc['photo'].substring(0, 6) != "assets" ?
                                        Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: CircleAvatar(
                                            radius: 40.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage: NetworkImage(doc['photo']),
                                          ),
                                        )
                                            : Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: CircleAvatar(
                                          radius: 40.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: AssetImage(doc['photo']),
                                        ),
                                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
          ),
          InkWell(
            onTap: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => postJobs()));
            },
            child: Container(
              margin: EdgeInsets.all(12),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.brown[600]!, Colors.grey[300]!],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                  ),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
            ),
             child: Row(
               children: [
                 Icon(Icons.add, size: 40, color: Colors.white,),
                 Text('Post a Job',  style: TextStyle(color: Colors.white, fontSize: 20),),
               ],
             ),
            ),
          ),
          Container(
            color: Colors.white,
            height: 50,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Row(
                children: [
                  Text('Explore more  ', style: TextStyle(color: Colors.brown[400], fontWeight: FontWeight.bold, fontSize: 20),),
                  Icon(Icons.next_plan_outlined, color: Colors.brown[400],)
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Employees')
                  .where('rating', isLessThan: 4)
                  .orderBy('rating', descending: true)
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
                return ListView(
                  shrinkWrap: true,
                  physics: new ClampingScrollPhysics(),
                  children: snapshot.data!.docs.map((doc)
                  {
                    return Card(
                      margin: EdgeInsets.only(bottom: 12, left: 12,right: 12),
                      color: Colors.brown[600]!,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GFRating(
                                      borderColor: Colors.green,
                                      size: 34.0,
                                      color: Colors.white,
                                      value: doc['rating'],
                                      onChanged: (double rating) {  },
                                      // onChanged: (value) {setState(() {_rating = value;});},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        subtitle: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text( doc['field'] , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
                        ),
                        trailing: Column(
                          children: [
                            Container(
                              height: 20,
                              width: 80,
                              child: FlatButton(
                                color: Colors.white60,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                onPressed: () {
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => chatPage(user!.uid, doc['uid'])));

                                },
                                child: Text(
                                  'Contact',
                                  style: TextStyle(color: Colors.brown, fontSize: 12, fontWeight: FontWeight.bold ),
                                ),
                              ),
                            ),
                          ],
                        ),
                          onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => viewEmployee(doc.id, doc['name'], doc['photo'], doc['Email'], doc['name'], doc['age'], doc['about'],doc['field'],doc['experience'], doc['rating'], doc.id)));
                                  },

                      ),
                    );
                  }).toList(),
                );
              }
          ),
        ],
      )
          : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
      )),
    );
  }
}
