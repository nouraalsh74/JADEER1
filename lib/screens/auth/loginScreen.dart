import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/configuration/theme.dart';
import 'package:flutter_application_2/screens/auth/firstRegistrationScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_btn/loading_btn.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../home/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size_H(30),),
          const BackIcon(),

          TitleSubTitleText(
            title: "Welcome back,",
            subTitle: "Sign in your account",
          ),
          SizedBox(height: size_H(40),),
          MyTextForm(
            controller: _email,
            title: "Email",
            hint: "Enter Email",
          ),
          SizedBox(height: size_H(20),),
          MyTextForm(
            controller: _password,
            isPassword: true,
            isSuffixIcon: true,
            title: "Password",
            hint: "Enter Password",
          ),
          SizedBox(height: size_H(10),),
          InkWell(onTap: (){},
              child: Text("Forget your password?", style: ourTextStyle(color: Theme_Information.Primary_Color, fontSize: 12, fontWeight: FontWeight.w500),)),

          SizedBox(height: size_H(20),),
          MyLoadingBtn(
            borderRadius: 30,
            width:  size_W(120),
            text: "Sign In",
            callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
              // LoginPage
              // Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => LoginPage()));
              if (btnState == ButtonState.idle) {

              }



            },
          ),

          SizedBox(height: size_H(20),),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don’t Have An Account?", style: ourTextStyle(color: Theme_Information.Color_7, fontSize: 17, fontWeight: FontWeight.w300),),
              SizedBox(width: size_H(2),),
              InkWell(onTap: (){
                // RegistrationScreen
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => RegistrationScreenStep1()));

              },
                  child: Text("Sign Up", style: ourTextStyle(color: Theme_Information.Primary_Color, fontSize: 17, fontWeight: FontWeight.w300),)),
            ],
          ),


        ],
      ),
    );
  }

}


