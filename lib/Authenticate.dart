import 'package:chat_app_flutter/login_screen.dart';
import 'package:chat_app_flutter/ui/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate extends StatelessWidget {

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    if(_auth.currentUser != null){
      return HomeScreen();
    }else{
      return LoginPage();
    }
  }
}
