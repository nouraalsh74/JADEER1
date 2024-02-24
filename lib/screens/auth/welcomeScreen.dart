import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';
import 'package:flutter_application_2/screens/home/homePage.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/images.dart';
import '../../models/mentorsModel.dart';
import '../../models/userProfileModel.dart';
import '../../providers/userProvider.dart';
import 'loginScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
                child: Image.asset(ImagePath.logo )),
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
        
            SizedBox(height: size_H(20)),

            // MyLoadingBtn(
            //   text: "Upload Data",
            //   callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
            //     if (btnState == ButtonState.idle) {
            //       startLoading();
            //
            //       // List<Mentor> mentors = [
            //       //   Mentor(
            //       //     name: 'Nadia Alhussain',
            //       //     image: 'https://media.licdn.com/dms/image/D5603AQEdxjKm5vxVFQ/profile-displayphoto-shrink_800_800/0/1683253430034?e=2147483647&v=beta&t=Tq4ezYR2fUG9ECkaQDfTOIrYUl2fIAPTdfeHjGXQcDI',
            //       //     major: 'Human Resources',
            //       //     company: 'General Manager in MEP',
            //       //     description: 'Nadia Alhussain, an accomplished HR professional, is a mentor known for her strategic insight and empathetic guidance. With a proven track record in talent development and organizational growth, Nadia is dedicated to empowering individuals and fostering a positive work culture.',
            //       //     socialMedia: {
            //       //       'Phone': '+966XXXXXXXXX',
            //       //       'LinkedIn': 'NadiaAlhussain',
            //       //       'FaceBook': 'Nadia_Alhussain',
            //       //       'Email': 'Nadia_Alhussain@outlook.com',
            //       //       'Instagram' : '',
            //       //     },
            //       //   ),
            //       //   Mentor(
            //       //     name: 'Abdullah Alqahtani',
            //       //     image: 'https://cdn.openart.ai/stable_diffusion/20bf8d8b80ef5b05d76f4ce396d4b664467fddac_2000x2000.webp',
            //       //     major: 'Information Systems',
            //       //     company: 'General Manager in MEP',
            //       //     description: 'Nadia Alhussain, an accomplished HR professional, is a mentor known for her strategic insight and empathetic guidance. With a proven track record in talent development and organizational growth, Nadia is dedicated to empowering individuals and fostering a positive work culture.',
            //       //     socialMedia: {
            //       //       'Phone': '+966XXXXXXXXX',
            //       //       'LinkedIn': 'AbdullahAlqahtani',
            //       //       'FaceBook': 'Abdullah_Alqahtani',
            //       //       'Email': 'Abdullah Alqahtani@outlook.com',
            //       //       'Instagram' : '',
            //       //     },
            //       //   ),
            //       //   Mentor(
            //       //     name: 'Leen Aleissa',
            //       //     image: '',
            //       //     major: 'Accounting',
            //       //     company: 'General Manager in MEP',
            //       //     description: 'Nadia Alhussain, an accomplished HR professional, is a mentor known for her strategic insight and empathetic guidance. With a proven track record in talent development and organizational growth, Nadia is dedicated to empowering individuals and fostering a positive work culture.',
            //       //     socialMedia: {
            //       //       'Phone': '+966XXXXXXXXX',
            //       //       'LinkedIn': 'Leen_Aleissa',
            //       //       'FaceBook': 'LeenAleissa',
            //       //       'Email': 'Leen Aleissa@outlook.com',
            //       //       'Instagram' : '',
            //       //     },
            //       //   ),
            //       // ];
            //       // await  addDataToFirebaseModel("mentors", mentors);
            //       // // await  addDataToFirebase("cities_temp", locations);
            //
            //       stopLoading();
            //     }
            //
            //
            //   },
            // ),

        
            SizedBox(height: size_H(10)),
            Image.asset(ImagePath.box_welcome , scale: 3, ),
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
      log("User Data: $userData");
      String jsonString = jsonEncode(userData);
      UserProfile userProfile = userProfileFromJson(jsonString);
      await  Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);
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
}
