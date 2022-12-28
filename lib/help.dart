import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchjob/help2.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/smtp_server.dart';
class help extends StatefulWidget {
  @override
  _helpState createState() => _helpState();
}

class _helpState extends State<help> {
  final _formkey= GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController querycontroller = TextEditingController();
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Image.asset("assets/images/background.jpg"),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.brown[500],
                title: Text("Help"),
              ),
              backgroundColor: Colors.transparent,
              body: isLoading==false?
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(child: Text('WE ARE ALWAYS HERE TO HELP YOU!!   WRITE TO US.', style: TextStyle(color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),)),
                            ),

                          ),
                          Container(
                            height: 475,
                            child: Card(
                              color: Colors.white60,
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white, width: 4),
                                borderRadius: BorderRadius.circular(80),
                              ),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 50, right: 20, left: 20),
                                          child: Text(
                                            'Enter your Email', style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                      child: TextFormField(
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                          decoration: InputDecoration(
                                            prefixIcon: Padding(
                                              padding: const EdgeInsetsDirectional.only(start: 12.0),
                                              child: Icon(Icons.mail_outlined, color: Colors.white), // myIcon is a 48px-wide widget.
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                                            ),
                                            labelStyle: TextStyle(color: Colors.white),
                                            prefix: Padding(
                                              padding: EdgeInsets.all(4),
                                            ),
                                          ),
                                          controller: emailcontroller,
                                          validator: (value){
                                            if(value!.isEmpty) {
                                              return "This field is important.";
                                            }
                                            return null;
                                          }
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                          child: Text(
                                            '  Tell us your Query', style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 6, right: 20, left: 20, ),
                                      child: TextFormField(
                                          maxLines: 8,
                                          style: TextStyle(color: Colors.white, fontSize: 20),
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.white, width: 2.0),
                                            ),
                                            labelStyle: TextStyle(color: Colors.white),
                                            prefix: Padding(
                                              padding: EdgeInsets.all(4),
                                            ),
                                          ),
                                          controller: querycontroller,
                                          validator: (value){
                                            if(value!.isEmpty) {
                                              return "This field is important.";
                                            }
                                            return null;
                                          }
                                      ),
                                    ),
                                    Container( height: 50,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20,right: 20, left: 20,),
                                        child: FlatButton(
                                          color: Colors.brown[600],
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          onPressed: () {
                                         if (_formkey.currentState!.validate()) {
                                           setState(() {
                                             isLoading= true;
                                           });
                                           final String email= emailcontroller.text;
                                           final String query= querycontroller.text;
                                           sendMail(email, query);
                                           Navigator.push(context,MaterialPageRoute(builder: (context) => help2()));
                                           setState(() {
                                             isLoading=false;
                                           });
                                         }
                                          },
                                          child: Text(
                                            'SEND',
                                            style: TextStyle(color: Colors.white60, fontSize: 20, fontWeight: FontWeight.bold ),
                                          ),
                                        ),
                                      ),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Center(child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
              ), ),
            )
          ]
      ),
    );
  }
  sendMail(email,query) async {
    User? user= FirebaseAuth.instance.currentUser;
    String username = '1900300100252@ipec.org.in';
    String password = 'Me\$12345';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add('yajuyadavv@gmail.com')
//      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
//      ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = 'HELP REQUEST FROM USER: ${email} :: 😀 :: ${DateTime.now()}'
      ..text = ''
      ..html = "<h1>Write a reply to the user having the following Query.</h1>\n<p>${query}</p>\n<p>Regards,</p>\n<p>Team SearchJob.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
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