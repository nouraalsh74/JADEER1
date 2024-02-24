 import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

/// DrawerProvider
 class DrawerProvider with ChangeNotifier{
   ZoomDrawerController  drawerController=  ZoomDrawerController() ;

   openDrawer() async {
     drawerController.toggle!();
     notifyListeners();
   }

 }