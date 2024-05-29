import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/providers/dataProvider.dart';
import 'package:flutter_application_2/providers/drawerProvider.dart';
import 'package:flutter_application_2/providers/opportunityProvider.dart';
import 'package:flutter_application_2/providers/userProvider.dart';
import 'package:flutter_application_2/screens/signup&signin/splachScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'configuration/size_config.dart';
import 'configuration/theme.dart';

//sara latest version...

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SharedPreferences? loginDataHistory;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider<DrawerProvider>(create: (_) => DrawerProvider()),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider()),
        ChangeNotifierProvider<OpportunityProvider>(create: (_) => OpportunityProvider()),
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
              home: SplashScreen(),
            );
          },
        );
      },
    );
  }

}
