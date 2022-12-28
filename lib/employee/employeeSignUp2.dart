import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchjob/Splash.dart';
import 'package:searchjob/auth_services.dart';
import 'package:searchjob/loginscreen.dart';
class employeesignUp2 extends StatefulWidget {
  final String name, field, experience, about;
  final DateTime dob;
  employeesignUp2(this.name,this.field, this.experience, this.about, this.dob);
  @override
  _employeesignUp2State createState() => _employeesignUp2State();
}
class _employeesignUp2State extends State<employeesignUp2> {
  final _formkey= GlobalKey<FormState>();
  moveToScreen(BuildContext context, email, password, name, field, experience, about, dob) {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      context.read<AuthService>().signUp(email, password,).then((value) async{
        if (value== "Signed in") {
          User? user= FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance.collection("users").doc(user!.uid)
              .set({
            'uid' : user.uid,
            'name' : name,
            'photo' : "assets/images/background.jpg",
            'role' : "employee",
            'field': field,
            'experience': experience,
            'about': about,
            'dob': dob,
            'age': DateTime.now().year- dob.year,
            'Email': email,
            'rating': 0.0,
          });
          await FirebaseFirestore.instance.collection("Employees").doc(user.uid)
              .set({
            'uid' : user.uid,
            'name' : name,
            'photo' : "assets/images/background.jpg",
            'Email': email,
            'field': field,
            'experience': experience,
            'about': about,
            'dob': dob,
            'age': DateTime.now().year- dob.year,
            'rating': 0.0
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Splash()),
                  (route) => false);
          setState(() {
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value!)));
        }
      });
    } }
  bool isLoading=false;
  TextEditingController _controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/background.jpg"),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading==false?
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(
                        children :[
                          Container(
                            margin: EdgeInsets.only(top: 100, right: 20, left: 20),
                            child: TextFormField(
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                                    child: Icon(Icons.mail_outlined, color: Colors.brown), // myIcon is a 48px-wide widget.
                                  ),
                                  labelText: 'E-mail',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                  prefix: Padding(
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),
                                controller: _emailController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "E-mail is not entered";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                                    child: Icon(Icons.vpn_key_outlined, color: Colors.brown), // myIcon is a 48px-wide widget.
                                  ),
                                  labelText: 'Password',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                  prefix: Padding(
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),
                                controller: _controller,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "Password is not entered";
                                  } else if(value.length<8){
                                    return "Password should atleast be 8 characters long";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 7, right: 20, left: 20),
                            child: TextFormField(
                                obscureText: true,
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsetsDirectional.only(start: 12.0),
                                    child: Icon(Icons.vpn_key_outlined, color: Colors.brown), // myIcon is a 48px-wide widget.
                                  ),
                                  labelText: 'Confirm Password',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                  prefix: Padding(
                                    padding: EdgeInsets.all(4),
                                  ),
                                ),

                                validator: (value){
                                  if(value != _controller.text) {
                                    return "Passwords doesn't match";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            height: 50,
                            width: 300,
                            child: FlatButton(
                              color: Colors.white60,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              onPressed: () {
                                final String email= _emailController.text.trim();
                                final String password= _controller.text.trim();
                                moveToScreen(context, email, password, widget.name, widget.field, widget.experience, widget.about, widget.dob);
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.brown, fontSize: 20 ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 50, right: 50, top: 50),
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) => loginscreen()));
                              },
                              child: Text("Already have an account? Log In. ",
                                style: TextStyle(color: Colors.brown),
                              ),
                            ),
                          ),
                        ]
                    )
                ),
              )
          )
              : Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
          ), ),
        )
      ],
    );
  }
}
