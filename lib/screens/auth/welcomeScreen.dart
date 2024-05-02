import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';
import 'package:flutter_application_2/screens/home/homePage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/images.dart';
import '../../main.dart';
import '../../models/opportunityModel.dart';
import '../../models/mentorsModel.dart';
import '../../models/userProfileModel.dart';
import '../../providers/opportunityProvider.dart';
import '../../providers/userProvider.dart';
import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  User? user ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      user = FirebaseAuth.instance.currentUser;
      setState(() {});
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: size_H(30)),
            SizedBox(
                height: size_H(220),
                child: Image.asset(ImagePath.box_welcome_big )),


            SizedBox(height: size_H(30)),
            SizedBox(
                // height: size_H(250),
                child: Image.asset(ImagePath.logoWithTitle )),

            SizedBox(height: size_H(80)),
            MyLoadingBtn(
              text: "Get Started",
              callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {



                if (btnState == ButtonState.idle) {
                  startLoading();
                  await Future.delayed(const Duration(seconds: 1));

                  checkUserLoginStatus(stopLoading);
                  // stopLoading();
                }
        
        
              },
            ),
            SizedBox(height: size_H(10)),
            Image.asset(ImagePath.box_welcome , scale: 3, ),
            SizedBox(height: size_H(20)),

          if(user == null)
          InkWell(
            onTap: (){
              Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => LoginPage()));
            },
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text("Already have an account? " , style: ourTextStyle(fontWeight: FontWeight.w500),),
              Text("Sign in" , style: ourTextStyle(color: Theme_Information.Primary_Color ,fontWeight: FontWeight.w500),)
              ],
            ),
          ),



          ],
        ),
      ),
    );
  }



  Future<void> checkUserLoginStatus(stopLoading) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in
      print('User is logged in with UID: ${user.uid}');

      Map<String, dynamic>? userData = await Provider.of<UserProvider>(context , listen: false).getUserData(user.uid);

          // log("User Data: $userData");
      String jsonString = jsonEncode(userData);
      UserProfile userProfile = userProfileFromJson(jsonString);
      await  Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);
      await Provider.of<OpportunityProvider>(context, listen: false).initOpportunity(context) ;
      stopLoading();
      Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => HomePage()));


    } else {
      // User is not logged in
      print('User is not logged in');
      stopLoading();
      Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => LoginPage()));

    }
  }


  Future addDataToFirebase(String collectionName, List<String> data) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (String item in data) {
      // Get a reference to a new document with an auto-generated ID
      DocumentReference documentReference = firestore.collection(collectionName).doc();

      // Use the document ID as the ID for each record
      await documentReference.set({
        'id': documentReference.id,
        'name': item,
      });
    }

    print('Items added to Firestore successfully!');
  }

  Future addDataToFirebaseModel(String collectionName, List<Mentor> mentors) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Use the document ID as the ID for each record
      for (Mentor mentor in mentors) {
        // Get a reference to a new document with an auto-generated ID
        DocumentReference documentReference = firestore.collection(collectionName).doc();

        await documentReference.set({
          'id': documentReference.id,
          'name': mentor.name,
          'image': mentor.image,
          'major': mentor.major,
          'company': mentor.company,
          'description': mentor.description,
          'socialMedia': mentor.socialMedia,
        });
      }

    print('Items added to Firestore successfully!');
  }


  Future addDataToFirebaseOpportunities(String collectionName, List<Opportunity> opp) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Use the document ID as the ID for each record
    // for (Opportunity _opp in opp) {
    //   // Get a reference to a new document with an auto-generated ID
    //   DocumentReference documentReference = firestore.collection(collectionName).doc();
    //
    //   await documentReference.set({
    //     'id': documentReference.id,
    //     'title': _opp.title,
    //     'industry': _opp.industry,
    //     'company': _opp.company,
    //     'description': _opp.description,
    //     'requirements': _opp.requirements,
    //     'location': _opp.location,
    //     'availability': _opp.availability,
    //     'deadline': _opp.deadline,
    //     'opportunity_type': _opp.opportunity_type,
    //   });
    // }

    for (Opportunity opportunity in opp) {
      // Get a reference to a new document with an auto-generated ID
      DocumentReference documentReference = firestore.collection(collectionName).doc();

      await documentReference.set({
        'id': documentReference.id,
        ...opportunity.toMap(), // Use the toMap method to convert Opportunity to Map
      });
    }


    print('Items added to Firestore successfully!');
  }

}
