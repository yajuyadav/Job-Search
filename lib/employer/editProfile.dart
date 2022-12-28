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
        stream: FirebaseFirestore.instance.collection('Employers')
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
          biocontroller.text= doc['bio'];
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
                            CircleAvatar(
                            radius: 80.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                            NetworkImage(img)
                               // : Placeholder(fallbackHeight: 200.0,fallbackWidth: double.infinity),
                          ),
                            Positioned(
                              bottom: 0,
                              right: 8,
                              child: InkWell(
                                  onTap: (){
                                    chooseImage();
                                  },
                                  child: buildEditIcon(Colors.green[600]!)),
                            ),
                          ]
                        ),
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
                        height: 50,
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10, right: 20, left: 20),
                       color: Colors.green[600],
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
                        color: Colors.green[600],
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
                                  borderColor: Colors.green[300],
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
                            update(context,name, bio); }
              else if(namecontroller.text.isEmpty && biocontroller.text.isNotEmpty){
              final String name= doc['name'];
              final String bio= biocontroller.text;
              update(context,name, bio); }
                            else if(biocontroller.text.isEmpty && namecontroller.text.isNotEmpty){
                              final String bio= biocontroller.text;
                              final String name= namecontroller.text;
                              update(context,name, bio); }
                            else{
                              final String bio= biocontroller.text;
                              final String name= doc['name'];
                              update(context,name, bio);
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
        .child(user!.uid)
        .putFile(file);
        //.onComplete;

    var downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      img = downloadUrl;
    });
    setState(() {
      FirebaseFirestore.instance.collection("Employers")
          .doc(user!.uid)
          .update({
        "photo" :img
      });
      FirebaseFirestore.instance.collection("users")
          .doc(user!.uid)
          .update({
        "photo" :img
      });
    });
    if (pickedFile.path == null) {
      print('No path recieved.');
    };
  }

  update(context, String name, String bio)  {
    User? user= FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("Employers")
        .doc(user!.uid)
        .update({
      'name': name,
      'bio': bio,
    });
    FirebaseFirestore.instance.collection("users")
        .doc(user.uid)
        .update({
      'name': name,
      'bio': bio,
    });
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
  }
}
