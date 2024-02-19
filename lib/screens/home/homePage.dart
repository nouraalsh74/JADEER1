import 'package:flutter/material.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/homePageItem.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size_H(40),),
            BackIcon(
                titleWidget: Text("Home" , style: ourTextStyle(color: Theme_Information.Primary_Color , fontSize: 18)),
                backWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0 , left: 8),
                  child: Image.asset("${ImagePath.menu}" , scale: 4 ),
                ),
              onBack: (){},
            ),

            Center(child: Image.asset("${ImagePath.logo_square}" , scale: 4)),

            SizedBox(height: size_H(20),),

            Padding(
              padding: const EdgeInsets.only(left: 25,  right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hi Reem!", style: ourTextStyle(fontSize: 18 , color: Theme_Information.Primary_Color , fontWeight: FontWeight.w500)),
                  Text("Good Morning", style: ourTextStyle( fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            SizedBox(height: size_H(20),),
            Center(child: Row(
              children: [
                SizedBox(width: size_W(10),),
                Expanded(child: Image.asset("${ImagePath.recommendedBox}" , scale: 3)),
                SizedBox(width: size_W(10),),
              ],
            )),
            SizedBox(height: size_H(20),),
            Padding(
              padding: const EdgeInsets.only(left: 25,  right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Discover more", style: ourTextStyle( fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      HomePageItem(text: "View your applications" , callBack: (){print("1");}),
                      HomePageItem(text: "View your activity", callBack: (){print("2");}),
                    ],
                  ),

                  Row(
                    children: [
                      HomePageItem(text: "Saved opportunities", callBack: (){print("3");}),
                      HomePageItem(text: "Discover mentors", callBack: (){print("4");}),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
