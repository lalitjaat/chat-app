import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ChatRoom extends StatefulWidget {

  final Map<String, dynamic>? userMap;
  final String? chatRoomId;



  ChatRoom({this.chatRoomId, this.userMap});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage()async{


    if(_message.text.isNotEmpty){
      Map<String,dynamic> messages = {

        "sendby":_auth.currentUser!.displayName,
        "message" :_message.text,
        "time": FieldValue.serverTimestamp()

      };

      setState(() async {
        _message.clear();
        await _firestore.collection("chatroom").doc(widget.chatRoomId).collection("chats").add(messages);

      });

    }else{
      print("enter Some Text");
    }



  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userMap!['name']),
      ),
      body: SingleChildScrollView(child: Column(

        children: [

          Container(
            height: size.height /1.25,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("chatroom").doc(widget.chatRoomId).collection("chats").orderBy("time",descending: false).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){

                if(snapshot.data != null){

                 return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return messages(size, data!);
                    },
                  );

                }else{
                  return Container();
                }

              },
            ),
          ),
          Container(
            height: size.height /10,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 12,
              width: size.width /1.1,
              child: Row(
                children: [
                  Container(
                    height: size.height / 1.5,
                    width: size.width /1.5,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          hintText: "Send Message",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                    ),
                  ),

                  IconButton(onPressed: (){

                    onSendMessage();

                  }, icon: Icon(Icons.send))

                ],
              ),
            ),
          ),
        ],

      )),

    );
  }

  Widget messages(Size size,Map<String,dynamic> ds){

    return Container(
      width: size.width,
      alignment: ds['sendby'] == _auth.currentUser!.displayName ? Alignment.centerRight: Alignment.centerLeft,
      child:Container(
       padding: EdgeInsets.symmetric(vertical: 1,horizontal: 14),
       margin: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
        child: Text(ds["message"],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue
        ),
      )

    );

  }

}
