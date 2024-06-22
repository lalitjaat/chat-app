import 'package:chat_app_flutter/login_screen.dart';
import 'package:chat_app_flutter/ui/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'firebase/methods.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return  Scaffold(

      body: isLoading? Center(child: Container(
      child: CircularProgressIndicator(),
      )


        ,): SingleChildScrollView(
        child: Column(
          children: [

            SizedBox(height: size.height /15,),
            Container(
              width: size.width / 1.1,
              alignment: Alignment.centerLeft,
              child: IconButton(onPressed: (){

              }, icon: Icon(Icons.arrow_back_ios)),
            ),

            SizedBox(height: size.height /50,),
            Container(
              width: size.width / 1.1,
              child: Text("Welcome",style: TextStyle(fontSize: 28,fontWeight:
              FontWeight.bold),),
            ),


            Container(

              width: size.width / 1.1,
              child: Text("Create Account to Continue",style: TextStyle(
                color: Colors.grey[700],fontSize: 20,
                fontWeight: FontWeight.w500,
              ),),

            ),

            SizedBox(height: size.height / 20,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child:  field(size, "Name",Icons.account_box,TextInputType.emailAddress,false,_name),
              ),
            ),



            Container(
              width: size.width,
              alignment: Alignment.center,
              child:  field(size, "email",Icons.account_box,TextInputType.emailAddress,false,_email),
            ),


            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Container(
                width: size.width,
                alignment: Alignment.center,
                child:  field(size, "Password",Icons.lock,TextInputType.text,true,_password),
              ),
            )
            ,
            SizedBox(height: size.height /10,),
            customButton(size),

            SizedBox(height: size.height / 20,),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (_)=> LoginPage()));
                },
                child: Text("Log In",style: TextStyle(color: Colors.blue,
                fontSize: 16,fontWeight: FontWeight.w500),),
              ),
            ),

          ],
        ),
      ),

    );
  }


  Widget field(Size size,String hintTxt,IconData icon,TextInputType inputType,bool IsHide,TextEditingController cont){

    return Container(

      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: cont,
        keyboardType: inputType,
        obscureText: IsHide == true? true:false,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintTxt,
          hintStyle: const TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          ),
        ),
      ),

    );

  }


  Widget customButton(Size size){

    return GestureDetector(
      onTap: (){

        if(_name.text.isNotEmpty && _email.text.isNotEmpty && _password.text.isNotEmpty){

          setState(() {
            isLoading = true;
          });

          createAccount(_name.text,_email.text,_password.text).then((user){

            if(user != null){
              setState(() {
                isLoading = false;
              });
              print("Login Successful");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
            }else{
              isLoading = false;
              print("Login Failed");
            }

          });
        }else{
          print("Please enter Fields");
        }

      },
      child: Container(

          height: size.height / 14,
          width: size.width / 1.2,
          decoration: BoxDecoration(
            borderRadius:  BorderRadius.circular(10),
            color: Colors.blue,
          ),
          alignment: Alignment.center,
          child: Text("Create Account",style: TextStyle(
              color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold
          ),)


      ),
    );

  }

}
