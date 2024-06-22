
import 'package:chat_app_flutter/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<User?> createAccount(String name,String emailEt, String passwordEt) async{

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  try{

    user = (await _auth.createUserWithEmailAndPassword(email: emailEt, password: passwordEt)).user;

    if(user != null){
      print("Account Creation Success");

      user.updateProfile(displayName: name);

      await _firestore.collection("users").doc(_auth.currentUser!.uid).set({

        "name":name,
        "email":emailEt,
        "status":"Unavailable"

      });
      
      return user!;
    }else{
      print("Account Creation Failed");
      return user!;
    }

  }catch(e){
    print(e);
    return null;
  }


}

Future<User?> login(String emailEt, String passwordEt) async{

  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  try{

    user = (await _auth.signInWithEmailAndPassword(email: emailEt, password: passwordEt)).user;

    if(user != null){
      print("Login Success");
      return user!;
    }else{
      print(" Login Failed");
      return user!;
    }

  }catch(e){
    print(e);
    return null;
  }


}

Future<User?> logout(BuildContext context) async{

  FirebaseAuth _auth = FirebaseAuth.instance;

  try{
    await _auth.signOut().then((value) {

      Navigator.push(context,MaterialPageRoute(builder: (_) => LoginPage()));

    });
  }catch(e){
    print(e.toString());
  }


}