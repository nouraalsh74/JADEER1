import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/screens/home/homePage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/MyDatePicker.dart';
import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myBtnSelector.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myDropDownWidget.dart';
import '../../commonWidgets/myDropDownWidgetNumber.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/theme.dart';
import '../../models/generalListFireBase.dart';
// import '../../models/licensesOrCertificationModel.dart';
import '../../models/userProfileModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/userProvider.dart';
import '../auth/educationFormPage.dart';
import '../auth/interestFormPage.dart';
import '../auth/licensesOrCertificationFormPage.dart';
import '../auth/skillFormPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();

  List<GeneralFireBaseList> countryList = [] ;
  GeneralFireBaseList? selectedCountry ;

  List<GeneralFireBaseList> cityList = [] ;
  GeneralFireBaseList? selectedCity ;

  DateTime _selectedDateOfBirth = DateTime.now();

  UserProfile? userProfile ;

  String? filePathCVBase;
  String? filePathCV;

  List<GeneralFireBaseList> fieldOfStudyList = [] ;
  GeneralFireBaseList? selectedFieldOfStudy ;

  List<GeneralFireBaseList> durationList = [] ;
  GeneralFireBaseList? selectedDuration ;

  List<int> durationYearList = [1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10] ;
  int? selectedDurationYear ;

  List<Education> educations = [];
  List<LicensesOrCertification> licensesOrCertification = [];
  List<String> skills = [];
  List<String> interests = [];

  bool isEditable = false ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
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


    userProfile = Provider.of<UserProvider>(context , listen: false).userProfile ;


    _firstName.text = "${userProfile!.firstName}" ;
    _lastName.text = "${userProfile!.lastName}" ;
    _id.text = "${userProfile!.id}" ;
    _email.text = "${userProfile!.email}" ;
    _phoneNumber.text = "${userProfile!.phoneNumber}" ;
    _dateOfBirth.text = "${userProfile!.dateOfBirth}" ;
    _lastName.text = "${userProfile!.lastName}" ;
    _lastName.text = "${userProfile!.lastName}" ;
    _lastName.text = "${userProfile!.lastName}" ;
    _lastName.text = "${userProfile!.lastName}" ;

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


      educations = userProfile!.education?? [] ;
      skills = userProfile!.skills ?? [] ;
      interests = userProfile!.interests ?? [] ;
      licensesOrCertification = userProfile!.licensesOrCertifications?? [] ;


      fieldOfStudyList.forEach((element) {
        if(element.name == "${userProfile!.experience!.name}"){
          selectedFieldOfStudy = element ;
        }
      });
      durationYearList.forEach((element) {
        if(element.toString() == userProfile!.experience!.numberOfYear){
          selectedDurationYear = element ;
        }
      });
      durationList.forEach((element) {
        if(element.name == userProfile!.experience!.durationName){
          selectedDuration = element ;
        }
      });

      filePathCVBase = userProfile!.cvPath ;
      filePathCV = userProfile!.cvPath ;

      setState(() {});
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:  !isEditable ? null : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding:  EdgeInsets.only(right: size_W(10) , left: size_W(10) , bottom: size_H(15) , top: size_H(15)),
            child: MyLoadingBtn(
              borderRadius: 30,
              width:  size_W(150),
              text: "Cancel",
              color: Theme_Information.Color_10,
              callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                MyConfirmationDialog().showConfirmationDialog(
                  context: context,
                  title: "Confirmation",
                  body: "Do you want to ignore all changes and go back?",
                  saveBtn: "Back",
                  onSave: (){
                    setState(() {
                      isEditable = !isEditable ;
                    });
                  },
                );


              },
            ),
          ),

          Padding(
            padding:  EdgeInsets.only(right: size_W(10) , left: size_W(10) , bottom: size_H(15) , top: size_H(15)),
            child: MyLoadingBtn(
              borderRadius: 30,
              width:  size_W(150),
              text: "Save",
              callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {

                // await Future.delayed(const Duration(seconds: 5));
                // stopLoading();

                MyConfirmationDialog().showConfirmationDialog(
                  context: context,
                  title: "Confirmation",
                  body: "Do you want to save the changes?",
                  saveBtn: "Save",
                  onCancel: (){
                    stopLoading();
                    return ;
                  },
                  onSave: () async {
                    if (btnState == ButtonState.idle) {
                      startLoading();
                      Experience userExperience = Experience(
                        name: '${selectedFieldOfStudy?.name}',
                        numberOfYear: '${selectedDurationYear}',
                        durationName: '${selectedDuration?.name}',
                      );

                      String? uid = FirebaseAuth.instance.currentUser?.uid ;
                      if(uid != null){



                        UserProfile userProfile = UserProfile(
                          firstName: _firstName.text,
                          lastName: _lastName.text,
                          id: _id.text,
                          userId: uid,
                          email: _email.text,
                          phoneNumber: _phoneNumber.text,
                          dateOfBirth: _dateOfBirth.text,
                          countryId: '${selectedCountry!.id}',
                          cityId: '${selectedCity!.id}',
                          education: educations,
                          skills: skills,
                          experience: userExperience,
                          interests: interests,
                          // cvPath: '',
                          licensesOrCertifications: licensesOrCertification,
                        );

                        if(filePathCV != filePathCVBase) {
                          String downloadUrl = await Provider.of<UserProvider>(context , listen: false).uploadFile(filePathCV! , uid);
                          userProfile.cvPath = downloadUrl ;
                        }

                        Map<String, dynamic> userData = userProfile.toJson();





                        await Provider.of<UserProvider>(context , listen: false).updateUserData(uid , userData).then((value) async {
                          if(value != null){
                            if(value == true){


                              Map<String, dynamic>? userData = await Provider.of<UserProvider>(context, listen: false).getUserData(uid);
                              String jsonString = jsonEncode(userData);
                              UserProfile userProfile = userProfileFromJson(jsonString);
                              await Provider.of<UserProvider>(context , listen: false).setUserProfile(userProfile);
                              stopLoading();
                              EasyLoading.showSuccess("Profile Updated Successfully");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage()),
                                      (Route<dynamic> route) => false);
                              return;
                            } else{
                              stopLoading();

                              EasyLoading.showError("There is a problem , Please try again");
                            }
                          }
                        });
                      }


                    }
                  },
                );


                ///


              },
            ),
          ),
        ],
      ),
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
                            if(!isEditable)
                            BackIcon(
                                onBack: (){
                                  setState(() {
                                    isEditable = !isEditable ;
                                  });
                                },
                              backWidget: Image.asset( ImagePath.editIcon , color: Colors.white , scale: 3),
                            ),
                            if(isEditable)
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

            SizedBox(height: size_H(10),),
            /// _firstName
            MyTextForm(
              enabled: isEditable,
              controller: _firstName,
              title: "First Name",
              hint: "Enter First Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your first name";
                }
                return null;
              },
            ),
            SizedBox(height: size_H(20),),
            /// _lastName
            MyTextForm(
              enabled: isEditable,
              controller: _lastName,
              title: "Last Name",
              hint: "Enter Last Name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your last name";
                }
                return null;
              },
            ),
            SizedBox(height: size_H(10),),

            /// _id
            MyTextForm(
              enabled: isEditable,
              controller: _id,
              title: "ID",
              hint: "Enter Your ID",
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your id";
                }

                return null;
              },
            ),
            SizedBox(height: size_H(10),),

            /// _email
            MyTextForm(
              enabled: isEditable,
              controller: _email,
              title: "Email",
              keyboardType: TextInputType.emailAddress,
              hint: "Enter Email",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your email";
                }
                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: size_H(10),),

            /// _phoneNumber
            MyTextForm(
              enabled: isEditable,
              controller: _phoneNumber,
              keyboardType: TextInputType.number,
              title: "Phone Number",
              hint: "Enter Phone Number",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter your phone number";
                }
                if (!RegExp(r'^[0-9+]{1,}').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: size_H(10),),

            /// _dateOfBirth
            GestureDetector(
              onTap: !isEditable ? null : (){
                MyDatePicker().selectDate(context , _selectedDateOfBirth).then((value) {
                  if(value != null){
                    setState(() {
                      final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
                      _dateOfBirth.text = serverFormater.format(value);
                    });
                  }
                });
              },
              child: MyTextForm(
                enabled: false,
                controller: _dateOfBirth,
                title: "Date of Birth",
                hint: "Enter Date of Birth",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your date of birth";
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: size_H(10),),

            /// _country
            MyDropDownWidget(
              isEditable: isEditable,
              // controller: _country,
              title: "Country",
              selectedValue: selectedCountry,
              listOfData: countryList,
              callBack: (GeneralFireBaseList? newValue){
                setState(() {
                  selectedCountry = newValue ;
                });
              },
            ),
            SizedBox(height: size_H(10),),

            /// _city
            MyDropDownWidget(
              isEditable: isEditable,
              // controller: _country,
              title: "City",
              selectedValue: selectedCity,
              listOfData: cityList,
              callBack: (GeneralFireBaseList? newValue){
                setState(() {
                  selectedCity = newValue ;
                });
              },
            ),


            SizedBox(height: size_H(20),),


            /// Education
            MyBtnSelector(
              // controller: TextEditingController(),
              title: "Education",
              hint: "Add Education",
              callback: !isEditable ? (){} : () {
                // EducationFormPage
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => EducationFormPage())).then((value) {
                  if(value != null){
                    value = value as Education ;
                    setState(() {
                      educations.add(value);
                    });
                  } else{
                    print("{value}_NULL");
                  }
                });
              },
            ),
            //educations
            if(educations.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                child: Column(
                  children: List.generate(educations.length, (index) {
                    Education _education = educations[index];
                    return Container(
                      height: size_H(40),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.s,
                        children: [
                          Expanded(child: Text("${index+1} - ${_education.universityName}" ,maxLines: 1 , overflow: TextOverflow.ellipsis , style: ourTextStyle(),)),
                          SizedBox(width: size_W(5),),
                          GestureDetector(
                              onTap: !isEditable ? (){} :  (){
                                // Confirmation
                                // 'Do you want to complete?'
                                MyConfirmationDialog().showConfirmationDialog(
                                  context: context,
                                  title: "Confirmation",
                                  body: "Do you want to remove this education?",
                                  saveBtn: "Remove",
                                  onSave: (){
                                    setState(() {
                                      educations.removeWhere((element) => element == _education);
                                    });
                                  },
                                );
                              },
                              child: Icon(Icons.remove_circle_outline_sharp))
                        ],
                      ),
                    ) ;
                  }),
                ),
              ),


            SizedBox(height: size_H(20),),

            /// Skills
            MyBtnSelector(
              // controller: TextEditingController(),
              title: "Skills",
              hint: "Add Skill",
              callback: !isEditable ? (){} : () {
                // SkillFormPage
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => SkillFormPage(skills:skills))).then((value) {
                  if(value != null){
                    print("${value}");
                    value = value as List<String> ;
                    setState(() {
                      skills = value! ;
                    });
                  } else{
                    print("{value}_NULL");
                  }

                });
              },
            ),

            if(skills.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.s,
                  children: [
                    Expanded(child: Text("${skills.length} skills Added" ,maxLines: 1 , overflow: TextOverflow.ellipsis , style: ourTextStyle(),)),
                    SizedBox(width: size_W(5),),
                    GestureDetector(
                        onTap: !isEditable ? (){} : (){
                          // Confirmation
                          // 'Do you want to complete?'
                          MyConfirmationDialog().showConfirmationDialog(
                            context: context,
                            title: "Confirmation",
                            body: "Do you want to remove all skill?",
                            saveBtn: "Remove",
                            onSave: (){
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
                    isEditable: isEditable ,
                    // controller: _country,
                    title: "Experience",
                    selectedValue: selectedFieldOfStudy,
                    listOfData: fieldOfStudyList,
                    callBack: !isEditable ? (_){} :(GeneralFireBaseList? newValue){
                      setState(() {
                        selectedFieldOfStudy = newValue ;
                      });
                    },
                  ),
                ),

                Expanded(
                  flex: 3,
                  child: MyDropDownWidgetNumber(
                    isEditable: isEditable ,
                    // controller: _country,
                    // title: "Field",
                    selectedValue: selectedDurationYear,
                    listOfData: durationYearList,
                    callBack: !isEditable ? (_){} : (int? newValue){
                      setState(() {
                        selectedDurationYear = newValue ;
                      });
                    },
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: MyDropDownWidget(
                    isEditable: isEditable ,
                    // controller: _country,
                    // title: "Field",
                    selectedValue: selectedDuration,
                    listOfData: durationList,
                    callBack: !isEditable ? (_){} : (GeneralFireBaseList? newValue){
                      setState(() {
                        selectedDuration = newValue ;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: size_H(20),),

            /// Licenses & Certification
            MyBtnSelector(
              // controller: TextEditingController(),
              title: "Licenses & Certification",
              hint: "Add Licenses & Certification",
              callback: !isEditable ? (){} : () {
                // LicensesOrCertificationFormPage
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => LicensesOrCertificationFormPage())).then((value) {
                  if(value != null){
                    value = value as LicensesOrCertification ;
                    setState(() {
                      licensesOrCertification.add(value);
                    });
                  } else{
                    print("{value}_NULL");
                  }
                });
              },
            ),
            //educations
            if(licensesOrCertification.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                child: Column(
                  children: List.generate(licensesOrCertification.length, (index) {
                    LicensesOrCertification _licensesOrCertification = licensesOrCertification[index];
                    return Container(
                      height: size_H(40),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.s,
                        children: [
                          Expanded(child: Text("${index+1} - ${_licensesOrCertification.name}" ,maxLines: 1 , overflow: TextOverflow.ellipsis , style: ourTextStyle(),)),
                          SizedBox(width: size_W(5),),
                          GestureDetector(
                              onTap: !isEditable ? (){} :  (){
                                // Confirmation
                                // 'Do you want to complete?'
                                MyConfirmationDialog().showConfirmationDialog(
                                  context: context,
                                  title: "Confirmation",
                                  body: "Do you want to remove this licenses or certification?",
                                  saveBtn: "Remove",
                                  onSave: (){
                                    setState(() {
                                      licensesOrCertification.removeWhere((element) => element == _licensesOrCertification);
                                    });
                                  },
                                );
                              },
                              child: Icon(Icons.remove_circle_outline_sharp))
                        ],
                      ),
                    ) ;
                  }),
                ),
              ),

            SizedBox(
              height: size_H(20),
            ),

            MyBtnSelector(
              // controller: TextEditingController(),
              title: "Interests",
              hint: "Add Interests",
              callback:!isEditable ? (){} : () {
                // InterestFormPage
                Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => InterestFormPage(interests:interests))).then((value) {
                  if(value != null){
                    print("${value}");
                    value = value as List<String> ;
                    setState(() {
                      interests = value! ;
                    });
                  } else{
                    print("{value}_NULL");
                  }
                });
              },
            ),
            if(interests.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.s,
                  children: [
                    Expanded(child: Text("${interests.length} interests Added" ,maxLines: 1 , overflow: TextOverflow.ellipsis , style: ourTextStyle(),)),
                    SizedBox(width: size_W(5),),
                    GestureDetector(
                        onTap: !isEditable ? (){} : (){
                          // Confirmation
                          // 'Do you want to complete?'
                          MyConfirmationDialog().showConfirmationDialog(
                            context: context,
                            title: "Confirmation",
                            body: "Do you want to remove all interests?",
                            saveBtn: "Remove",
                            onSave: (){
                              setState(() {
                                interests.clear();
                              });
                            },
                          );
                        },
                        child: Icon(Icons.remove_circle_outline_sharp))
                  ],
                ),
              ),


            SizedBox(height: size_H(20),),

            Column(
              children: [
                MyBtnSelector(
                  // controller: TextEditingController(),
                  title: "Upload CV",
                  hint: "Browse file",
                  iconWidget: Image.asset(ImagePath.uploadIcon , scale: 6),
                  callback: !isEditable ? (){} : () async {
                    // _showActionSheet(context);

                    final act = CupertinoActionSheet(
                        actions: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
                            child: CupertinoActionSheetAction(
                              child: Text('Browse' , style: ourTextStyle(fontSize: 15 , fontWeight: FontWeight.w500 , )),
                              onPressed: () async {
                                String? path = await pickFile();
                                if (path != null) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                          if(filePathCV != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0 , left: 8 ),
                              child: CupertinoActionSheetAction(
                                child: Text('Remove Selected' , style: ourTextStyle(fontSize: 15 , fontWeight: FontWeight.w500 ,  color: Theme_Information.Color_10)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() {
                                    filePathCV = null ;
                                  });
                                },
                              ),
                            )
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('Cancel', style: ourTextStyle( fontSize: 15 , fontWeight: FontWeight.w500 , color: Theme_Information.Color_10)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ));
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) => act);



                  },
                ),
                if(filePathCV != null)
                  Padding(
                    padding: const EdgeInsets.only( right: 20.0 , left: 20.0 , top: 5),
                    child: Container(
                      height: size_H(40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(filePathCV!.isNotEmpty ? "My CV" : "" , style: ourTextStyle(),),
                          GestureDetector(
                              onTap: !isEditable ? (){} : (){
                                // Confirmation
                                // 'Do you want to complete?'
                                MyConfirmationDialog().showConfirmationDialog(
                                  context: context,
                                  title: "Confirmation",
                                  body: "Do you want to remove your CV?",
                                  saveBtn: "Remove",
                                  onSave: (){
                                    setState(() {
                                      filePathCV = null ;
                                    });
                                  },
                                );
                              },
                              child: Icon(Icons.remove_circle_outline_sharp))
                        ],
                      ),
                    ),
                  )
              ],
            ),


            SizedBox(height: size_H(20),),

          ],
        ),
      ),
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
