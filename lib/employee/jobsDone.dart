import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employee/viewJob.dart';
import 'package:searchjob/employer/viewEmployee.dart';

class jobsDone extends StatefulWidget {
  String from, uid;
  jobsDone(this.from, this.uid);
  @override
  _jobsDoneState createState() => _jobsDoneState();
}

class _jobsDoneState extends State<jobsDone> {
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
            title: Text("Jobs Done"),
          ),
          backgroundColor: Colors.transparent,
          body: isLoading==false?
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Employees")
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
                return snapshot.data!.size>0?
                ListView(
                  //shrinkWrap: true,
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
                        Text(doc["current"].toUpperCase(), style: TextStyle(color: doc['current']=='hired'? Colors.green :Colors.redAccent, fontSize: 26),),
                        onTap: (){
                          if(widget.from== 'employee'){
                  Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['current'].toString().length- 29, doc['employer'], 'fromjob')));
                  } },
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
                      leading: Icon(Icons.error_outline, size: 70,),
                      title: Text('No Job history.'),
                    ),
                  ),
                );
              }
          )
              : Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
          ), ),
        ),
      ],
    );
  }
}

