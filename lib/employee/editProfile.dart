import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'as firebase_storage;
import 'package:path/path.dart' as Path;

class editProfile extends StatefulWidget {
  @override
  _editProfileState createState() => _editProfileState();
}

class _editProfileState extends State<editProfile> {
   late String exp;
   late String _field;
  List experience= ['<1 years', '1+ years', '3+ years', '5+ years', '10+ years'];
  List field= ['Marketing', 'Management', 'House-cleaning', 'Engineering', 'Plumbing', 'Carpentry',  'Developing','Babysitting', 'Writing', 'Teaching','Cooking','Others'];
  User?user= FirebaseAuth.instance.currentUser;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController biocontroller = TextEditingController();
  bool isLoading=false;
  late String img;
  final picker = ImagePicker();
  late firebase_storage.Reference ref;
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: (){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.brown[400],
        appBar: AppBar(
          backgroundColor: Colors.brown[500],
          title: Text("Edit Profile"),
        ),
        body: isLoading == false ?
        StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('Employees')
                .doc(user!.uid)
                .snapshots(),
                 builder:
                (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
              }
              DocumentSnapshot doc= snapshot.data!;
              namecontroller.text= doc['name'];
              biocontroller.text= doc['about'];
              _field= doc['field'];
              exp= doc['experience'];
              img= doc['photo'];
              return Container(
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Stack(
                              children:[
                                doc['photo'].substring(0, 6) != "assets" ?
                                CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(doc['photo']),
                                )
                                    : CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(doc['photo']),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 8,
                                  child: InkWell(
                                      onTap: (){
                                        chooseImage();
                                      },
                                      child: buildEditIcon(Colors.blue)),
                                ),
                              ]
                          ),
                        ),
                        Container(
                          margin:  EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(14))
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text('Employee',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),

                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 50, right: 20, left: 20),
                              child: Text(
                                'Name', style: TextStyle(color: Colors.white),
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
                                  child: Icon(Icons.person_outline, color: Colors.white), // myIcon is a 48px-wide widget.
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
                              controller: namecontroller,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Name is not entered";
                                }
                                return null;
                              }
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
                                Text('Select Work Field', style: TextStyle(color: Colors.white),),
                                DropdownButton(
                                  dropdownColor: Colors.brown[200],
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36,
                                  isExpanded: true,
                                  value: _field,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _field= newValue.toString();
                                    });
                                    _field= newValue.toString();
                                  },
                                  items: field.map((valueItem){
                                    return DropdownMenuItem(
                                      value:valueItem,
                                      child: Text(valueItem,
                                        style:TextStyle(color: Colors.white),
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
                                Text('Work Experience', style: TextStyle(color: Colors.white),),
                                DropdownButton(
                                  dropdownColor: Colors.brown[200],
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
                                        style:TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }
                                  ).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                              child: Text(
                                '  Bio', style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 6, right: 20, left: 20),
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
                              controller: biocontroller,
                              validator: (value){
                                if(value!.isEmpty) {
                                  return "Bio is not entered";
                                }
                                return null;
                              }
                          ),
                        ),
                        Container(
                          height: 80,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Email: ${doc['Email']}', style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    'Rated:  ', style: TextStyle(color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                GFRating(
                                  borderColor: Colors.lightBlueAccent,
                                  size: 34.0,
                                  color: Colors.white,
                                  value: doc['rating'],
                                  onChanged: (double rating) {  },
                                  // onChanged: (value) {setState(() {_rating = value;});},
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(20),
                          height: 50,
                          width: double.infinity,
                          child: FlatButton(
                            color: Colors.white30,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                            onPressed: () {
                              setState(() {
                                isLoading=true;
                              });
                              if(namecontroller.text.isNotEmpty && biocontroller.text.isNotEmpty){
                                final String name= namecontroller.text;
                                final String bio= biocontroller.text;
                                update(context,name, bio,  _field, exp); }
                              else if(namecontroller.text.isEmpty && biocontroller.text.isNotEmpty){
                                final String name= doc['name'];
                                final String bio= biocontroller.text;
                                update(context,name, bio, _field, exp); }
                              else if(biocontroller.text.isEmpty && namecontroller.text.isNotEmpty){
                                final String bio= biocontroller.text;
                                final String name= namecontroller.text;
                                update(context,name, bio, _field, exp); }
                              else{
                                final String bio= biocontroller.text;
                                final String name= doc['name'];
                                update(context,name, bio, _field, exp);
                              }
                            },
                            child: Text(
                              'Update',
                              style: TextStyle(color: Colors.brown, fontSize: 20 ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
            : Center(child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[500]!),
        ), ),
      ),
    );
  }
  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white,
    all: 3,
    child: buildCircle(
      color: color,
      all: 4,
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    var file= File(pickedFile!.path);
    var snapshot = await  firebase_storage.FirebaseStorage.instance
        .ref()
        .child('${user!.uid}/${DateTime.now().millisecondsSinceEpoch}')
        .putFile(file);
    //.onComplete;

    var downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      img = downloadUrl;
    });
    setState(() {
      FirebaseFirestore.instance.collection("Employees")
          .doc(user!.uid)
          .update({
        "photo": img
      });
      FirebaseFirestore.instance.collection("users")
          .doc(user!.uid)
          .update({
        "photo": img
      });
      FirebaseFirestore.instance.collection("Employers")
          .get().
      then((QuerySnapshot employers) async {
        employers.docs.forEach((emp) =>
        {
          FirebaseFirestore.instance.collection('Employers')
              .doc(emp.id)
              .collection('Applicants')
              .get()
              .then((QuerySnapshot applicants) async {
            applicants.docs.forEach((appl) =>
            {
              if(appl['uid']== user!.uid){
                FirebaseFirestore.instance.collection('Employers').doc(emp.id)
                    .collection('Applicants')
                    .doc(appl.id)
                    .update({
                  "photo": img
                })
              }
            });
          })
        });
      });
    });
    if (pickedFile.path == null) {
      print('No path recieved.');
    };
  }

  update(context, name, bio, field, exp)  {
    User? user= FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("Employees")
        .doc(user!.uid)
        .update({
      'name': name,
      'field': field,
      'experience': exp,
      'about': bio,
    });
    FirebaseFirestore.instance.collection("users")
        .doc(user.uid)
        .update({
      'name': name,
      'field': field,
      'experience': exp,
      'about': bio,
    });
    FirebaseFirestore.instance.collection("Employers")
        .get().
    then((QuerySnapshot employers) async {
      employers.docs.forEach((emp) =>
      {
        FirebaseFirestore.instance.collection('Employers')
            .doc(emp.id)
            .collection('Applicants')
            .get()
            .then((QuerySnapshot applicants) async {
          applicants.docs.forEach((appl) =>
          {
            if(appl['uid']== user.uid){
              FirebaseFirestore.instance.collection('Employers').doc(emp.id)
                  .collection('Applicants')
                  .doc(appl.id)
                  .update({
                'name': name,
                'field': field,
                'experience': exp,
                'about': bio,
              })
            }
          });
        })
      });
    });
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
  }
}