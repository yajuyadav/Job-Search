import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchjob/employer/applicants.dart';


class viewJob extends StatefulWidget {
  final String title, max, min, timeperiod, timerange, office, city, state, about, date, time, status,id;
  int applicants;
  viewJob(this.title,this.max,this.min,this.timeperiod,this.timerange,this.office,this.city,this.state,this.about,this.date,this.time,this.status,this.id,this.applicants);
  @override
  _viewJobState createState() => _viewJobState();
}

class _viewJobState extends State<viewJob> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        body:  isLoading==false ?
        Padding(
          padding: const EdgeInsets.only( top: 0),
          child: ListView(
              children: [
                widget.applicants==0?
                    Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.grey,
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          children: [
                            Text('0 Applicants for this job'),
                            SizedBox(width: 4,),
                            Icon(Icons.error_outline),
                          ],
                        ),
                      ),
                    )
                    :InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => applicants(widget.id, widget.title)));
                  },
                      child: Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.redAccent,
                  child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Text('  ${widget.applicants} Applicants for this job', style: TextStyle(color: Colors.white),),
                          SizedBox(width: 4,),
                          Icon(Icons.navigate_next, color: Colors.white,),
                        ],
                      ),
                  ),
                ),
                    ),
        ListTile(
          tileColor: Colors.brown[400],
            title: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Job: ' + widget.title,
                style: TextStyle(color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            trailing: Text(
              widget.status.toUpperCase(), style: TextStyle(color: widget.status== 'open'? Colors.green : Colors.redAccent, fontSize: 26),
            ),
        ),
                Container(
                  margin: EdgeInsets.only(top: 7, right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                      border: Border.all(
                        color: Colors.brown[600]!,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(14))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text('Salary: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              Text(
                                 widget.min+ ' - '+ widget.max, style: TextStyle(fontSize: 20,),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text('TimePeriod: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              Text(
                                 widget.timeperiod + ' '+ widget.timerange, style: TextStyle(fontSize: 20,)
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text('Address: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    widget.office + ',' + '\n' + widget.city+ ','+'\n'+ widget.state, style: TextStyle(fontSize: 20,)
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              Text('Posted: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                              double.parse(widget.time.split(':')[0])< 12?
                              Text(widget.date + " , " + widget.time + " AM", style: TextStyle(color: Colors.black, fontSize: 20),)
                                  : Text(widget.date + " , " + widget.time + " PM", style: TextStyle(color: Colors.black, fontSize: 20)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.about, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
                  ),
                ),
                widget.status=='open'?
                InkWell(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (currentContext) => AlertDialog(
                      insetPadding: EdgeInsets.symmetric(vertical: 10),
                      title: Row(
                        children: [
                          Icon(Icons.warning_amber_outlined, color: Colors.redAccent),
                          SizedBox(width: 5,),
                          Text('Close this Job?'),
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
                            await FirebaseFirestore.instance.collection("Employers").doc(user!.uid).collection('Jobs').doc(widget.id).update({'status': 'closed'});
                            await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).update({'status': 'closed'});
                            await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).collection('Applicants').get()
                                .then((QuerySnapshot snapshot) {
                              snapshot.docs.forEach((employer) {
                                FirebaseFirestore.instance.collection('Employees')
                                    .doc(employer.id.replaceAll(widget.id, ''))
                                    .collection('Applications')
                                    .doc(widget.id).update({
                                  'status': 'closed'
                                });
                              });
                            });
                            await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).collection('Applicants').get()
                                .then((QuerySnapshot snapshot) {
                              snapshot.docs.forEach((employer) {
                                FirebaseFirestore.instance.collection('Employees')
                                    .doc(employer.id.replaceAll(widget.id, ''))
                                    .collection('Bookmarks')
                                    .doc(widget.id).update({
                                  'status': 'closed'
                                });
                              });
                            });
                            Navigator.pop(context);
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
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.redAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'CLOSE', style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                )
                    :   InkWell(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (currentContext) => AlertDialog(
                        insetPadding: EdgeInsets.symmetric(vertical: 10),
                        title: Row(
                          children: [
                            Icon(Icons.warning_amber_outlined, color: Colors.yellowAccent),
                            SizedBox(width: 5,),
                            Text('Open this Job again?'),
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
                              await FirebaseFirestore.instance.collection("Employers").doc(user!.uid).collection('Jobs').doc(widget.id).update({'status': 'open'});
                              await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).update({'status': 'open'});
                              await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).collection('Applicants').get()
                                  .then((QuerySnapshot snapshot) {
                                snapshot.docs.forEach((employer) {
                                  FirebaseFirestore.instance.collection('Employees')
                                      .doc(employer.id.replaceAll(widget.id, ''))
                                      .collection('Applications')
                                      .doc(widget.id).update({
                                    'status': 'open'
                                  });
                                });
                              });
                              await FirebaseFirestore.instance.collection('Jobs').doc(widget.id).collection('Applicants').get()
                                  .then((QuerySnapshot snapshot) {
                                snapshot.docs.forEach((employer) {
                                  FirebaseFirestore.instance.collection('Employees')
                                      .doc(employer.id.replaceAll(widget.id, ''))
                                      .collection('Bookmarks')
                                      .doc(widget.id).update({
                                    'status': 'open'
                                  });
                                });
                              });
                              Navigator.pop(context);
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
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    color: Colors.greenAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Text(
                          'OPEN', style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                )
              ]
          ),
        )
            :Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
        ), ),
      ),
    );
  }
}
