import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchjob/Splash.dart';
import 'package:searchjob/auth_services.dart';
import 'package:searchjob/reset.dart';
import 'package:searchjob/userRole.dart';
class loginscreen extends StatefulWidget {
  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {

  final _formkey= GlobalKey<FormState>();

  moveToScreen(BuildContext context, email, password) {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      context.read<AuthService>().login(email, password, ).then((value) async{
        if (value== "Logged In") {
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
    }
  }
  bool isLoading=false;
  TextEditingController _controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image.asset("assets/images/background.jpg"),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: isLoading==false?
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Card(
                      margin:  EdgeInsets.only(top: 120, left: 10, right: 10),
                      color: Colors.brown[300],
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.brown[300]!, width: 4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Form(
                          key: _formkey,
                          child: Column(
                              children: [
                                Container(
                                  color: Colors.brown[400],
                                  margin: EdgeInsets.only(top: 90, right: 20, left: 20),
                                  child: TextFormField(
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsetsDirectional.only(start: 12.0),
                                          child: Icon(Icons.mail_outlined, color: Colors.white,), // myIcon is a 48px-wide widget.
                                        ),
                                        labelText: 'E-mail',
                                        hintStyle: TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.brown[400]!, width: 3.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 3.0),
                                        ),
                                        labelStyle: TextStyle(color: Colors.white),
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
                                  color: Colors.brown[400],
                                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                  child: TextFormField(
                                      obscureText: true,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        prefixIcon: Padding(
                                          padding: const EdgeInsetsDirectional.only(start: 12.0),
                                          child: Icon(Icons.vpn_key_outlined, color: Colors.white,), // myIcon is a 48px-wide widget.
                                        ),
                                        labelText: 'Password',
                                        hintStyle: TextStyle(color: Colors.white),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.brown[400]!, width: 3.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white, width: 3.0),
                                        ),
                                        labelStyle: TextStyle(color: Colors.white),
                                        prefix: Padding(
                                          padding: EdgeInsets.all(4),
                                        ),
                                      ),
                                      controller: _controller,
                                      validator: (value){
                                        if(value!.isEmpty) {
                                          return "Password is not entered";
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
                                    color: Colors.white12,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                                    onPressed: () {
                                      final String password= _controller.text.trim();
                                      final String email= _emailController.text.trim();

                                      moveToScreen(context, email, password);
                                    },
                                    child: Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white, fontSize: 20 ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50, right: 50, top: 50),
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => userRole()));
                                    },
                                    child: Text("Not Registered yet? Register now. ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 60),
                                  width: double.infinity,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,MaterialPageRoute(builder: (context) => ResetPage()));
                                    },
                                    child: Text("Forgot Password?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ]
                          )
                      ),
                    )
                )
            )
                : Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
            ), ),
          )
        ],
      ),
    );
  }
}
