import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';
import '../../models/userProfileModel.dart';
import '../../providers/userProvider.dart';
import '../home/homePage.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final TextEditingController _oldPassword = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  UserProfile? userProfile ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      EasyLoading.show();

      userProfile = Provider.of<UserProvider>(context , listen: false).userProfile ;

      setState(() {});
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        onWillPop(context);
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(ImagePath.profileTop),
                  Positioned.fill(
                    top: size_H(30),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BackIcon(
                                onBack: (){
                                  onWillPop(context);
                                },
                                backWidget: Image.asset(ImagePath.backBtn , color: Colors.white , scale: 3),
                              ),
                              if(userProfile != null)
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: size_H(20),),
                                    Text("Profile", style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 15)),
                                    SizedBox(height: size_H(20),),
                                    Image.asset(ImagePath.profileAvatar, scale: 5,),
                                    SizedBox(height: size_H(10),),
                                    Text("${userProfile!.firstName} ${userProfile!.lastName}"  , style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 15),),
                                  ],
                                ),
                                SizedBox(width: size_W(60),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
              // SizedBox(height: size_H(30),),
              SizedBox(height: size_H(20),),

              /// _password
              MyTextForm(
                controller: _oldPassword,
                isPassword: true,
                isSuffixIcon: true,
                title: "Old Password",
                hint: "Enter Old Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: size_H(10),),
              /// _password
              MyTextForm(
                controller: _password,
                isPassword: true,
                isSuffixIcon: true,
                title: "New Password",
                hint: "Enter New Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
              ),
              SizedBox(height: size_H(10),),


              /// _confirmPassword
              MyTextForm(
                controller: _confirmPassword,
                isPassword: true,
                isSuffixIcon: true,
                title: "Confirm Password",
                hint: "Enter Confirm Password",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  return null;
                },
              ),



              SizedBox(height: size_H(20),),

              MyLoadingBtn(
                borderRadius: 30,
                width: size_W(220),
                text: "Update Password",
                callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                  if (btnState == ButtonState.idle) {
                    if (_oldPassword.text.isNotEmpty && _password.text.isNotEmpty && _confirmPassword.text.isNotEmpty
                    && (_password.text == _confirmPassword.text)) {
                      startLoading();
                      try{
                        String? email =  Provider.of<UserProvider>(context , listen: false).userProfile!.email ;
                        await Provider.of<UserProvider>(context , listen: false).changeUserPassword(email!, _oldPassword.text, _password.text);
                        stopLoading();
                        Provider.of<UserProvider>(context , listen: false).updatePasswordinDatabase(_password.text);
                        EasyLoading.showSuccess("Password Updated Successfully");
                        Navigator.pushReplacement(context, MyCustomRoute(builder: (BuildContext context) => HomePage()));
                        return;
                      } catch (e){
                        stopLoading();
                        if(e.runtimeType == FirebaseAuthException){
                          e as FirebaseAuthException ;
                          EasyLoading.showError("${e.message}");
                        }else{
                          EasyLoading.showError("${e}");
                        }

                      }
                    }
                    else{
                      EasyLoading.showError("Please Fill the Form");
                      return;

                    }

                  }
                },
              ),

              SizedBox(height: size_H(20),),
            ],
          ),
        ),
      ),
    );
  }

  void onWillPop(BuildContext context) {
    MyConfirmationDialog().showConfirmationDialog(
      context: context,
      title: "Confirmation",
      body: "If you go back, you'll lose data",
      saveBtn: "Back",
      onSave: (){
        Navigator.of(context).pop();
      },
    );
  }

}
