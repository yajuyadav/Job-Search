import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:native_admob_flutter/native_admob_flutter.dart';
import 'package:searchjob/employee/viewJob.dart';
class applications extends StatefulWidget {
  @override
  _applicationsState createState() => _applicationsState();
}

class _applicationsState extends State<applications> {
  User? user=  FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  bool i =false;
  String btn= 'Apply';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading==false?
      StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Employees")
          .doc(user!.uid)
          .collection('Applications')
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
                    color: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: Colors.black54, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.file_copy_outlined, color: Colors.black54,),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                          child: Text('Job: ' + doc['title'],
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        subtitle:  Padding(
                          padding: const EdgeInsets.only(top: 12.0, bottom: 12),
                          child: doc['applicants']>1? Text('${doc['applicants']-1} more Applicants',
                            style: TextStyle(color: Colors.black,
                                fontSize: 20),
                          )
                         : Text('No more Applicants',
                            style: TextStyle(color: Colors.black,
                                fontSize: 20),
                          )
                        ),
                        trailing:
                        doc['status']== 'closed'?
                        Text(doc["status"].toUpperCase(), style: TextStyle(color: Colors.redAccent, fontSize: 26),)
                            :  Text(doc["status"].toUpperCase(), style: TextStyle(color: Colors.green, fontSize: 26),),
                        onTap: (){
                        showAd();
                        Navigator.push(context,MaterialPageRoute(builder: (context) => viewJob(doc['title'],doc['max'],doc['min'],doc['timeperiod'],doc['range'],doc['office'],doc['city'],doc['state'],doc['about'],doc['date'],doc['time'],doc['status'],doc.id, doc['applicants'], doc['employer'], 'fromjob')));},
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
                  leading: Icon(Icons.file_copy_outlined, size: 70,),
                  title: Text('You have not Applied for any Jobs yet.'),
                ),
              ),
            );
          }
      )
          : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
      ), ),
    );
  }
  showAd() async{
    final InterstitialAd interestitialAd= InterstitialAd();
    if(!interestitialAd.isAvailable){
      await interestitialAd.load(unitId: 'ca-app-pub-4619363086776822/3536279234');
    }
    if(interestitialAd.isAvailable){
      await interestitialAd.show();
    }
  }
}
