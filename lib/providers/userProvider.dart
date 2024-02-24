import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../models/userProfileModel.dart';


class UserProvider with ChangeNotifier{
  // notifyListeners();
  UserProfile? userProfile ;
  setUserProfile(UserProfile data){
    userProfile = data ;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userDoc.data();
    } catch (e) {
      print("Error retrieving user data: $e");
      throw e; // Throw the error to handle it in the UI
    }
  }

  Future<bool?> registerUser(String email, String password , Map<String, dynamic> userData , filePathCV) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Access user information
      User? user = userCredential.user;
      if(user != null){
        if(filePathCV != null){
          /// Upload the file to Firebase Storage
          String downloadUrl = await uploadFile(filePathCV! , "${user.uid}");
          /// Save the download URL to Cloud Firestore
          // saveToFirestore(downloadUrl);
          userData["cv_path"] = downloadUrl ;
        }
        await saveUserData("${user.uid}" , userData)!.then((value) {
          print("Done_5 ${value}");
          // return value ;
        });
        return true ;
      }
      // print('User registered: ${user!.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The email address is already in use by another account.');
        EasyLoading.showError('The email address is already in use by another account.');
        return null;
      } else {
        print('Error registering user: ${e.message}');
        EasyLoading.showError('Error registering user: ${e.message}');
        return null;
      }
    } catch (e) {
      print('Error registering user: $e');
      EasyLoading.showError('Error registering user: $e');
      // Handle generic errors
      return null;
    }
    // return null;
  }

  Future<bool?> updateUserData(String uid, Map<String, dynamic> updatedData) async {
    try {
      // Reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Update specific fields in the user document
      await userRef.update(updatedData);

      print('User data updated successfully!');
      return true ;
    } catch (e) {
      print('Error updating user data: $e');
      return false ;
    }
  }

  Future<bool?> updatePasswordinDatabase(String newPassword) async {
    try {
      // Reference to the user document
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(userProfile!.userId);

      // Update specific fields in the user document
      // Update a single field in the user document
      await userRef.update({"password": newPassword});

      print('User data updated successfully!');
      return true ;
    } catch (e) {
      print('Error updating user data: $e');
      return false ;
    }
  }


  Future<String> uploadFile(String filePath , String userId) async {
    File file = File(filePath);

    try {
      // Generate a unique name for the file including user ID, date, and time
      String fileName = '$userId-${DateTime.now().toIso8601String()}.pdf';

      firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref().child('cv').child(fileName);

      await storageReference.putFile(file);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return '';
    }
  }


  Future<bool?>? saveUserData(String uid, Map<String, dynamic> userData) async {
    try{
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'first_name': userData['first_name'],
        'last_name': userData['last_name'],
        'ID': userData['ID'],
        'user_id' : uid,
        'email': userData['email'],
        'phone_number': userData['phone_number'],
        'date_of_birth': userData['date_of_birth'],
        'country_id': userData['country_id'],
        'city_id': userData['city_id'],
        'password': userData['password'],
        'education': userData['education'], // assuming it's a map
        'skills': userData['skills'], // assuming it's a list
        'experience': userData['experience'], // assuming it's a map
        'interests': userData['interests'], // assuming it's a list
        'cv_path': userData['cv_path'],
        'licenses_or_certifications': userData['licenses_or_certifications'],
      }).then((value) {
        print("Done_6 {value}");
        print('Data entered successfully!');
        // return true ;
      });
      return true ;
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
      return null;
    }
  }

  Future<bool?> changeUserPassword(String email, String currentPassword, String newPassword) async {
    try {
      // Re-authenticate the user with their current credentials
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
      User? user = FirebaseAuth.instance.currentUser;
      if(user != null){
        await user.reauthenticateWithCredential(credential);

        // Update the password
        await user.updatePassword(newPassword);

        print('Password updated successfully!');
        return true ;
      }
    } catch (e) {
      print('Error changing password: ${e}');
      // Handle errors, e.g., show a snackbar or display an error message
      throw e;
      return false ;
    }
  }

}