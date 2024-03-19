// ApplyOpportunityPage

import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/screens/auth/registeredSuccessfullyPage.dart';
import 'package:flutter_application_2/screens/auth/skillFormPage.dart';
import 'package:flutter_application_2/screens/opportunities/personalInformationForm.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_btn/loading_btn.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myBtnSelector.dart';
import '../../commonWidgets/myBtnSelectorExperience.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myDropDownWidget.dart';
import '../../commonWidgets/myDropDownWidgetNumber.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/theme.dart';
import '../../models/generalListFireBase.dart';
import '../../models/opportunityModel.dart';
import '../../models/userProfileModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/opportunityProvider.dart';
import '../../providers/userProvider.dart';
import '../auth/educationFormPage.dart';
import '../auth/interestFormPage.dart';
import '../auth/licensesOrCertificationFormPage.dart';
import '../home/homePage.dart';

class ApplyOpportunityPage extends StatefulWidget {
  const ApplyOpportunityPage({
    Key? key,
    this.opportunity,
  }) : super(key: key);
  final Opportunity? opportunity ;

  @override
  State<ApplyOpportunityPage> createState() => _ApplyOpportunityPageState();
}

class _ApplyOpportunityPageState extends State<ApplyOpportunityPage> {
  String? filePathCVBase;
  String? filePathCV;

  bool isAutoFill = false ;
  bool isManualFill = false ;

  List<GeneralFireBaseList> countryList = [] ;
  GeneralFireBaseList? selectedCountry ;

  List<GeneralFireBaseList> cityList = [] ;
  GeneralFireBaseList? selectedCity ;


  List<GeneralFireBaseList> fieldOfStudyList = [] ;
  GeneralFireBaseList? selectedFieldOfStudy ;

  List<GeneralFireBaseList> durationList = [] ;
  GeneralFireBaseList? selectedDuration ;

