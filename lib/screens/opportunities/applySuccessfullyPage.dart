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

class ApplySuccessfullyPage extends StatefulWidget {
  final String oppTitle ;
  const ApplySuccessfullyPage({Key? key , required this.oppTitle}) : super(key: key);
  @override
  State<ApplySuccessfullyPage> createState() => _ApplySuccessfullyPageState();
}

class _ApplySuccessfullyPageState extends State<ApplySuccessfullyPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Stack(
            children: [
              Image.asset(ImagePath.doneApply),
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: size_H(70)),
                        Text("Successfully Applied to" , style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 22)),
                        SizedBox(height: size_H(10)),
                        Text("${widget.oppTitle}", style: ourTextStyle(color: Theme_Information.Color_1)),
                        SizedBox(height: size_H(30)),

                        Image.asset(ImagePath.checkDoneApply , scale: 4),

                      ],
                    ),
                  )
              ),

            ],
          ),
          SizedBox(height: size_H(100),),
          MyLoadingBtn(
            borderRadius: 10,
            width: size_W(250),
            icon: Icon(Icons.arrow_forward_ios , size: 20  , color: Theme_Information.Color_1),
            text: "Go Back",

            callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {


              if (btnState == ButtonState.idle) {
                User? user = FirebaseAuth.instance.currentUser;
                  startLoading();
                  if(user != null){
                    Map<String, dynamic>? userData =
                    await Provider.of<UserProvider>(context, listen: false).getUserData(user.uid);
                    await Provider.of<OpportunityProvider>(context, listen: false).initOpportunity(context) ;
                    String jsonString = jsonEncode(userData);
                    UserProfile userProfile = userProfileFromJson(jsonString);
                    await Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);
                    print("Done");
                    stopLoading();
                    // HomePage

                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);

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
