import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class chatPage extends StatefulWidget{
  String myId, uId;
  chatPage(this.myId, this.uId);
  @override
  _chatPageState createState() => _chatPageState();
}

class _chatPageState extends State<chatPage> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    _controller.clear();
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.myId)
        .collection('chats')
        .doc(widget.uId)
        .set({
      'id': widget.myId
    });
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.uId)
        .collection('chats')
        .doc(widget.myId)
        .set({
      'id': widget.myId
    });
    await FirebaseFirestore.instance.collection('users')
    .doc(widget.myId)
    .collection('chats')
    .doc(widget.uId)
    .collection('messages')
    .add({
        'message': message,
        'sender': widget.myId,
        'sentTime': DateTime.now()
      });
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.uId)
        .collection('chats')
        .doc(widget.myId)
        .collection('messages')
        .add({
      'message': message,
      'sender': widget.myId,
      'sentTime': DateTime.now()
    });
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.myId)
        .collection('chats')
        .doc(widget.uId)
        .update({
      'lastMessageTime': DateTime.now()
    });
    await FirebaseFirestore.instance.collection('users')
        .doc(widget.uId)
        .collection('chats')
        .doc(widget.myId)
        .update({
      'lastMessageTime': DateTime.now()
    });
  }
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.brown[600],
      body: isLoading==false?
          SafeArea(child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users')
              .doc(widget.uId)
              .snapshots(),
            builder: (context, snapshot) {
              DocumentSnapshot doc= snapshot.data!;
              return Column(
                children: [
                Container(
                height: 80,
                padding: EdgeInsets.all(16).copyWith(left: 0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(color: Colors.white),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                color: Colors.brown[600],
                                child: doc['photo'].substring(0, 6) != "assets" ?
                                CircleAvatar(
                                  radius: 23.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(doc['photo']),
                                )
                                    : CircleAvatar(
                                  radius: 23.0,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: AssetImage(doc['photo']),
                                ),
                              ),
                              SizedBox(width: 4,),
                              Text(
                                doc['name'],
                                style: TextStyle(
                                  fontSize: 23,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 4),
                      ],
                    )
                  ],
                ),
              ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
              child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users')
              .doc(widget.myId)
              .collection('chats')
              .doc(widget.uId)
              .collection('messages')
              .orderBy('sentTime', descending: true)
              .snapshots(),
              builder: (context, snapshot) {
              switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              default:
              if (snapshot.hasError) {
              return Text('Something Went Wrong Try later');
              } else {
              final messages = snapshot.data;

              return messages!.size==0
              ? Container(
                width: double.infinity,
                  child: Center(child: Text('Say Hi....', style: TextStyle(color: Colors.black38, fontWeight: FontWeight.bold, fontSize: 20),)))
                    : ListView.builder(
              physics: BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages.size,
              itemBuilder: (context, index) {
              final message = messages.docs[index];

              return Row(
                mainAxisAlignment: message['sender']== widget.myId ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.all(16),
                      constraints: BoxConstraints(maxWidth: 240),
                      decoration: BoxDecoration(
                        color: message['sender']== widget.myId ? Colors.grey[100] : Colors.brown[600],
                        borderRadius: message['sender']== widget.myId
                            ? BorderRadius.all(Radius.circular(12)).subtract(BorderRadius.only(bottomRight: Radius.circular(12)))
                            : BorderRadius.all(Radius.circular(12)).subtract(BorderRadius.only(bottomLeft: Radius.circular(12))),
                      ),
                      child:Column(
                        crossAxisAlignment:
                        message['sender']== widget.myId  ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            message['message'],
                            style: TextStyle(color: message['sender']== widget.myId  ? Colors.black : Colors.white),
                            textAlign: message['sender']== widget.myId  ? TextAlign.end : TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                ],
              );
              },
              );
              }
              }
              },
              ), ),
                  ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textCapitalization: TextCapitalization.sentences,
                          autocorrect: true,
                          enableSuggestions: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            labelText: 'Type your message',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.brown, width: 2.0),
                              gapPadding: 10,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelStyle: TextStyle(color: Colors.brown),
                          ),
                          onChanged: (value) => setState(() {
                            message = value;
                          }),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: message.trim().isEmpty ? null : sendMessage,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.brown,
                          ),
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
                ],
              );
            }
          )
          )
          : Center(child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.brown[300]!),
      ), ),
    );
  }
}