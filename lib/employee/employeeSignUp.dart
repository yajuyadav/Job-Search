import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:searchjob/Splash.dart';
import 'package:searchjob/auth_services.dart';
import 'package:searchjob/employee/employeeSignUp2.dart';
import 'package:searchjob/loginscreen.dart';
class employeesignUp extends StatefulWidget {
  @override
  _employeesignUpState createState() => _employeesignUpState();
}

class _employeesignUpState extends State<employeesignUp> {
  DateTime dateTime= DateTime.now().subtract(Duration(days: 6570));
  String exp= '<1 years';
  String _field= 'Marketing';
  List experience= ['<1 years', '1+ years', '3+ years', '5+ years', '10+ years'];
  List field= ['Marketing', 'Management', 'House-cleaning', 'Engineering', 'Plumbing', 'Carpentry', 'Developing','Babysitting', 'Writing', 'Teaching','Cooking', 'Others'];
  final _formkey= GlobalKey<FormState>();
  moveToScreen(BuildContext context, name, dob, field, experience, about) {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      Navigator.push(context,MaterialPageRoute(builder: (context) => employeesignUp2(name, field, experience, about, dob)));
      setState(() {
        isLoading = false;
      });
    } }
  bool isLoading=false;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset("assets/images/background.jpg", fit: BoxFit.fitHeight,),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: isLoading==false?
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _formkey,
                  child: ListView(
                      children :[
                        Container(
                          margin: EdgeInsets.only(top: 50, right: 20, left: 20),
                          child: TextFormField(
                              style: TextStyle(color: Colors.brown),
                              decoration: InputDecoration(
                                labelText: 'Name',
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
                              controller: namecontroller,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Name is not entered";
                                }
                                return null;
                              }
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                              insetPadding: EdgeInsets.symmetric(vertical: 10),
                              title: Text('DOB'),
                              content : SizedBox(
                                height: 220,
                                child: CupertinoDatePicker(
                                  //maximumYear: DateTime.now().subtract(new Duration(days: 6570)).year,
                                  maximumDate:  dateTime,
                                  minimumDate: DateTime.now().subtract(Duration(days: 29200)),
                                  initialDateTime: dateTime,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (dateTime) =>
                                      setState(() => this.dateTime = dateTime),
                                ),
                              ),
                            ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 7, right: 20, left: 20),
                            height: 70,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.brown[600]!,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(14))
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                              Row(
                                children: [
                                  Text('Date of Birth', style: TextStyle(color: Colors.brown[600],),),
                                  SizedBox(width: 5,),
                                  Icon(Icons.navigate_next, color: Colors.brown[500],)
                                ],
                               ),
                                  SizedBox(height: 5,),
                                  Row(children: [
                                    Text('${dateTime.day}  ${dateTime.month}  ${dateTime.year}', style: TextStyle(color: Colors.brown[600], fontSize: 20, fontWeight: FontWeight.bold),)
                                  ])
                               ]
                             ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 7, right: 20, left: 20),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.brown[600]!,
                              ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text('Select Work Field', style: TextStyle(color: Colors.black),),
                                DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  value: _field,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _field= newValue.toString();
                                    }
                                    );
                                  },
                                  items: field.map((valueItem){
                                    return DropdownMenuItem(
                                      value:valueItem,
                                      child: Text(valueItem,
                                        style:TextStyle(color: Colors.brown[600]),
                                      ),
                                    );
                                  }
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 7, right: 20, left: 20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.brown[600]!,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Text('Work Experience', style: TextStyle(color: Colors.black),),
                                DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  value: exp,
                                  onChanged: (newValue) {
                                    setState(() {
                                      exp= newValue.toString();
                                    }
                                    );
                                  },
                                  items: experience.map((valueItem){
                                    return DropdownMenuItem(
                                      value:valueItem,
                                      child: Text(valueItem,
                                        style:TextStyle(color: Colors.brown[600]),
                                      ),
                                    );
                                  }
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 7, right: 20, left: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Write Something About you. It increases your chances of getting hired by the best Employers.', style: TextStyle(color: Colors.black),),
                              ),
                              TextFormField(
                                maxLines: 12,
                                  style: TextStyle(color: Colors.brown),
                                  decoration: InputDecoration(
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
                                controller: aboutcontroller,
                              ),
                            ],
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
                              final String name= namecontroller.text.trim();
                              final String about= aboutcontroller.text.trim();
                              moveToScreen(context, name, dateTime, _field,exp,about );
                            },
                            child: Text(
                              'Continue',
                              style: TextStyle(color: Colors.brown, fontSize: 20 ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 50, right: 50, top: 10),
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
