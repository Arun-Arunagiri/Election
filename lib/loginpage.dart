import 'dart:async';
import 'package:election/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

class Loginpage extends StatelessWidget {
   Loginpage({super.key});

  final String uname = "admin";
  final String password="SuperNova@4724";

  final unamecontroller =TextEditingController();
  final passwordcontroller=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text("MOUNT ZION SILVER JUBILEE SCHOOL ELECTION RESULT",
        style: TextStyle(color: Colors.white,fontSize: 25.0),),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        ),

      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height/3.5,
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color:Color.fromRGBO(250, 207, 33, 0.9),
          ),
          child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(

                      controller: unamecontroller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'User Name',
                        hintText: 'Enter Your Name',

                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                      ),
                    ),
                  ),
                  ElevatedButton(


                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0,bottom: 10.0,left: 20.0,right: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Icon(Icons.login,color: Colors.black,),
                          SizedBox(width: 10.0,),
                          Text("LOGIN",style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.black

                          ),)
                        ],
                      ),
                    ),
                    onPressed: (){
                      if(unamecontroller.text==uname && passwordcontroller.text==password){
                        print("login");
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Homepage()),);
                      }
                     },

                  ),


                ],
              )
          )
        

      ),
      ),
      


    );
  }
}
