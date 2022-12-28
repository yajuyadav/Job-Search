import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employee/viewEmployer.dart';
import 'package:searchjob/employer/viewEmployee.dart';

class reviews extends StatefulWidget {
  String from, uid;
  reviews(this.from, this.uid);
  @override
  _reviewsState createState() => _reviewsState();
}

class _reviewsState extends State<reviews> {
  //User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  bool val= false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
          ), ),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[600],
            title: Text("Reviews"),
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
                            .collection("Reviews")
                            .orderBy('date', descending: true)
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
                                    color: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: StreamBuilder<DocumentSnapshot>(
                                        stream:  FirebaseFirestore.instance.collection('Employees')
                                            .doc(doc['employee'])
                                            .snapshots(),
                                        builder: (context, snap) {
                                          if (snap.hasError) {
                                            return Text('Something went wrong');
                                          }

                                          if (snap.connectionState == ConnectionState.waiting) {
                                            return Center(child: CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                                          }
                                          DocumentSnapshot emp= snap.data!;
                                          return ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(top: 6.0, ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      emp['photo'].substring(0, 6) != "assets" ?
                                                      CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: NetworkImage(emp['photo']),
                                                      )
                                                          : CircleAvatar(
                                                        radius: 20.0,
                                                        backgroundColor: Colors.transparent,
                                                        backgroundImage: AssetImage(emp['photo']),
                                                      ),
                                                      SizedBox(width: 4,),
                                                      Flexible(
                                                        child: Text(emp['name'],
                                                          style: TextStyle(color: Colors.white,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 20),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        GFRating(
                                                          borderColor: Colors.blue,
                                                          size: 28.0,
                                                          color: Colors.white,
                                                          value: doc['rating'],
                                                          onChanged: (double rating) {  },
                                                          // onChanged: (value) {setState(() {_rating = value;});},
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 10.0, ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Text( 'Job: '+
                                                            doc['jobtitle'], style: TextStyle(color: Colors.black54),
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(5.0),
                                                        child: Text( 'Review: '+
                                                            doc['review'], style: TextStyle(color: Colors.black54),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(bottom: 12.0, left: 12, right: 12),
                                              child: double.parse(doc['time'].split(':')[0])< 12?
                                              Text(doc['date'] + " , " + doc['time'] + " AM", style: TextStyle(color: Colors.white),)
                                                  : Text(doc['date'] + " , " + doc['time'] + " PM", style: TextStyle(color: Colors.white)),
                                            ),
                                            onTap: (){
                                              if(widget.from== 'employer'){
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => viewEmployee(doc['employee'], emp['name'], emp['photo'], emp['Email'], doc['jobtitle'], emp['age'], emp['about'], emp['field'], emp['experience'], emp['rating'], doc['job'])));
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
                                title: Text('Sorry there are no Reviews yet.'),
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
