import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/generalListFireBase.dart';
import '../models/mentorsModel.dart';

class DataProvider with ChangeNotifier{
  // notifyListeners();

  Future fetchDataFromFirestore(String collectionName , List<GeneralFireBaseList> _list) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
          String? name = data?['name'] as String?;
          String? id = data?['id'] as String?;

          if (name != null && id != null) {
            _list.add(GeneralFireBaseList(name: name  , id: id));
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future fetchDataFromFirestoreMentor(String collectionName , List<Mentor> _list) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
      await firestore.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot document in querySnapshot.docs) {
          _list.add(
            Mentor(
              name: document.data().toString().contains('name') ? document.get('name') : '', //String
              image: document.data().toString().contains('image') ? document.get('image') : '', //String
              major: document.data().toString().contains('major') ? document.get('major') : '', //String
              company: document.data().toString().contains('company') ? document.get('company') : '', //String
              description: document.data().toString().contains('description') ? document.get('description') : '', //String
              socialMedia: document.data().toString().contains('socialMedia') ? Map<String, String>.from(document['socialMedia']) : {},
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

}