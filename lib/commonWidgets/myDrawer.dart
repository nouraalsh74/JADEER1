import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../configuration/theme.dart';
import '../main.dart';
import '../providers/drawerProvider.dart';
import '../screens/auth/welcomeScreen.dart';
import '../screens/profile/changePasswordPage.dart';
import '../screens/profile/profilePage.dart';
import 'myConfirmationDialog.dart';

Widget MyDrawer(context , setState) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Drawer(
      backgroundColor: Theme_Information.Primary_Color,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0 , right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(  height: size_H(100),),
            Center(
              child: Container(
                height: size_H(50),
                  width: size_W(100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Theme_Information.Color_1,
                  ),
                  child: Image.asset(ImagePath.logo_square , scale: 7)),
            ),
            SizedBox(  height: size_H(20),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  buildMenuItem(ImagePath.profile, "Profile", () {
                    Provider.of<DrawerProvider>(context , listen: false).openDrawer();
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => ProfilePage()));

                  }),
                  Divider(),
                  buildMenuItem(ImagePath.setting, "Setting", () {
                    // Handle Setting onTap
                  }),
                  buildMenuItem(ImagePath.setting, "Change Password", () {
                    Provider.of<DrawerProvider>(context , listen: false).openDrawer();
                    Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => ChangePasswordPage()));
                  }),
                  buildMenuItem(ImagePath.help, "Help", () {
                    // Handle Help onTap
                  }),
                  buildMenuItem(ImagePath.logout, "Sign out", () async {

                    MyConfirmationDialog().showConfirmationDialog(
                      context: context,
                      title: "Confirmation",
                      body: "Do you want to sign out?",
                      saveBtn: "Sign out",

                      onSave: () async {
                        EasyLoading.show();
                        await FirebaseAuth.instance.signOut();
                        EasyLoading.dismiss();
                        Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => WelcomeScreen()));
                      },
                    );

                    // Handle Sign out onTap

                  }),
                ],
              ),
            )



          ],
        ),
      ),
    ),
  );
}

Widget buildMenuItem(String imagePath, String text, Function()? onTap) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0 , bottom: 15),
    child: InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(imagePath, scale: 5),
          SizedBox(width: size_W(6)),
          Text(text, style: ourTextStyle(color: Theme_Information.Color_1)),
        ],
      ),
    ),
  );
}


ListTile buildListTile({
  required String title,
  required IconData? icon,
  required Color iconColor,
  required Function onTapCallback,
  required BuildContext context,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.all(2.0),
    trailing: icon != null ? Icon(icon, color: iconColor) : null,
    title: Text(title, style: ourTextStyle(color: Theme_Information.Color_1)),
    onTap: () {
      Provider.of<DrawerProvider>(context, listen: false).drawerController.close!();
      onTapCallback();
    },
  );
}


