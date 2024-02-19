import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../commonWidgets/myLoadingBtn.dart';
import '../../configuration/images.dart';
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
                  // LoginPage
                  Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => LoginPage()));
                  stopLoading();
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
            //       // List<String> locations = [
            //       //   "Year",
            //       //   "Month"
            //       // ];
            //       // await  addDataToFirebase("durations", locations);
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
}
