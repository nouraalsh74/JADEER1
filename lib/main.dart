// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/providers/DataProvider.dart';
import 'package:flutter_application_2/providers/drawerProvider.dart';
import 'package:flutter_application_2/providers/userProvider.dart';
import 'package:flutter_application_2/screens/auth/splachScreen.dart';
import 'package:flutter_application_2/screens/auth/welcomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'configuration/size_config.dart';
import 'configuration/theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? loginDataHistory;

void main() async {
  ///
  ///
  /// /Users/mohmmedmalas/Desktop/flutter_3.16.0/bin/flutter --no-color pub get
  /// /Users/mohmmedmalas/Desktop/flutter_3.16.0/bin/flutter pub add flutter_zoom_drawer
  /// /Users/mohmmedmalas/Desktop/flutter_3.16.0/bin/flutter pub add firebase_app_check
  ///
  ///

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /*
    await FirebaseAppCheck.instance.activate(
    // androidProvider: AndroidProvider.playIntegrity,
    // appleProvider: AppleProvider.debug
    // webRecaptchaSiteKey: 'recaptcha-v3-site-key',

    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,

  );
   */

  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerProvider>(create: (_) => DrawerProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
        // ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            EasyLoading.instance.textStyle = ourTextStyle(color: Theme_Information.Color_1);
            return MaterialApp(
              builder: EasyLoading.init(),
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: '',
              // home: WelcomeScreen(),
              home: SplashScreen(),
            );
          },
        );
      },
    );
  }

}