  List<int> durationYearList = [1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10] ;
  int? selectedDurationYear ;
  Map<String, dynamic>? personalInformation ;
  List<Education> educations = [];
  List<LicensesOrCertification> licensesOrCertification = [];
  List<String> skills = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      Map<String, dynamic>? userData = await Provider.of<UserProvider>(context, listen: false).getUserData(FirebaseAuth.instance.currentUser!.uid);
      String jsonString = jsonEncode(userData);
      UserProfile userProfile = userProfileFromJson(jsonString);
      await Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);

      countryList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("countries" , countryList);
      cityList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("cities" , cityList);

      fieldOfStudyList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("field_of_study" , fieldOfStudyList);
      durationList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("durations" , durationList);
      durationList = durationList.reversed.toList();
      if(durationList.isNotEmpty) selectedDuration = durationList.first ;
      setState(() {});
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Column(
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
                            if(widget.opportunity != null)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: size_H(40),),
                                  Text("Apply to", style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 20)),
                                  Text("${widget.opportunity?.title}", style: ourTextStyle(color: Theme_Information.Color_1 , fontSize: 15)),
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

            Padding(
              padding: const EdgeInsets.only(right: 15.0 , left: 15 , bottom: 12 , top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(!isAutoFill)
                  MyLoadingBtn(
                    height: size_H(35),
                    width: size_W(140),
                    textStyle: ourTextStyle(fontSize: 13 , color: Theme_Information.Color_1),
                    borderRadius: 10,
                    text: "Autofill",
                    callBack: (Function startLoading,
                        Function stopLoading,
                        ButtonState btnState) {
                      EasyLoading.show();
                      UserProfile? userProfile = Provider.of<UserProvider>(context , listen: false).userProfile ;
                      print("userProfile ${userProfile?.skills}");
                      if(userProfile != null){
                        educations = userProfile.education ?? [] ;
                        skills = userProfile.skills ?? [] ;
                        fieldOfStudyList.forEach((element) {
                          if(element.name == userProfile.experience!.name!) {
                            selectedFieldOfStudy = element ;
                          }
                        });
                        selectedDurationYear = int.tryParse(userProfile.experience?.numberOfYear??"");
                        durationList.forEach((element) {
                          if(element.name == userProfile.experience!.durationName!) {
                            selectedDuration = element ;
                          }
                        });
                        licensesOrCertification = userProfile.licensesOrCertifications?? [] ;
                        filePathCVBase = userProfile.cvPath ;
                        filePathCV = userProfile.cvPath ;

                        countryList.forEach((element) {
                          if(element.id == "${userProfile!.countryId}"){
                            selectedCountry = element ;
                          }
                        });

                        cityList.forEach((element) {
                          if(element.id == "${userProfile!.cityId}"){
                            selectedCity = element ;
                          }
                        });

                        personalInformation = {
                          'id': userProfile.id,
                          'email': userProfile.email,
                          'city': selectedCity,
                          'country': selectedCountry,
                          'dateOfBirth': userProfile.dateOfBirth,
                          'firstName': userProfile.firstName,
                          'lastName':userProfile.lastName,
                          'phoneNumber': userProfile.phoneNumber,
                        };
                        isAutoFill = true ;
                        setState(() {});
                        EasyLoading.dismiss();
                      }

                    },
                  ),

                  if(isAutoFill)
                    MyLoadingBtn(
                      height: size_H(35),
                      width: size_W(140),
                      textStyle: ourTextStyle(fontSize: 13 , color: Theme_Information.Color_1),
                      borderRadius: 10,
                      text: "Remove All",
                      callBack: (Function startLoading,
                          Function stopLoading,
                          ButtonState btnState) {
                        EasyLoading.show();
                        UserProfile? userProfile = Provider.of<UserProvider>(context , listen: false).userProfile ;
                        print("userProfile ${userProfile?.skills}");
                        if(userProfile != null){
                          educations =  [] ;
                          skills =  [] ;
                          licensesOrCertification =  [] ;
                          selectedFieldOfStudy = null ;
                          selectedDurationYear = null ;
                          personalInformation = null ;
                          selectedCity = null ;
                          selectedCountry = null ;
                          selectedDuration = null ;
                          isAutoFill = false ;
                          filePathCV = null ;
                          setState(() {});
                          EasyLoading.dismiss();
                        }

                      },
                    ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0 , left: 15),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      /// personal information
                      MyBtnSelector(
                        // controller: TextEditingController(),
                        title: "Personal information",
                        hint: "Add Education",
                        iconWidget: iconWidget(educations),
                        callback: () {
                          // EducationFormPage
                          Navigator.push(
                              context,
                              MyCustomRoute(
                                  builder: (BuildContext context) =>
                                      PersonalInformationForm())).then((value) {
                            if (value != null) {
                              value = value as Map<String, dynamic>;
                              print("${value} _NULL");
                              setState(() {
                                personalInformation = value ;
                              });
                            } else {
                              print("{value}_NULL");
                            }
                          });
                        },
                      ),
              
                      //educations
                      if (personalInformation != null && personalInformation!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 5),
                          child: Container(
                            height: size_H(40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  personalInformation!.isNotEmpty ? "My Personal Information" : "",
                                  // "${filePathCV!.split("/").last}",
                                  style: ourTextStyle(),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      // Confirmation
                                      // 'Do you want to complete?'
                                      MyConfirmationDialog()
                                          .showConfirmationDialog(
                                        context: context,
                                        title: "Confirmation",
                                        body: "Do you want to remove your your personal information?",
                                        saveBtn: "Remove",
                                        onSave: () {
                                          setState(() {
                                            filePathCV = null;
                                          });
                                        },
                                      );
                                    },
                                    child:
                                    Icon(Icons.remove_circle_outline_sharp))
                              ],
                            ),
                          ),
                        ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      /// Education
                      MyBtnSelector(
                        // controller: TextEditingController(),
                        title: "Education",
                        hint: "Add Education",
                        iconWidget: iconWidget(educations),
                        callback: () {
                          // EducationFormPage
                          Navigator.push(
                              context,
                              MyCustomRoute(
                                  builder: (BuildContext context) =>
                                      EducationFormPage())).then((value) {
                            if (value != null) {
                              value = value as Education;
                              setState(() {
                                educations.add(value);
                              });
                            } else {
                              print("{value}_NULL");
                            }
                          });
                        },
                      ),
                      //educations
                      if (educations.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 5),
                          child: Column(
                            children: List.generate(educations.length, (index) {
                              Education _education = educations[index];
                              return Container(
                                height: size_H(40),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.s,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "${index + 1} - ${_education.universityName}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ourTextStyle(),
                                    )),
                                    SizedBox(
                                      width: size_W(5),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          // Confirmation
                                          // 'Do you want to complete?'
                                          MyConfirmationDialog()
                                              .showConfirmationDialog(
                                            context: context,
                                            title: "Confirmation",
                                            body:
                                                "Do you want to remove this education?",
                                            saveBtn: "Remove",
                                            onSave: () {
                                              setState(() {
                                                educations.removeWhere((element) =>
                                                    element == _education);
                                              });
                                            },
                                          );
                                        },
                                        child:
                                            Icon(Icons.remove_circle_outline_sharp))
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      /// Skills
                      MyBtnSelector(
                        // controller: TextEditingController(),
                        title: "Skills",
                        hint: "Add Skill",
                        iconWidget: iconWidget(skills),
                        callback: () {
                          // SkillFormPage
                          Navigator.push(
                              context,
                              MyCustomRoute(
                                  builder: (BuildContext context) =>
                                      SkillFormPage(skills: skills))).then((value) {
                            if (value != null) {
                              print("${value}");
                              value = value as List<String>;
                              setState(() {
                                skills = value!;
                              });
                            } else {
                              print("{value}_NULL");
                            }
                          });
                        },
                      ),
              
                      if (skills.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 5),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.s,
                            children: [
                              Expanded(
                                  child: Text(
                                "${skills.length} skills Added",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: ourTextStyle(),
                              )),
                              SizedBox(
                                width: size_W(5),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Confirmation
                                    // 'Do you want to complete?'
                                    MyConfirmationDialog().showConfirmationDialog(
                                      context: context,
                                      title: "Confirmation",
                                      body: "Do you want to remove all skill?",
                                      saveBtn: "Remove",
                                      onSave: () {
                                        setState(() {
                                          skills.clear();
                                        });
                                      },
                                    );
                                  },
                                  child: Icon(Icons.remove_circle_outline_sharp))
                            ],
                          ),
                        ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: MyDropDownWidget(
                              // controller: _country,
                              title: "Experience",
                              selectedValue: selectedFieldOfStudy,
                              listOfData: fieldOfStudyList,
                              callBack: (GeneralFireBaseList? newValue) {
                                setState(() {
                                  selectedFieldOfStudy = newValue;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: MyDropDownWidgetNumber(
                              // controller: _country,
                              // title: "Field",
                              selectedValue: selectedDurationYear,
                              listOfData: durationYearList,
                              callBack: (int? newValue) {
                                setState(() {
                                  selectedDurationYear = newValue;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: MyDropDownWidget(
                              // controller: _country,
                              // title: "Field",
                              selectedValue: selectedDuration,
                              listOfData: durationList,
                              callBack: (GeneralFireBaseList? newValue) {
                                setState(() {
                                  selectedDuration = newValue;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      /// Licenses & Certification
                      MyBtnSelector(
                        // controller: TextEditingController(),
                        title: "Licenses & Certification",
                        hint: "Add Licenses & Certification",
                        iconWidget: iconWidget(licensesOrCertification),
                        callback: () {
                          // LicensesOrCertificationFormPage
                          Navigator.push(
                                  context,
                                  MyCustomRoute(
                                      builder: (BuildContext context) =>
                                          LicensesOrCertificationFormPage()))
                              .then((value) {
                            if (value != null) {
                              value = value as LicensesOrCertification;
                              setState(() {
                                licensesOrCertification.add(value);
                              });
                            } else {
                              print("{value}_NULL");
                            }
                          });
                        },
                      ),
                      //educations
                      if (licensesOrCertification.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 20.0, left: 20.0, top: 5),
                          child: Column(
                            children: List.generate(licensesOrCertification.length,
                                (index) {
                              LicensesOrCertification _licensesOrCertification =
                                  licensesOrCertification[index];
                              return Container(
                                height: size_H(40),
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.s,
                                  children: [
                                    Expanded(
                                        child: Text(
                                      "${index + 1} - ${_licensesOrCertification.name}",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: ourTextStyle(),
                                    )),
                                    SizedBox(
                                      width: size_W(5),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          // Confirmation
                                          // 'Do you want to complete?'
                                          MyConfirmationDialog()
                                              .showConfirmationDialog(
                                            context: context,
                                            title: "Confirmation",
                                            body:
                                                "Do you want to remove this licenses or certification?",
                                            saveBtn: "Remove",
                                            onSave: () {
                                              setState(() {
                                                licensesOrCertification.removeWhere(
                                                    (element) =>
                                                        element ==
                                                        _licensesOrCertification);
                                              });
                                            },
                                          );
                                        },
                                        child:
                                            Icon(Icons.remove_circle_outline_sharp))
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
              
                      Column(
                        children: [
                          MyBtnSelector(
                            // controller: TextEditingController(),
                            title: "Upload CV",
                            hint: "Browse file",
                            iconWidget: Image.asset(ImagePath.uploadIcon, scale: 6),
                            callback: () async {
                              // _showActionSheet(context);
              
                              final act = CupertinoActionSheet(
                                  actions: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8.0, left: 8),
                                      child: CupertinoActionSheetAction(
                                        child: Text('Browse',
                                            style: ourTextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        onPressed: () async {
                                          String? path = await pickFile();
                                          if (path != null) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ),
                                    if (filePathCV != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, left: 8),
                                        child: CupertinoActionSheetAction(
                                          child: Text('Remove Selected',
                                              style: ourTextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Theme_Information.Color_10)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              filePathCV = null;
                                            });
                                          },
                                        ),
                                      )
                                  ],
                                  cancelButton: CupertinoActionSheetAction(
                                    child: Text('Cancel',
                                        style: ourTextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Theme_Information.Color_10)),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ));
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext context) => act);
                            },
                          ),
                          if (filePathCV != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 20.0, left: 20.0, top: 5),
                              child: Container(
                                height: size_H(40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "${filePathCV!.isNotEmpty ? "My CV" : ""}",
                                      // "${filePathCV!.split("/").last}",
                                      style: ourTextStyle(),
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          // Confirmation
                                          // 'Do you want to complete?'
                                          MyConfirmationDialog()
                                              .showConfirmationDialog(
                                            context: context,
                                            title: "Confirmation",
                                            body: "Do you want to remove your CV?",
                                            saveBtn: "Remove",
                                            onSave: () {
                                              setState(() {
                                                filePathCV = null;
                                              });
                                            },
                                          );
                                        },
                                        child:
                                            Icon(Icons.remove_circle_outline_sharp))
                                  ],
                                ),
                              ),
                            )
                        ],
                      ),
              
                      SizedBox(
                        height: size_H(20),
                      ),
              
                      ///
                                MyLoadingBtn(
                                  borderRadius: 30,
                                  width: size_W(150),
                                  text: "Apply",
                                  callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                                    if (btnState == ButtonState.idle) {

                                        MyConfirmationDialog().showConfirmationDialog(
                                        context: context,
                                        title: "Confirmation",
                                        body: "Do you want to apply for this opportunity?",
                                        saveBtn: "Apply",
                                        onCancel: (){
                                        stopLoading();
                                        return ;
                                        },
                                        onSave: () async {
                                          if(educations.isEmpty){
                                            EasyLoading.showError("Please add at least one education");
                                            return ;
                                          } else if(skills.length < 3){
                                            EasyLoading.showError("Please select at least 3 skill");
                                            return ;
                                          } else if(personalInformation == null || personalInformation!.isEmpty){
                                            EasyLoading.showError("Please fill your personal Information");
                                            return ;
                                          } else if (filePathCV== null || filePathCV!.isEmpty){
                                            EasyLoading.showError("Please upload your cv");
                                            return ;
                                          } else {





                                            Experience userExperience = Experience(
                                              name: '${selectedFieldOfStudy?.name}',
                                              numberOfYear: '$selectedDurationYear',
                                              durationName: '${selectedDuration?.name}',
                                            );



                                            UserProfile userProfile = UserProfile(
                                              userId: FirebaseAuth.instance.currentUser!.uid,
                                              firstName: "${personalInformation!["firstName"]}",
                                              lastName: "${personalInformation!["lastName"]}",
                                              id: "${personalInformation!["id"]}",
                                              email: "${personalInformation!["email"]}",
                                              phoneNumber: "${personalInformation!["phoneNumber"]}",
                                              dateOfBirth:"${personalInformation!["dateOfBirth"]}",
                                              countryId: "${(personalInformation!["country"] as GeneralFireBaseList).id}",
                                              cityId:"${(personalInformation!["city"] as GeneralFireBaseList).id}",
                                              education: educations,
                                              skills: skills,
                                              experience: userExperience,
                                              cvPath: filePathCV,
                                              licensesOrCertifications: licensesOrCertification,
                                            );

                                            if(filePathCV != filePathCVBase) {
                                              String downloadUrl = await Provider.of<UserProvider>(context , listen: false).uploadFile(filePathCV! , FirebaseAuth.instance.currentUser!.uid);
                                              userProfile.cvPath = downloadUrl ;
                                            }

                                            Map<String, dynamic> userData = userProfile.toJson();
                                            userData.addAll({
                                              "opportunity": widget.opportunity?.toMap(),
                                              "status": "pending"
                                            });
                                            EasyLoading.show();

                                            await Provider.of<OpportunityProvider>(context, listen: false).applyOpportunity(opportunityData: userData , callBack :(){
                                              stopLoading();
                                              EasyLoading.showSuccess("Thanks for applying" , duration:const Duration(seconds: 3) );
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          HomePage()),
                                                      (Route<dynamic> route) => false);

                                            });
                                            stopLoading();
                                          }
                                        });

                                    }
                                  },
                                ),
                      ///
                      SizedBox(
                        height: size_H(20),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Icon iconWidget(List data) {
    return !data.isNotEmpty ?
                      Icon(Icons.add , color: Theme_Information.Primary_Color,)
                          :  Icon(Icons.check , color: Theme_Information.Primary_Color,);
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


  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        filePathCV = result.files.single.path;
      });

      return filePathCV;
    }

    return null;
  }




}

