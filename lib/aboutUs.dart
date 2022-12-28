import 'package:flutter/material.dart';
class aboutUs extends StatefulWidget {
  @override
  _aboutUsState createState() => _aboutUsState();
}

class _aboutUsState extends State<aboutUs> {
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Image.asset("assets/images/background.jpg"),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.brown[500],
                title: Text("About us"),
              ),
              body: isLoading==false?
             Padding(
               padding: const EdgeInsets.all(15.0),
               child: SingleChildScrollView(
                 child: Text('Welcome to SearchJob,\n\nyour number one source for all recruiting the best Employers for your Jobs or getting hired by the top Employees. We are dedicated to giving you the very best of Working experience, with a focus on [three characteristics, ie: dependability, customer service and uniqueness.] ' + '\n\n' +
      'Founded in year 2021 with the Aim to make hiring Employers and getting Employed easier, we created this Application. We hope that you work with utmost decency and work ethics as Proffessionals and keep SearchJob App a safe place for everyone. Any kind of scam/bullying/fraud/unpleasant behavior will not be tolerated on this platform.'
      +'\n\n' +
      'We hope you have a great experience working and recruiting here. If you have any questions or comments, please do not hesitate to contact us.'
   +'\n\n' +
      'Sincerely,' +'\n\n' +
      'team SearchJob,' + '\n\n' +
      '9412837882', style: TextStyle(fontSize: 20),),
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
}