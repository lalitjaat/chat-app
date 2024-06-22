import 'package:chat_app_flutter/create_accoutnt.dart';
import 'package:chat_app_flutter/firebase/methods.dart';
import 'package:chat_app_flutter/ui/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    
    final size = MediaQuery.of(context).size;
    
    return Scaffold(

      body: isLoading? Center(

        child: Container(

          child: CircularProgressIndicator(),
        ),

      ) : SingleChildScrollView(
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
              child: Text("Sign to Continue",style: TextStyle(
                color: Colors.grey[700],fontSize: 25,
                fontWeight: FontWeight.w500,
              ),),

            ),

            SizedBox(height: size.height / 10,),

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

            SizedBox(height: size.height / 40,),

            GestureDetector(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => CreateAccountPage()));
              },
              child: Text("Create Account",style: TextStyle(color: Colors.blue
              ,fontSize: 16,fontWeight: FontWeight.w500),),
            ),

          ],
        ),
      ),

    );
  }

  Widget field(Size size,String hintTxt,IconData icon,TextInputType inputType,bool IsHide,TextEditingController controller){

    return Container(

      height: size.height / 15,
      width: size.width / 1.1,
      child: TextField(
        controller: controller,
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

        if(_email.text.isNotEmpty && _password.text.isNotEmpty){

          setState(() {

            isLoading = true;

          });

          login(_email.text, _password.text).then((value) {

            if(value != null){
              setState(() {
                isLoading = false;
              });
              print("Login Successfull");
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => HomeScreen()));
            }else{
              setState(() {
                isLoading = false;
              });
              print("Login Failed");
            }

          });

        }else{
          print("Please Enter Field");
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
        child: Text("Login",style: TextStyle(
          color: Colors.white,fontSize: 22,fontWeight: FontWeight.bold
        ),)


      ),
    );

  }

}
