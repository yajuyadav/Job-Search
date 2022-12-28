import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';
import 'package:searchjob/chatPage.dart';
import 'package:searchjob/employee/employeeReviews.dart';
import 'package:searchjob/employee/jobsDone.dart';
import 'package:searchjob/employer/applicants.dart';
import 'package:searchjob/employer/viewJob.dart';

class viewEmployee extends StatefulWidget {
  final String uid, name, photo, email, job, about, field, experience, id;
  final int age;
  final double rating;
  viewEmployee(this.uid, this.name, this.photo, this.email, this.job, this.age, this.about,this.field,this.experience,this.rating, this.id);
  @override
  _viewEmployeeState createState() => _viewEmployeeState();
}

class _viewEmployeeState extends State<viewEmployee> {
  int count=0;
  final String str= 'employer';
  double _rating= 0.0;
  User? user= FirebaseAuth.instance.currentUser;
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
        Text('  '+widget.name, overflow: TextOverflow.ellipsis,),
      ],
    ),
    ),
      bottomNavigationBar: Container(
        //height: 120,
        width: 100,
        //margin: EdgeInsets.symmetric(horizontal: 10),
       // padding: EdgeInsets.only(bottom: 5),
        child: isLoading==false? _buildButton() : Container(),
      ),
    body: isLoading==false?
        StreamBuilder<DocumentSnapshot>(
          stream:  FirebaseFirestore.instance.collection('Employees')
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
                    child: Text(doc['about'],  style: TextStyle(color: Colors.black54, fontSize: 20),),
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
                            child: Text('AGE ', style: TextStyle(color: Colors.black, fontSize: 20),),
                          )),
                      Text('   '+ doc['age'].toString(), style: TextStyle(color: Colors.black54, fontSize: 18),),
                    ],
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
                        child: Text('FIELD ', style: TextStyle(color: Colors.black, fontSize: 20),),
                      )),
                      Text('   '+ doc['field'], style: TextStyle(color: Colors.black54, fontSize: 18),),
                    ],
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
                            child: Text('EXPERIENCE ', style: TextStyle(color: Colors.black, fontSize: 20),),
                          )),
                      Text('   '+ doc['experience'], style: TextStyle(color: Colors.black54, fontSize: 18),),
                    ],
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
                    title: Text('Jobs Done', style: TextStyle(color: Colors.black, fontSize: 20),),
                    trailing:  Icon(Icons.navigate_next, color: Colors.black,),
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context) => jobsDone(str, widget.uid)));
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
                      Navigator.push(context,MaterialPageRoute(builder: (context) => employeeReviews(str, widget.uid)));
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: GFRating(
                      borderColor: Colors.lightBlueAccent,
                      size: 34.0,
                      color: Colors.white,
                      value: doc['rating'],
                      onChanged: (double rating) {  },
                      // onChanged: (value) {setState(() {_rating = value;});},
                    ),
                  ),
                ),
                widget.job!= widget.name?
                StreamBuilder<DocumentSnapshot>(
                  stream:  FirebaseFirestore.instance.collection('Employers')
                      .doc(user!.uid)
                      .collection('Employees')
                      .doc(widget.uid+widget.job)
                      .snapshots(),
                  builder: (context, sn) {
                    if (sn.hasError) {
                      return Text('Something went wrong');
                    }

                    if (sn.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                    }
                    return sn.data!.exists== true?
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance.collection('Jobs')
                          .doc(widget.id)
                          .snapshots(),
                        builder: (context, snp) {
                          if (snp.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snp.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                          }
                          DocumentSnapshot job= snp.data!;
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
                              child: Text('Job: ' + job['title'],
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  double.parse(job['time'].split(':')[0])< 12?
                                  Text('Posted: '+ job['date'] + " , " + job['time'] + " AM")
                                      : Text('Posted: '+ job['date'] + " , " + job['time'] + " PM"),
                                ],
                              ),
                            ),
                            trailing: Text(
                              job["status"].toUpperCase(), style: TextStyle(color: job['status']== 'open'? Colors.green : Colors.redAccent, fontSize: 26),
                            ),
                          ),
                    );
                        }
                      ) :Container();
                  }
                )
                    :Container()
              ],
            );
          }
        )
        : Center(child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
    )),
    ));
  }
  Widget _buildButton() {
    User? user= FirebaseAuth.instance.currentUser;
    bool isLoading=false;
    return isLoading==false?
        widget.job!= widget.name?
    StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('Employers')
          .doc(user!.uid)
          .collection('Employees')
          .doc(widget.uid+widget.job)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
        }
        DocumentSnapshot emp= snapshot.data!;
        return snapshot.data!.exists== true?
        emp['current']== 'hired'?
          Container(
            margin: EdgeInsets.only(bottom: 6),
          height: 70,
          width: double.infinity,
          child: FlatButton(
            color: Colors.redAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () {
              setState(() {
                isLoading=true;
              });
              FirebaseFirestore.instance.collection('Employers')
                  .doc(user.uid)
                  .collection('Employees')
                  .doc(widget.uid+widget.job)
                  .update({
                'current': 'done',
              });
              FirebaseFirestore.instance.collection('Employers')
                  .doc(user.uid)
                  .collection('Jobs')
                  .doc(widget.id)
                  .get().then((doc){
                FirebaseFirestore.instance.collection('Employees')
                    .doc(widget.uid)
                    .collection('Jobs')
                    .doc(widget.id)
                    .update({
                  'current': 'done',
                });
              });
              setState(() {
                isLoading=false;
              });
            },
            child: Text(
              'End Job Period',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
            ),
          ),
        )
        :StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
          .collection('Employees')
          .doc(widget.uid)
          .collection('Reviews')
          .doc(user.uid+ widget.id)
          .snapshots(),
          builder: (context, snp) {
            if (snp.hasError) {
              return Text('Something went wrong');
            }

            if (snp.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
            }
            return Container(
              height: snp.data!.exists== true? 70 : 120,
              width: double.infinity,
              child: ListView(
                  children: [
                    snp.data!.exists== true?
                        Container()
                  : InkWell(
                      onTap: () async {
                       rate();
                      },
                    child: Container(
                width: double.infinity,
                color: Colors.brown[200],
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Text('Write a Review', style: TextStyle(color: Colors.white, fontSize: 18),),
                        Icon(Icons.navigate_next, color: Colors.white,)
                      ],
                    ),
                ),
              ),
                  ),
                    FlatButton(
                    color: Colors.brown[600],
                    height: 70,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () {

                        Navigator.push(context,MaterialPageRoute(builder: (context) => chatPage(user.uid, widget.uid)));
                    },
                    child: Text(
                      'Contact',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
                    ),
              ),
                  ],
                ),
            );
          }
        )
            : Container(
          margin: EdgeInsets.only(bottom: 6, left: 12, right: 12),
          height: 70,
          width: double.infinity,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context,MaterialPageRoute(builder: (context) => chatPage(user.uid, widget.uid)));
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.brown[600],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all( 10),

                    child: Center(child: Text("Contact", style: TextStyle(fontSize: 20, color: Colors.white),)),

                  ),
                ),
              ),
              InkWell(
                onTap:() async {
                  await showDialog(
                      context: context,
                      builder: (currentContext) => AlertDialog(
                    insetPadding: EdgeInsets.symmetric(vertical: 10),
                    title: Row(
                      children: [
                        Icon(Icons.check, color: Colors.lightBlueAccent),
                        SizedBox(width: 5,),
                        Text('Hire ${widget.name} for this Job? '),
                      ],
                    ),
                          content: Text('An Email will be sent to the Employee informing their Recruitment.'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('No'),
                      ),
                      FlatButton(
                        onPressed: () async {
                          setState(() {
                            isLoading=true;
                          });
                          Navigator.pop(context);
                         sendMail();
                         Navigator.pop(context);
                         Navigator.pop(context);
                         Navigator.pop(context);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                  );
                },
                child: Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,),
                  child: Padding(
                    padding: const EdgeInsets.all( 10),
                    child: Center(child: Text("Hire", style: TextStyle(fontSize: 20, color: Colors.black54),)),

                  ),
                ),
              ),
            ],
          ),
        );
      }
    ) : Container(
          margin: EdgeInsets.only(bottom: 6),
          height: 70,
          width: double.infinity,
          child: FlatButton(
            color: Colors.brown[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onPressed: () {
              Navigator.push(context,MaterialPageRoute(builder: (context) => chatPage(user!.uid, widget.uid)));
            },
            child: Text(
              'Contact',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),
            ),
          ),)
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
          borderColor: Colors.green,
          size: 34.0,
          color: Colors.green[800],
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
            FirebaseFirestore.instance.collection('Employees')
                .doc(widget.uid)
                .collection('Reviews')
                .doc(user!.uid+ widget.id)
                .set({
              'employer': user.uid,
              'rating': rate,
              'review': reviewcontroller.text,
              'job': widget.id,
              'jobtitle': widget.job,
              'date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
              'time': now.hour.toString() + ':' + (now.minute/10).toString().replaceAll('.', ''),
            });
            await FirebaseFirestore.instance.collection("Employees")
                .doc(widget.uid)
                .collection('Reviews')
                .get().
            then((QuerySnapshot snapShot) async {
              snapShot.docs.forEach((review) async => {
              total= total+ review['rating'],
              FirebaseFirestore.instance.collection('Employees').doc(widget.uid)
                  .update({
              'rating': total/snapShot.docs.length
              }),
              await FirebaseFirestore.instance.collection("Employers")
                  .doc(user.uid)
                  .collection('Applicants')
                  . get ().
              then((QuerySnapshot snap) async {
              snap.docs.forEach((emp) => {
                if(emp.id.startsWith(widget.uid)){
              FirebaseFirestore.instance.collection('Employers').doc(user.uid).collection('Applicants').doc(emp.id)
                  .update({
              'rating': total/snapShot.docs.length
              }) }
              });
              }),
              await FirebaseFirestore.instance.collection("Employers")
                    .doc(user.uid)
                    .collection('Employees')
                    . get ().
                then((QuerySnapshot sn) async {
                  sn.docs.forEach((emp) => {
                    if(emp.id.startsWith(widget.uid)){
                      FirebaseFirestore.instance.collection('Employers').doc(user.uid).collection('Employees').doc(emp.id)
                          .update({
                        'rating': total/snapShot.docs.length
                      }) }
                  });
                })
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

  sendMail() async {
    User? user= FirebaseAuth.instance.currentUser;
    String username = '1900300100252@ipec.org.in';
    String password = 'Me\$12345';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(widget.email)
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'Job: ${widget.job} :: 😀 :: ${DateTime.now()}'
      ..text = 'Dear ${widget.name},\nCongratulations!! You Are Hired!!'
      ..html = "<h1>Congratulations!! You Are Hired!!</h1>\n<p>Dear ${widget.name},</p>\n<p>We are extremely happy to inform you that your Application for the job [${widget.job}] was accepted and now you are hired for the same. We hope that you have the best experience working with your employer and we expect you to carry your work with all due discipline. All the best!</p>\n<p>Regards,</p>\n<p>Team SearchJob.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      FirebaseFirestore.instance.collection('Employers')
      .doc(user!.uid)
      .collection('Employees')
      .doc(widget.uid+widget.job)
      .set({
        'current': 'hired',
        'id': widget.uid+widget.job,
        'uid' : widget.uid,
        'name' : widget.name,
        'photo' : widget.photo,
        'field': widget.field,
        'experience': widget.experience,
        'about': widget.about,
        'age': widget.age,
        'Email': widget.email,
        'rating': widget.rating,
        'jobId': widget.id
      });
      FirebaseFirestore.instance.collection('Employers')
      .doc(user.uid)
      .collection('Jobs')
      .doc(widget.id)
      .get().then((doc){
        FirebaseFirestore.instance.collection('Employees')
            .doc(widget.uid)
            .collection('Jobs')
            .doc(widget.id)
            .set({
          'current': 'hired',
          'employer': user.uid,
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
      });
      FirebaseFirestore.instance.collection('Employees')
      .doc(widget.uid)
      .collection('Applications')
      .doc(widget.id).delete();
      FirebaseFirestore.instance.collection('Employers')
          .doc(user.uid)
          .collection('Applicants')
          .doc(widget.uid+ widget.id).delete();
      FirebaseFirestore.instance.collection('Employers')
          .doc(user.uid)
          .collection('Jobs')
          .doc(widget.id)
          .collection('applicants')
          .doc(widget.uid+ widget.id).delete();
      FirebaseFirestore.instance.collection('Jobs')
          .doc(widget.id)
          .collection('Applicants')
          .doc(widget.uid+ widget.id).delete();
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
              .doc(user.uid)
              .collection('Jobs')
              .doc(widget.id)
              .update({
            'applicants': value.size,
          });
          FirebaseFirestore.instance.collection('Employees')
              .doc(widget.uid)
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
              .doc(user.uid)
              .collection('Jobs')
              .doc(widget.id)
              .update({
            'applicants': 0,
          });
          FirebaseFirestore.instance.collection('Employees')
              .doc(widget.uid)
              .collection('Applications')
              .doc(widget.id)
              .update({
            'applicants': 0,
          });
        });
      }
      setState(() {
        isLoading=false;
      });
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e.toString());
      print(password);
      setState(() {
        isLoading=false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("COULD NOT PROCESS REQUEST. PLEASE TRY AGAIN")));
    }
  }
}
