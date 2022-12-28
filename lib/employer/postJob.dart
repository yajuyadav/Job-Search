import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchjob/employer/employerSignUp.dart';
class postJobs extends StatefulWidget {
  @override
  _postJobsState createState() => _postJobsState();
}

class _postJobsState extends State<postJobs> {
  List time= ['Days', 'Months', 'Years'];
  String timerange= 'Days';
  String _field= 'Marketing';
  List field= ['Marketing', 'Management', 'House-cleaning', 'Engineering', 'Plumbing', 'Carpentry',  'Developing','Babysitting', 'Writing', 'Teaching','Cooking','Others'];
  final _formkey= GlobalKey<FormState>();
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  TextEditingController titleController = TextEditingController();
  TextEditingController minSalaryController = TextEditingController();
  TextEditingController maxSalaryController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController rangeController = TextEditingController();
  TextEditingController officeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[500],
        title: Text("Post a Job"),
      ),
      body: isLoading==false?
      SizedBox(
          child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Form(
                    key: _formkey,
                    child: Column(
                        children :[
                          Container(
                            margin: EdgeInsets.only(top: 30, right: 20, left: 20),
                            child: TextFormField(
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  labelText: 'Job Title',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                ),
                                controller: titleController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "This Field can't be empty";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                  child: Text(' Salary', style: TextStyle(color: Colors.white, fontSize: 20),)
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 10,left: 20),
                                child: TextFormField(
                                    style: TextStyle(color: Colors.brown),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      prefixText: '₹ ',
                                      labelText: 'Min ₹',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                                      ),
                                      labelStyle: TextStyle(color: Colors.brown),
                                    ),
                                    controller: minSalaryController,
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "This Field can't be empty";
                                      }
                                      return null;
                                    }
                                ),
                              ),
                              Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.brown),
                                    decoration: InputDecoration(
                                      prefixText: '₹ ',
                                      labelText: 'Max ₹',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                                      ),
                                      labelStyle: TextStyle(color: Colors.brown),
                                    ),
                                    controller: maxSalaryController,
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "This Field can't be empty";
                                      }
                                      return null;
                                    }
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                  child: Text(' Category', style: TextStyle(color: Colors.white, fontSize: 20),)
                              ),
                            ],
                          ),
                           Padding(
                            padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: DropdownButton(
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
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                  child: Text(' Time Period', style: TextStyle(color: Colors.white, fontSize: 20),)
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 150,
                                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                child: TextFormField(
                                    style: TextStyle(color: Colors.brown),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                                      ),
                                      labelStyle: TextStyle(color: Colors.brown),
                                    ),
                                    controller: timeController,
                                    validator: (value){
                                      if(value!.isEmpty) {
                                        return "This Field can't be empty";
                                      }
                                      return null;
                                    }
                                ),
                              ),
                              Container(
                                width: 130,
                                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                child: DropdownButton(
                                  dropdownColor: Colors.white,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  value: timerange,
                                  onChanged: (newValue) {
                                    setState(() {
                                      timerange= newValue.toString();
                                    }
                                    );
                                  },
                                  items: time.map((valueItem){
                                    return DropdownMenuItem(
                                      value:valueItem,
                                      child: Text(valueItem,
                                        style:TextStyle(color: Colors.brown[600]),
                                      ),
                                    );
                                  }
                                  ).toList(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                                child: Text(' Address', style: TextStyle(color: Colors.white, fontSize: 20),)
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4, right: 20, left: 20),
                            child: TextFormField(
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  labelText: 'Office ',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                ),
                                controller: officeController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "This Field can't be empty";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3, right: 20, left: 20),
                            child: TextFormField(
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  labelText: 'City ',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                ),
                                controller: cityController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "This Field can't be empty";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 3, right: 20, left: 20),
                            child: TextFormField(
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  labelText: 'State ',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                ),
                                controller: stateController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "This Field can't be empty";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                                child: Container(
                                    child: Text(' Give details about the job.', style: TextStyle(color: Colors.white, fontSize: 20),)
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                            child: TextFormField(
                                maxLines: 10,
                                style: TextStyle(color: Colors.brown),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.brown, width: 2.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                                  ),
                                  labelStyle: TextStyle(color: Colors.brown),
                                ),
                                controller: aboutController,
                                validator: (value){
                                  if(value!.isEmpty) {
                                    return "This Field can't be empty";
                                  }
                                  return null;
                                }
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            margin: EdgeInsets.all(20),
                            height: 50,
                            width: double.infinity,
                            child: FlatButton(
                              color: Colors.brown[500],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              onPressed: () {
                                final String title= titleController.text.trim();
                                final String min= minSalaryController.text.trim();
                                final String max= maxSalaryController.text.trim();
                                final String time= timeController.text.trim();
                                final String range= rangeController.text.trim();
                                final String office= officeController.text.trim();
                                final String city= cityController.text.trim();
                                final String state= stateController.text.trim();
                                final String about= aboutController.text.trim();
                                addJob(context,title,min,max,time,timerange,office,city,state,about, _field);
                              },
                              child: Text(
                                'Post',
                                style: TextStyle(color: Colors.white60, fontSize: 20 ),
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
    );
  }

  addJob(BuildContextcontext, String title, String min, String max, String time, String range, String office, String city, String state, String about, String category) async {
    if (_formkey.currentState!.validate()) {
      DateTime now= new DateTime.now();
      setState(() {
        isLoading=true;
      });
      await FirebaseFirestore.instance.collection('Employers')
      .doc(user!.uid)
      .collection('Jobs')
      .add({
        'applicants': 0,
        'title': title,
        'min': min,
        'max': max,
        'timeperiod': time,
        'category': category,
        'range': range,
        'office': office,
        'city': city,
        'state': state,
        'about': about,
        'status': 'open',
        'date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
        'time': now.hour.toString() + ':' + (now.minute/10).toString().replaceAll('.', ''),
      }).then((value){
       FirebaseFirestore.instance.collection('Jobs')
            .doc(value.id)
            .set({
          'id': value.id,
         'applicants': 0,
          'title': title,
          'min': min,
          'max': max,
          'timeperiod': time,
          'range': range,
         'category': category,
          'office': office,
          'city': city,
          'state': state,
          'about': about,
          'status': 'open',
         'employer': user!.uid,
         'date': now.day.toString()+ '/' + now.month.toString() + '/' + now.year.toString(),
         'time': now.hour.toString() + ':' + (now.minute/10).toString().replaceAll('.', ''),
        });
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Job added")));
      Navigator.pop(context);
      setState(() {
        isLoading=false;
      });
    }
  }
}