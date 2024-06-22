import 'package:chat_app_flutter/firebase/methods.dart';
import 'package:chat_app_flutter/ui/chatRoom.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isLoading = false;
  TextEditingController _controller = TextEditingController();
  Map<String,dynamic>? usermap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String chatRoomId(String? user1,String? user2){

    if(user1![0].toLowerCase().codeUnits[0] > user2![0].toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }


  }

  void onSearch() async{
    FirebaseFirestore _firebase = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firebase.collection("users").where("email",isEqualTo: _controller.text).get().then((value) {

      setState(() {
        usermap = value.docs[0].data();
        isLoading = false;
      });

      print(usermap);

    });
    

  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;



    return Scaffold(
      appBar: AppBar(title: Text("Chat App"),
      actions: [
        IconButton(onPressed: (){
          logout(context);
        }, icon: Icon(Icons.logout))
      ],),
      body: isLoading?Center(

        child: Container(
          child: CircularProgressIndicator(),
        ),

      ): Column(

        children: [

          SizedBox(height: size.height / 20,),

          Container(

            height: size.height/14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width /1.2,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ),



          ),


          SizedBox(height: size.height/50,),
          ElevatedButton(onPressed:onSearch, child: Text(
            "Search"
          )),

          SizedBox(height: size.height /30,),

          usermap != null? ListTile(

            onTap: (){

              String roomId = chatRoomId(_auth.currentUser!.displayName, usermap!['name']);

              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoom(chatRoomId: roomId,userMap: usermap)));

            },
            leading: Icon(Icons.account_box,color: Colors.black,),
            title: Text(usermap!['name'], style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500),),
            subtitle: Text(usermap!['email']),
            trailing: Icon(Icons.chat,color: Colors.black,),
          ):Container(),

        ],

      ),
    );
  }

}
