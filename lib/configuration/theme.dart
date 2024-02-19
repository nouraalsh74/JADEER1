

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/configuration/size_config.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';

import '../models/generalListFireBase.dart';

class Theme_Information {
  static Color Primary_Color  = Color(0xff01297F); // like pink
  static Color Second_Color  = Color(0xff0098D9);  // like blue
  static Color Third_Color  = Color(0xffB8EAF1);  // like blue

  // static Color Button_Color  = Color(0xff5D81DE);
  // static Color Button_Color2  = Color(0xff439CB8);





  static Color? Color_1  = Colors.white ;
  static Color? Color_2  = Colors.white10 ;
  static Color? Color_3  = Colors.white30 ;
  static Color? Color_4  = Colors.white70 ;
  static Color? Color_5  = Colors.black ;
  static Color? Color_6  = Colors.black38 ;

  static Color? Color_7  = Colors.grey ;
  static Color? Color_8  = Colors.grey[500] ;
  static Color? Color_9  = Colors.grey[200] ;
  static Color? Color_10  = Colors.red ;
  static Color? Color_11  = Colors.red[200] ;
  static Color? Color_12  = Colors.green[500] ;


}


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

TextStyle ourTextStyle({Color? color, double? fontSize ,FontWeight?  fontWeight ,double?  height ,TextDecoration? decoration }){
  color ??= Colors.black;
  fontSize ??= 13;
  fontWeight ??= FontWeight.normal;
    return GoogleFonts.poppins(color:  color ,fontWeight:  fontWeight,height: height, fontSize:  size_H(fontSize) , decoration: decoration?? TextDecoration.none );
}


double size_H(var hight){
  if(hight.runtimeType.toString() == "Int"){
    hight = hight.toDouble();
  }
  return  SizeConfig.heightMultiplier! * (hight / 7.81 ) ;
}

double size_W(var width){
  if(width.runtimeType.toString() == "Int"){
    width = width.toDouble();
  }
  return  SizeConfig.widthMultiplier! * (width / 3.92 ) ;}


class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({ WidgetBuilder? builder, RouteSettings? settings })
      : super(builder: builder!, settings: settings);

  @override
  Widget buildTransitions(BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    // transitionDuration: Duration(milliseconds: 2000),
    return new FadeTransition(opacity: animation, child: child );
    // return new ScaleTransition(scale: animation, child: child );
    // return new RotationTransition(turns: animation, child: child );
  }
}

