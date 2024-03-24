import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/homePageItem.dart';
import '../../commonWidgets/myDrawer.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/userProfileModel.dart';
import '../../providers/drawerProvider.dart';
import '../../providers/userProvider.dart';
import '../mentors/mentorsDashBoard.dart';
import '../myActivity/myActivityDashboard.dart';
import '../opportunities/myApplyOpportunity.dart';
import '../opportunities/opportunitiesDashboard.dart';
import '../opportunities/savedopportunities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ZoomDrawerController  drawerControllerMyVet=  ZoomDrawerController() ;
  UserProfile? userProfile ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfile =Provider.of<UserProvider>(context , listen: false).userProfile ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(content: Text('Tap back again to leave' , style: ourTextStyle(color: Theme_Information.Color_1)),),
        child: ZoomDrawer(
          controller: Provider.of<DrawerProvider>(context , listen: false).drawerController,
          // controller: drawerControllerMyVet,
          borderRadius: 50.0,
          isRtl: false,
          menuScreen: MyDrawer(context , setState),
          // disableDragGesture: true,
          mainScreenTapClose: true,
          showShadow: false,
          angle: 0.0,
          menuBackgroundColor: Theme_Information.Primary_Color,
          style: DrawerStyle.defaultStyle,
          mainScreen: Container(
            color: Theme_Information.Color_1,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
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
                    onBack: (){
                      Provider.of<DrawerProvider>(context , listen: false).openDrawer();
                    },
                  ),

                  Center(child: Image.asset("${ImagePath.logo_square}" , scale: 4)),

                  SizedBox(height: size_H(20),),

                  Padding(
                    padding: const EdgeInsets.only(left: 25,  right: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hi ${userProfile!.firstName} ${userProfile!.lastName}", style: ourTextStyle(fontSize: 18 , color: Theme_Information.Primary_Color , fontWeight: FontWeight.w500)),
                        // Text("Good Morning", style: ourTextStyle( fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  SizedBox(height: size_H(20),),
                  Center(child: Row(
                    children: [
                      SizedBox(width: size_W(10),),
                      Expanded(child: InkWell(
                          onTap: (){
                            Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => OpportunitiesDashboard()));
                          },
                          child: Image.asset("${ImagePath.recommendedBox}" , scale: 3))),
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
                            HomePageItem(text: "View your applications" , callBack: (){
                              print("1");
                              Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => MyApplyOpportunity()));
                            }),
                            HomePageItem(text: "View your activity", callBack: (){
                              print("2");
                              Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => MyActivityDashboard()));
                            }),
                          ],
                        ),

                        Row(
                          children: [
                            HomePageItem(text: "Saved opportunities", callBack: (){
                              // print("3");

                              Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => SavedOpportunities()));
                            }),
                            HomePageItem(text: "Discover mentors", callBack: (){
                              print("4");
                            //MentorsDashBoard
                              Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => MentorsDashBoard()));

                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
