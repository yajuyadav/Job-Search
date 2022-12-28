import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchjob/chatPage.dart';

class messages extends StatefulWidget {
  @override
  _messagesState createState() => _messagesState();
}

class _messagesState extends State<messages> {
  User? user= FirebaseAuth.instance.currentUser;
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
        child: Scaffold(
          body: isLoading == false
              ? SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: 42,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 2, left: 2),
                      child: Row(
                        children: [
                          Text('Messages  ', style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold, fontSize: 20),),
                          Icon(Icons.messenger_outline, color: Colors.brown[400],)
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection('users')
                          .doc(user!.uid)
                          .collection("chats")
                          .orderBy('lastMessageTime', descending: true)
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
                        return snapshot.data!.size>0?
                          Expanded(
                          child: SingleChildScrollView(
                            child: ListView(
                              shrinkWrap: true,
                              physics: new ClampingScrollPhysics(),
                              children: snapshot.data!.docs.map((doc)
                              {
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection('users')
                                    .doc(doc.id)
                                    .snapshots(),
                                  builder: (context, snap) {
                                    if (snap.hasError) {
                                      return Text('Something went wrong');
                                    }

                                    if (snap.connectionState == ConnectionState.waiting) {
                                      return Center(child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!)));
                                    }
                                    DocumentSnapshot document= snap.data!;
                                    return Card(
                                      color: Colors.grey[300]!,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.brown, width: 2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Row(
                                            children: [
                                              document['photo'].substring(0, 6) != "assets" ?
                                              CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: NetworkImage(document['photo']),
                                              )
                                                  : CircleAvatar(
                                                radius: 30.0,
                                                backgroundColor: Colors.transparent,
                                                backgroundImage: AssetImage(document['photo']),
                                              ),
                                              SizedBox(width: 4,),
                                              Text(document['name'],
                                                style: TextStyle(color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        onTap: (){
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => chatPage(user!.uid, document['uid'])));
                                        },
                                      ),
                                    );
                                  }
                                );
                              }).toList(),
                            ),
                          ),

                        )
                            :Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 80,
                            child: ListTile(
                              tileColor: Colors.black12,
                              leading: Icon(Icons.messenger_outline_outlined, size: 70,),
                              title: Text('No Previous Messages to Show.'),
                            ),
                          ),
                        );
                      }
                  ),
                ],
              )
          )
              : Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[600]!),
          )),
        )
    );
  }
}

