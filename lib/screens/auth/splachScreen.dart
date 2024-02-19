import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/auth/welcomeScreen.dart';

import '../../configuration/images.dart';
import '../../configuration/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => WelcomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: size_H(280)),
          Image.asset(ImagePath.logo ),
          SizedBox(height: size_H(100)),
          CircularProgressIndicator(color: Theme_Information.Primary_Color,)
        ],
      ),
    );
  }
}
