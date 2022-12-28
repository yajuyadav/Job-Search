import 'package:flutter/material.dart';
class help2 extends StatefulWidget {
  @override
  _help2State createState() => _help2State();
}

class _help2State extends State<help2> {
  final _formkey= GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController querycontroller = TextEditingController();
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
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
                  padding: const EdgeInsets.only(top: 60.0, left: 20, right: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                       Center(child: Icon(Icons.check_circle, color: Colors.green, size: 200,)),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text('Thank you for writing to us. We will get back to you shortly.', style: TextStyle(color: Colors.brown, fontSize: 20, fontWeight: FontWeight.bold),),
                          ),
                        )
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
      ),
    );
  }
}