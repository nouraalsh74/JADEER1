import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/theme.dart';
import '../../models/userProfileModel.dart';
import '../../providers/opportunityProvider.dart';
import '../../providers/userProvider.dart';
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
                User? user = FirebaseAuth.instance.currentUser;
                  startLoading();
                  if(user != null){
                    Map<String, dynamic>? userData =
                    await Provider.of<UserProvider>(context, listen: false)
                        .getUserData(user.uid);
                    await Provider.of<OpportunityProvider>(context, listen: false).initOpportunity(context) ;
                    String jsonString = jsonEncode(userData);
                    UserProfile userProfile = userProfileFromJson(jsonString);
                    await Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);
                    print("Done");
                    stopLoading();
                    // HomePage
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePage()),
                            (Route<dynamic> route) => false);

                    return;
                  }
              }
            },
          ),
        ],
      ),
    );
  }
}
