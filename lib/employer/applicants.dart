import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employer/viewEmployee.dart';

class applicants extends StatefulWidget {
  String id, job;
  applicants(this.id, this.job);
  @override
  _applicantsState createState() => _applicantsState();
}

class _applicantsState extends State<applicants> {
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  bool val= false;
  late bool i;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.brown[600],
            title: Text("Applicants"),
          ),
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
                            .doc(user!.uid)
                            .collection("Applicants")
                            .where('jobtitle' ,isEqualTo: widget.job)
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
                          return Expanded(
                            child: SingleChildScrollView(
                              child: ListView(
                                shrinkWrap: true,
                                physics: new ClampingScrollPhysics(),
                                children: snapshot.data!.docs.map((doc)
                                {
                                  i= doc['bookmark'];
                                  return Card(
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
                                        child: Text('Applied : ' +  doc['Date'].toString() , style: TextStyle(color: Colors.white),)
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

                                              },
                                              child: Text(
                                                'Contact',
                                                style: TextStyle(color: Colors.brown, fontSize: 12, fontWeight: FontWeight.bold ),
                                              ),
                                            ),
                                          ),

                                          InkWell(
                                              onTap: (){
                                                if(doc['bookmark']== true){
                                                  setState(() {
                                                    i= false;
                                                  });
                                                  FirebaseFirestore.instance.collection('Employers')
                                                      .doc(user!.uid)
                                                      .collection('Applicants')
                                                      .doc(doc.id)
                                                      .update({'bookmark': false});
                                                }
                                                else if(doc['bookmark']== false){
                                                  setState(() {
                                                    i= true;
                                                  });
                                                  FirebaseFirestore.instance.collection('Employers')
                                                      .doc(user!.uid)
                                                      .collection('Applicants')
                                                      .doc(doc.id)
                                                      .update({'bookmark': true});
                                                }
                                              },
                                              child: Container(child: i== false?
                                              Icon(Icons.bookmark_border, color: Colors.white, size: 34,)
                                              : Icon(Icons.bookmark, color: Colors.white, size: 34,)
                                              )),
                                        ],
                                      ),
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => viewEmployee(doc['uid'], doc['name'], doc['photo'], doc['Email'], widget.job, doc['age'], doc['about'],doc['field'],doc['experience'], doc['rating'], doc.id.replaceAll(doc['uid'], ''))));
                                      },
                                    ),
                                  );
                                }).toList(),
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
        )
    );
  }
}

