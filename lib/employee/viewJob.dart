import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:searchjob/employee/viewEmployer.dart';
import 'package:searchjob/employer/applicants.dart';


class viewJob extends StatefulWidget {
  final String title, max, min, timeperiod, timerange, office, city, state, about, date, time, status,id, employer, str;
  int applicants;
  viewJob(this.title,this.max,this.min,this.timeperiod,this.timerange,this.office,this.city,this.state,this.about,this.date,this.time,this.status,this.id,this.applicants, this.employer, this.str);
  @override
  _viewJobState createState() => _viewJobState();
}

class _viewJobState extends State<viewJob> {
  int count=0;
  double _rating= 0.0;
  bool isLoading=false;
  DateTime now= DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        bottomNavigationBar:
        Container(
          width: 100,
          padding: EdgeInsets.only(bottom:5),
          child: isLoading==false? widget.status== 'open'?_buildButton() : buildButton():Container(),
        ) ,
        body:  isLoading==false ?
        Padding(
          padding: const EdgeInsets.only( top: 0),
          child: ListView(
              children: [
               ListTile(
                 tileColor: Colors.grey[400],
                 title: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Text(widget.title, style: TextStyle(fontSize: 20), overflow: TextOverflow.ellipsis,),
                 ),
               ),
                Container(
                  margin: EdgeInsets.only(top: 7, right: 10, left: 10, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.blue[50],
                      border: Border.all(
                        color: Colors.white
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
             Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(widget.about, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),),
          ),
        ),
                      ],
                    ),
                  ),
                ),
                widget.applicants!= -24 && widget.applicants!= -25?
                ListTile(
                  tileColor: Colors.blue[100],
                 title: widget.applicants>=1?
                  Text('${widget.applicants} people have Applied for this Job')
                 : Text('No other Applicants for this Job yet.')
      ) :Container(),
               StreamBuilder<DocumentSnapshot>(
                 stream:  FirebaseFirestore.instance.collection('Employers')
                     .doc(widget.employer)
                     .snapshots(),
                 builder: (context, snapshot) {
                   if (snapshot.hasError) {
                     return Text('Something went wrong');
                   }

                   if (snapshot.connectionState == ConnectionState.waiting) {
                     return Center(child: CircularProgressIndicator(
                         valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
                   }
                   DocumentSnapshot doc= snapshot.data!;
                   return Card(
                     color: Colors.grey[200],
                     shape: RoundedRectangleBorder(
                       side: BorderSide(
                           color: Colors.brown[600]!, width: 2),
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Column(
                       children: [
                         ListTile(
                         title:
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
                               SizedBox(width: 5,),
                               Padding(
                                 padding: const EdgeInsets.all(4.0),
                                 child: Text(doc['name'], style: TextStyle(fontSize: 20),),
                               ),
                               Container(
                                 margin:  EdgeInsets.only(top: 4),
                                 decoration: BoxDecoration(
                                     color: Colors.green[600],
                                     borderRadius: BorderRadius.all(
                                         Radius.circular(14))
                                 ),
                                 child: Padding(
                                   padding: const EdgeInsets.all(4.0),
                                   child: Text('Employer',
                                     style: TextStyle(color: Colors.white,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold),

                                   ),
                                 ),
                               ),
                             ],
                           ),
                           onTap: (){
                           if(widget.str== 'fromjob') {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) =>
                                     viewEmployer(widget.employer, doc['name'],
                                         doc['photo'])));
                           }
                           else{
                             Navigator.pop(context);
                           }
                           },
                         ),
                         Container(
                           margin: EdgeInsets.only(top: 5),
                           decoration: BoxDecoration(
                               color: Colors.green,
                               borderRadius: BorderRadius.all(
                                   Radius.circular(10))
                           ),
                           width: double.infinity,
                           child: Padding(
                             padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                       ],
                     ),
                   );
                 }
               ),
              ]
          ),
        )
            :Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
        ), ),
      ),
    );
  }
  Widget _buildButton() {
    User? user= FirebaseAuth.instance.currentUser;
    bool isLoading=false;
    return isLoading==false?
        widget.applicants!= -24 && widget.applicants!=-25?
    StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Employees')
            .doc(user!.uid)
            .collection('Applications')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snap) {
          if (snap.hasError) {
            return Text('Something went wrong');
          }

          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
          }
          return Container(
            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
            height: 60,
            width: 90,
            child: FlatButton(
                color: Colors.brown[400],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () async {
                  if(snap.data!.exists== false) {
                    setState(() {
                      isLoading=true;
                    });
                    await FirebaseFirestore.instance.collection('Employees').doc(user.uid).get().then((employe){
                      FirebaseFirestore.instance.collection('Employers')
                          .doc(widget.employer)
                          .collection('Applicants')
                          .doc(user.uid+ widget.id)
                          .set({
                        'bookmark': false,
                        'jobtitle': widget.title,
                        'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
                        'uid' : user.uid,
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
                 /*     FirebaseFirestore.instance.collection('Employers')
                          .doc(widget.employer)
                          .collection('Jobs')
                          .doc(widget.id)
                          .update({
                        'applicants': widget.applicants +1,
                      }); */
                      FirebaseFirestore.instance.collection('Employers')
                          .doc(widget.employer)
                          .collection('Jobs')
                          .doc(widget.id)
                          .collection('applicants')
                          .doc(user.uid+ widget.id)
                          .set({
                        'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
                        'uid' : user.uid,
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
                          .doc(widget.id)
                          .collection('Applicants')
                          .doc(user.uid+ widget.id)
                          .set({
                        'Date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
                        'uid' : user.uid,
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
                   /*   FirebaseFirestore.instance.collection('Jobs')
                          .doc(widget.id)
                          .update({
                        'applicants': widget.applicants+1,
                      }); */
                    });
                    FirebaseFirestore.instance.collection('Employees')
                        .doc(user.uid)
                        .collection('Applications')
                        .doc(widget.id)
                        .set({
                      'employer': widget.employer,
                      'applicants': widget.applicants,
                      'title': widget.title,
                      'min': widget.min,
                      'max': widget.max,
                      'timeperiod': widget.timeperiod,
                      'range': widget.timerange,
                      'office': widget.office,
                      'city': widget.city,
                      'state': widget.state,
                      'about': widget.about,
                      'status': widget.status,
                      'date': widget.date,
                      'time': widget.time,
                      'id': widget.id
                    });

                     setState(() {
                      isLoading=false;
                    });}
                  else{
                    setState(() {
                      isLoading=true;
                    });
                    FirebaseFirestore.instance.collection('Employers')
                        .doc(widget.employer)
                        .collection('Applicants')
                        .doc(user.uid+ widget.id)
                        .delete();
                    FirebaseFirestore.instance.collection('Employers')
                        .doc(widget.employer)
                        .collection('Jobs')
                        .doc(widget.id)
                        .collection('applicants')
                        .doc(user.uid+ widget.id)
                        .delete();
                  /*  FirebaseFirestore.instance.collection('Employers')
                        .doc(widget.employer)
                        .collection('Jobs')
                        .doc(widget.id)
                        .update({
                      'applicants': widget.applicants-1,
                    }); */
                    FirebaseFirestore.instance.collection('Jobs')
                        .doc(widget.id)
                        .collection('Applicants')
                        .doc(user.uid+ widget.id)
                        .delete();

                  /*  FirebaseFirestore.instance.collection('Jobs')
                        .doc(widget.id)
                        .update({
                      'applicants': widget.applicants-1,
                    }); */
                    FirebaseFirestore.instance.collection('Employees')
                        .doc(user.uid)
                        .collection('Applications')
                        .doc(widget.id)
                        .delete();
                    setState(() {
                      isLoading=false;
                    });
                  }
                  if(FirebaseFirestore.instance.collection('Jobs').doc(widget.id).collection('Applicants').get()!= null)
                  {
                 FirebaseFirestore.instance.collection('Jobs')
                  .doc(widget.id).collection('Applicants')
                  .get().then((QuerySnapshot value) {
                    FirebaseFirestore.instance.collection('Jobs')
                        .doc(widget.id).update({
                      'applicants': value.size
                    });
                    FirebaseFirestore.instance.collection('Employers')
                        .doc(widget.employer)
                        .collection('Jobs')
                        .doc(widget.id)
                        .update({
                      'applicants': value.size,
                    });
                    FirebaseFirestore.instance.collection('Employees')
                        .doc(user.uid)
                        .collection('Applications')
                        .doc(widget.id)
                        .update({
                      'applicants': value.size,
                    });
                 }); }
                  else{
                    FirebaseFirestore.instance.collection('Jobs')
                        .doc(widget.id).collection('Applicants')
                        .get().then((QuerySnapshot value) {
                      FirebaseFirestore.instance.collection('Jobs')
                          .doc(widget.id).update({
                        'applicants': 0
                      });
                      FirebaseFirestore.instance.collection('Employers')
                          .doc(widget.employer)
                          .collection('Jobs')
                          .doc(widget.id)
                          .update({
                        'applicants': 0,
                      });
                      FirebaseFirestore.instance.collection('Employees')
                          .doc(user.uid)
                          .collection('Applications')
                          .doc(widget.id)
                          .update({
                        'applicants': 0,
                      });
                    });
                  }
                },
                child: snap.data!.exists== true?
                Text('Withdraw', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                )
                    :  Text('Apply', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                )
            ),
          );
        }
    )  :widget.applicants== -25?
        StreamBuilder<DocumentSnapshot>(
          stream:  FirebaseFirestore.instance
              .collection('Employers')
              .doc(widget.employer)
              .collection('Reviews')
              .doc(user!.uid+ widget.id)
              .snapshots(),
          builder: (context, sna) {
            if (sna.hasError) {
              return Text('Something went wrong');
            }

            if (sna.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
            }
            return sna.data!.exists== true? Container( height: 2,)
                : Container(
              height: 40,
              width: double.infinity,
              child: FlatButton(
                color: Colors.brown[200],
                //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                onPressed: () {
                 rate();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Write a Review',
                        style: TextStyle(color: Colors.white, fontSize: 18, ),
                      ),
                      Icon(Icons.navigate_next, color: Colors.white,)
                    ],
                  ),
                ),
              ),
            );
          }
        )
        : Container(
          margin: EdgeInsets.only(top: 5, left: 5, right: 5),
          height: 60,
      width: double.infinity,
      child: FlatButton(
        color: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          setState(() {
            isLoading=true;
          });
          FirebaseFirestore.instance.collection('Employers')
              .doc(widget.employer)
              .collection('Employees')
              .doc(user!.uid+widget.title)
              .update({
            'current': 'done',
          });

            FirebaseFirestore.instance.collection('Employees')
                .doc(user.uid)
                .collection('Jobs')
                .doc(widget.id)
                .update({
              'current': 'done',
            });
          setState(() {
            isLoading=false;
          });
          Navigator.pop(context);
        },
        child: Text(
          'Finish working here',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
        ),
      ),)
        :Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
    ), );
  }
  Widget buildButton() {
    User? user= FirebaseAuth.instance.currentUser;
    bool isLoading=false;
    return isLoading==false?
    StreamBuilder<DocumentSnapshot>(
      stream:  FirebaseFirestore.instance.collection('Employees')
        .doc(user!.uid)
        .collection('Applications')
        .doc(widget.id)
        .snapshots(),
    builder: (context, snap) {
    if (snap.hasError) {
    return Text('Something went wrong');
    }

    if (snap.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown)));
    }
        return Container(
                margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                height: 60,
                width: 90,
                child: FlatButton(
                    color: Colors.brown[200],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () async {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text('The Job was closed by the Employer.')));
                    },
                    child: snap.data!.exists== true?
                    Text('Withdraw', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                    )
                        :  Text('Apply', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                    )
                ),
              );
      }
    )
        :Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
    ), );
  }
  rate() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 10),
        title: Row(
          children: [
            Icon(Icons.star_rate, color: Colors.brown[600]),
            SizedBox(width: 5,),
            Text('Ratings '),
          ],
        ),
        content:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFRating(
            borderColor: Colors.lightBlueAccent,
            size: 34.0,
            color: Colors.blue,
            value: _rating,
            onChanged: (value) async {
              setState(() {
                isLoading= true;
              });
              setState(() {
                _rating = value;
              });
              Navigator.pop(context);
              rate();
              setState(() {
                isLoading= false;
              });
            },
          ),
        ),
        actions: [
          FlatButton(onPressed: (){
            Navigator.pop(context);
            review(_rating);
          }, child: Text('Continue'))
        ],
      ),
    );
  }
  review(rate) async {
    double total= 0.0;
    User? user= FirebaseAuth.instance.currentUser;
    DateTime now= DateTime.now();
    TextEditingController reviewcontroller = TextEditingController();
    await showDialog(
      context: context,
      builder: (currentContext) => AlertDialog(
        insetPadding: EdgeInsets.symmetric(vertical: 10),
        title: Row(
          children: [
            Icon(Icons.rate_review_outlined, color: Colors.brown[600]),
            SizedBox(width: 5,),
            Text('Write a Review'),
          ],
        ),
        content:  TextFormField(
          maxLines: 8,
          style: TextStyle(color: Colors.brown, fontSize: 20),
          decoration: InputDecoration(
            hintText: 'Review',
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.brown, width: 2.0),
            ),
            labelStyle: TextStyle(color: Colors.white),
            prefix: Padding(
              padding: EdgeInsets.all(4),
            ),
          ),
          controller: reviewcontroller,

        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              FirebaseFirestore.instance.collection('Employers')
                  .doc(widget.employer)
                  .collection('Reviews')
                  .doc(user!.uid+ widget.id)
                  .set({
                'employee': user.uid,
                'rating': rate,
                'review': reviewcontroller.text,
                'job': widget.id,
                'jobtitle': widget.title,
                'date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
                'time': now.hour.toString() + ':' + (now.minute/10).toString().replaceAll('.', ''),
              });
              await FirebaseFirestore.instance.collection("Employers")
                  .doc(widget.employer)
                  .collection('Reviews')
                  .get().
              then((QuerySnapshot snapShot) async {
                snapShot.docs.forEach((review) async => {
                  total= total+ review['rating'],
                  FirebaseFirestore.instance.collection('Employers').doc(widget.employer)
                      .update({
                    'rating': total/snapShot.docs.length
                  }),
                });
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Your Review was Submitted')));
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}