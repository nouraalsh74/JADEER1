import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:loading_btn/loading_btn.dart';

import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/theme.dart';
import '../home/homePage.dart';

class RegisteredSuccessfullyPage extends StatefulWidget {
  const RegisteredSuccessfullyPage({Key? key}) : super(key: key);

  @override
  State<RegisteredSuccessfullyPage> createState() => _RegisteredSuccessfullyPageState();
}

class _RegisteredSuccessfullyPageState extends State<RegisteredSuccessfullyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("${ImagePath.registeredSuccessfully}"),
          SizedBox(height: size_H(100),),
          MyLoadingBtn(
            borderRadius: 10,
            width: size_W(250),
            icon: Icon(Icons.arrow_forward_ios , size: 20  , color: Theme_Information.Color_1),
            text: "Go to Home Page",

            callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
              if (btnState == ButtonState.idle) {
                  startLoading();
                  await Future.delayed(const Duration(seconds: 1));
                  // LoginPage
                  print("Done");
                  stopLoading();
                  // HomePage
                  // Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => HomePage()));

                  return;
              }
            },
          ),
        ],
      ),
    );
  }
}
