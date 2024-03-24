import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/providers/userProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/myOpportunityModel.dart';
import '../models/opportunityModel.dart';
import '../models/rateModel.dart';
import '../models/savedOpportunityModel.dart';
import '../models/userProfileModel.dart';

class OpportunityProvider with ChangeNotifier{
  // notifyListeners();
  List<Opportunity> opportunityList = [] ;
  List<SavedOpportunity> savedOpportunityList = [] ;
  List<MyAppliedOpportunity> myAppliedOpportunity = [] ;


  bool? isOpportunitySaved({required Opportunity opportunity}){
    final itemIndex =  savedOpportunityList.indexWhere((element) => element.opportunity == opportunity);
    if(itemIndex != -1){
      return true ;
    }
    return false ;
  }
  bool? isOpportunityApplied({required Opportunity opportunity}){
    final itemIndex =  myAppliedOpportunity.indexWhere((element) => element.opportunity!.id == opportunity.id);
    if(itemIndex != -1){
      return true ;
    }
    return false ;
  }

  Future addOpportunityToSaved(Opportunity data , context) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Get a reference to a new document with an auto-generated ID
    DocumentReference documentReference = firestore.collection("saved_opportunities").doc();
    // Use the document ID as the ID for each record
    await documentReference.set({
      'id': documentReference.id,
      'opportunity_id': data.id,
      'user_id': FirebaseAuth.instance.currentUser?.uid,
    });
    await fetchDataFromFirestoreSavedOpportunity("saved_opportunities" , Provider.of<UserProvider>(context , listen: false).userProfile?.userId??"");
    print('Items added to Firestore successfully!');
  }


  Future<void> removeItem({required String opportunity_id , context}) async {
    // final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('saved_opportunities');
    // itemsCollection.doc(opportunity_id).delete();
    try {
      FirebaseFirestore.instance
          .collection("saved_opportunities")
          .where("opportunity_id", isEqualTo :opportunity_id)
          .get().then((value){
        value.docs.forEach((element) {
          FirebaseFirestore.instance.collection("saved_opportunities").doc(element.id).delete().then((value){
            print("Success!");
          });
        });
      });
    }catch (e){
      print("dasdasdas ${e}");
      // return false;
    }
    await initOpportunity(context);

  }



  Future fetchDataFromFirestoreOpportunity(String collectionName ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    opportunityList.clear() ;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          opportunityList.add(
              Opportunity(
                id: document.data().toString().contains('id') ? document.get('id') : '',
                company_image: document.data().toString().contains('company_image') ? document.get('company_image') : '',
                title: document.data().toString().contains('title') ? document.get('title') : '',
                industry: document.data().toString().contains('industry') ? document.get('industry') : '',
                company: document.data().toString().contains('company') ? document.get('company') : '',
                description: document.data().toString().contains('description') ? document.get('description') : '',
                requirements: document.data().toString().contains('requirements') ? List<String>.from(document['requirements']) : [],
                location: document.data().toString().contains('location') ? document.get('location') : '',
                availability: document.data().toString().contains('availability') ? document.get('availability') : '',
                deadline: document.data().toString().contains('deadline') ? document.get('deadline') : '',
                opportunity_type: document.data().toString().contains('opportunity_type') ? document.get('opportunity_type') : '',
              )
          );
        }
        // opportunityList = _list ;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future initOpportunity(context) async {
    await fetchDataFromFirestoreOpportunity("opportunities");
    await fetchDataFromFirestoreSavedOpportunity("saved_opportunities" , Provider.of<UserProvider>(context , listen: false).userProfile?.userId??"");

  }

  bool checkDateInCurrentMonth(String dateStr) {
    DateTime date = DateTime.parse(DateFormat("dd/MM/yyyy").parse(dateStr).toString());
    DateTime now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }

  bool checkDateInLastMonth(String dateStr) {
    DateTime date = DateFormat("dd/MM/yyyy").parse(dateStr);
    DateTime now = DateTime.now();
    DateTime firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
    DateTime lastDayOfLastMonth = DateTime(now.year, now.month, 0);
    return date.isAfter(firstDayOfLastMonth.subtract(Duration(days: 1))) &&
        date.isBefore(lastDayOfLastMonth.add(Duration(days: 1)));
  }

  Future fetchDataFromFirestoreMyOpportunityThisMonth(String collectionName , List<MyAppliedOpportunity> data) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName)
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          if(!checkDateInCurrentMonth(document.get('date_apply'))){
            print("From Last Month");
          } else {
            data.add(
              MyAppliedOpportunity(
                id: document.data().toString().contains('ID') ? document.get('ID') : '',
                cvPath: document.data().toString().contains('cv_path') ? document.get('cv_path') : null,
                dateApply: document.data().toString().contains('date_apply') ? document.get('date_apply') : null,
                status: document.data().toString().contains('status') ? document.get('status') : null,
                education: (document.data().toString().contains('education') && document.get('education') != null)
                    ? List<Education>.from(document.get('education').map((x) => Education.fromJson(x)))
                    : null,
                dateOfBirth: document.data().toString().contains('date_of_birth') ? document.get('date_of_birth') : null,
                lastName: document.data().toString().contains('last_name') ? document.get('last_name') : null,
                applyOpportunityID: document.data().toString().contains('apply_id') ? document.get('apply_id') : null,
                experience: document.data().toString().contains('experience') && document.get('experience') != null
                    ? Experience.fromJson(document.get('experience'))
                    : null,
                skills: (document.data().toString().contains('skills') && document.get('skills') != null)
                    ? List<String>.from(document.get('skills'))
                    : null,
                licensesOrCertifications: (document.data().toString().contains('licenses_or_certifications') && document.get('licenses_or_certifications') != null)
                    ? List<LicensesOrCertification>.from(document.get('licenses_or_certifications').map((x) => LicensesOrCertification.fromJson(x)))
                    : null,
                userId: document.data().toString().contains('user_id') ? document.get('user_id') : null,
                phoneNumber: document.data().toString().contains('phone_number') ? document.get('phone_number') : null,
                interests: (document.data().toString().contains('interests') && document.get('interests') != null)
                    ? List<String>.from(document.get('interests'))
                    : null,
                firstName: document.data().toString().contains('first_name') ? document.get('first_name') : null,
                email: document.data().toString().contains('email') ? document.get('email') : null,
                countryId: document.data().toString().contains('country_id') ? document.get('country_id') : null,
                cityId: document.data().toString().contains('city_id') ? document.get('city_id') : null,
                opportunity: document.data().toString().contains('opportunity') && document.get('opportunity') != null
                    ? Opportunity.fromJson(document.get('opportunity'))
                    : null,
              ),
            );
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future fetchDataFromFirestoreMyOpportunityLastMonth(String collectionName , List<MyAppliedOpportunity> data) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName)
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          if(!checkDateInLastMonth(document.get('date_apply'))){
            print("From Last Month");
          } else {
            data.add(
              MyAppliedOpportunity(
                id: document.data().toString().contains('ID') ? document.get('ID') : '',
                cvPath: document.data().toString().contains('cv_path') ? document.get('cv_path') : null,
                dateApply: document.data().toString().contains('date_apply') ? document.get('date_apply') : null,
                status: document.data().toString().contains('status') ? document.get('status') : null,
                education: (document.data().toString().contains('education') && document.get('education') != null)
                    ? List<Education>.from(document.get('education').map((x) => Education.fromJson(x)))
                    : null,
                dateOfBirth: document.data().toString().contains('date_of_birth') ? document.get('date_of_birth') : null,
                lastName: document.data().toString().contains('last_name') ? document.get('last_name') : null,
                applyOpportunityID: document.data().toString().contains('apply_id') ? document.get('apply_id') : null,
                experience: document.data().toString().contains('experience') && document.get('experience') != null
                    ? Experience.fromJson(document.get('experience'))
                    : null,
                skills: (document.data().toString().contains('skills') && document.get('skills') != null)
                    ? List<String>.from(document.get('skills'))
                    : null,
                licensesOrCertifications: (document.data().toString().contains('licenses_or_certifications') && document.get('licenses_or_certifications') != null)
                    ? List<LicensesOrCertification>.from(document.get('licenses_or_certifications').map((x) => LicensesOrCertification.fromJson(x)))
                    : null,
                userId: document.data().toString().contains('user_id') ? document.get('user_id') : null,
                phoneNumber: document.data().toString().contains('phone_number') ? document.get('phone_number') : null,
                interests: (document.data().toString().contains('interests') && document.get('interests') != null)
                    ? List<String>.from(document.get('interests'))
                    : null,
                firstName: document.data().toString().contains('first_name') ? document.get('first_name') : null,
                email: document.data().toString().contains('email') ? document.get('email') : null,
                countryId: document.data().toString().contains('country_id') ? document.get('country_id') : null,
                cityId: document.data().toString().contains('city_id') ? document.get('city_id') : null,
                opportunity: document.data().toString().contains('opportunity') && document.get('opportunity') != null
                    ? Opportunity.fromJson(document.get('opportunity'))
                    : null,
              ),
            );
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future fetchDataFromFirestoreMyOpportunity(String collectionName , List<MyAppliedOpportunity> data) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName)
          .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          data.add(
              MyAppliedOpportunity(
                id: document.data().toString().contains('ID') ? document.get('ID') : '',
                dateApply: document.data().toString().contains('date_apply') ? document.get('date_apply') : null,
                cvPath: document.data().toString().contains('cv_path') ? document.get('cv_path') : null,
                status: document.data().toString().contains('status') ? document.get('status') : null,
                education: (document.data().toString().contains('education') && document.get('education') != null)
                    ? List<Education>.from(document.get('education').map((x) => Education.fromJson(x)))
                    : null,
                dateOfBirth: document.data().toString().contains('date_of_birth') ? document.get('date_of_birth') : null,
                lastName: document.data().toString().contains('last_name') ? document.get('last_name') : null,
                applyOpportunityID: document.data().toString().contains('apply_id') ? document.get('apply_id') : null,
                experience: document.data().toString().contains('experience') && document.get('experience') != null
                    ? Experience.fromJson(document.get('experience'))
                    : null,
                skills: (document.data().toString().contains('skills') && document.get('skills') != null)
                    ? List<String>.from(document.get('skills'))
                    : null,
                licensesOrCertifications: (document.data().toString().contains('licenses_or_certifications') && document.get('licenses_or_certifications') != null)
                    ? List<LicensesOrCertification>.from(document.get('licenses_or_certifications').map((x) => LicensesOrCertification.fromJson(x)))
                    : null,
                userId: document.data().toString().contains('user_id') ? document.get('user_id') : null,
                phoneNumber: document.data().toString().contains('phone_number') ? document.get('phone_number') : null,
                interests: (document.data().toString().contains('interests') && document.get('interests') != null)
                    ? List<String>.from(document.get('interests'))
                    : null,
                firstName: document.data().toString().contains('first_name') ? document.get('first_name') : null,
                email: document.data().toString().contains('email') ? document.get('email') : null,
                countryId: document.data().toString().contains('country_id') ? document.get('country_id') : null,
                cityId: document.data().toString().contains('city_id') ? document.get('city_id') : null,
                opportunity: document.data().toString().contains('opportunity') && document.get('opportunity') != null
                    ? Opportunity.fromJson(document.get('opportunity'))
                    : null,
              ),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future fetchDataFromFirestoreSavedOpportunity(String collectionName , String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    print("userId ${userId}");
    savedOpportunityList.clear() ;
    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName)
          .where('user_id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          savedOpportunityList.add(
              SavedOpportunity(
                  opportunity_id: document.data().toString().contains('opportunity_id') ? document.get('opportunity_id') : '',
                  id: document.data().toString().contains('id') ? document.get('id') : '',
                  user_id: document.data().toString().contains('user_id') ? document.get('user_id') : '',
                  opportunity:  firstWhere(opportunityList, document)
              )
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Opportunity? firstWhere(List<Opportunity> opportunities, QueryDocumentSnapshot<Object?> document){
    if(document.data().toString().contains('opportunity_id')){
      return opportunities.firstWhere((element) => element.id == document.get('opportunity_id') ) ;
    } else {
      return null ;
    }
  }


  Future<bool> addRate({required String rate, required String opportunityId}) async {
    final _firestore = FirebaseFirestore.instance;
    return await _firestore.collection("rating").add({
      'rateID': '',
      'UID': '${FirebaseAuth.instance.currentUser?.uid}',
      'rate': rate,
      'opportunity_id': opportunityId,
      // Add more fields as needed
    }).then((value) async {
      await _firestore
          .collection("rating")
          .doc(value.id)
          .update({"rateID": value.id});
      return true;
    }).catchError((error) {
      print(error);
      return false;
    });
  }

  getRate({required String opportunity_id , required Function(double? rate) callBack}) async {
    final UID = FirebaseAuth.instance.currentUser!.uid;
    final rateRes = await FirebaseFirestore.instance
        .collection('rating')
        .where("UID", isEqualTo: UID)
        .where("opportunity_id", isEqualTo: opportunity_id)
        .get();
    for (var Category in rateRes.docs) {
      final rate = Rate.fromJson(Category.data()) as Rate;
      double? ratee = double.tryParse(rate.rate.toString());
      callBack(ratee);
    }
  }
  isApplied({required String opportunity_id , required Function(bool? isApplied) callBack}) async {
    final UID = FirebaseAuth.instance.currentUser!.uid;
    bool isAppliedD = false ;
    final data = await FirebaseFirestore.instance
        .collection('apply_opportunities')
        .where("user_id", isEqualTo: UID)
        .get();
    for (var Category in data.docs) {
      final data = MyAppliedOpportunity.fromJson(Category.data());
      if(data.opportunity!.id == opportunity_id){
        isAppliedD = true ;
        break ;
      }
    }
    print("isAppliedD ${isAppliedD}");
    callBack(isAppliedD);
  }
  getStatus({required String opportunity_id , required Function(String? status) callBack}) async {
    final UID = FirebaseAuth.instance.currentUser!.uid;
    String? status ;
    final data = await FirebaseFirestore.instance
        .collection('apply_opportunities')
        .where("user_id", isEqualTo: UID)
        .get();
    for (var Category in data.docs) {
      final data = MyAppliedOpportunity.fromJson(Category.data());
      if(data.opportunity!.id == opportunity_id){
        status = data.status ;
        callBack(status);
        break ;
      }
      //
    }

    callBack(status);
  }

  Future changeStatus({required String apply_opportunity_id ,required String newStatus ,  required Function() callBack}) async {
    try{
      await FirebaseFirestore.instance.collection('apply_opportunities').doc(apply_opportunity_id).update({
        'status': newStatus,
      }).then((value) {
        callBack();
      });
    } catch (e) {
      // Handle errors here
      print('Error entering data: $e');
    }
  }

  Future applyOpportunity({required Map<String, dynamic> opportunityData , required Function callBack}) async {
    final _firestore = FirebaseFirestore.instance;
    await FirebaseFirestore.instance.collection('apply_opportunities').add({
      'first_name': opportunityData['first_name'],
      'last_name': opportunityData['last_name'],
      'ID': opportunityData['ID'],
      'apply_id': "",
      'user_id' : opportunityData['user_id'],
      'email': opportunityData['email'],
      'phone_number': opportunityData['phone_number'],
      'date_of_birth': opportunityData['date_of_birth'],
      'country_id': opportunityData['country_id'],
      'city_id': opportunityData['city_id'],
      'education': opportunityData['education'], // assuming it's a map
      'skills': opportunityData['skills'], // assuming it's a list
      'experience': opportunityData['experience'], // assuming it's a map
      'cv_path': opportunityData['cv_path'],
      'licenses_or_certifications': opportunityData['licenses_or_certifications'],
      'date_apply': opportunityData['date_apply'],
      'status': opportunityData['status'],
      'opportunity': opportunityData['opportunity'],
    }).then((value) async {
      print("Done ${value.id}");
      await _firestore
          .collection("apply_opportunities")
          .doc(value.id)
          .update({"apply_id": value.id});
      callBack();
    }).catchError((error) {
      print(error);
    });
  }




}