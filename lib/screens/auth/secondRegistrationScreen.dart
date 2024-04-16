
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/screens/auth/registeredSuccessfullyPage.dart';
import 'package:flutter_application_2/screens/auth/skillFormPage.dart';
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
import '../../models/userProfileModel.dart';
import '../../providers/dataProvider.dart';
import '../../providers/userProvider.dart';
import 'educationFormPage.dart';
import 'interestFormPage.dart';
import 'licensesOrCertificationFormPage.dart';

class RegistrationScreenStep2 extends StatefulWidget {
  const RegistrationScreenStep2({
    Key? key,
    this.firstName,
    this.lastName,
    this.id,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.country,
    this.city,
    this.password,
    this.confirmPassword,
  }) : super(key: key);
  final String? firstName ;
  final String? lastName ;
  final String? id ;
  final String? email ;
  final String? phoneNumber ;
  final String? dateOfBirth ;
  final GeneralFireBaseList? country ;
  final GeneralFireBaseList? city ;
  final String? password ;
  final String? confirmPassword ;

  @override
  State<RegistrationScreenStep2> createState() => _RegistrationScreenStep2State();
}

class _RegistrationScreenStep2State extends State<RegistrationScreenStep2> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size_H(30),),
              BackIcon(
                  onBack: (){
                    onWillPop(context);
                  }
              ),
              const TitleSubTitleText(
                title: "Continue setting your account",
              ),
              SizedBox(height: size_H(40),),
              /// Education
              MyBtnSelector(
                isRequired: true,
                // controller: TextEditingController(),
                title: "Education",
                hint: "Add Education",
                callback: () {
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
                                onTap: (){
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
                isRequired: true,
                // controller: TextEditingController(),
                title: "Skills",
                hint: "Add Skill",
                callback: () {
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
                          onTap: (){
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
                      // controller: _country,
                      title: "Experience",
                      selectedValue: selectedFieldOfStudy,
                      listOfData: fieldOfStudyList,
                      callBack: (GeneralFireBaseList? newValue){
                        setState(() {
                          selectedFieldOfStudy = newValue ;
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
                      callBack: (int? newValue){
                        setState(() {
                          selectedDurationYear = newValue ;
                        });
                      },
                    ),
                  ),


                  Expanded(
                    flex: 4,
                    child: MyDropDownWidget(
                      // controller: _country,
                      title: "Duration",
                      selectedValue: selectedDuration,
                      listOfData: durationList,
                      callBack: (GeneralFireBaseList? newValue){
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
                callback: () {
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
                                onTap: (){
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
                isRequired: true,
                // controller: TextEditingController(),
                title: "Interests",
                hint: "Add Interests",
                callback: () {
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
                          onTap: (){
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
                    isRequired: true,
                    // controller: TextEditingController(),
                    title: "Upload CV",
                    hint: "Browse file",
                    iconWidget: Image.asset(ImagePath.uploadIcon , scale: 6),
                    callback: () async {
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
                            Text("${filePathCV!.split("/").last}" , style: ourTextStyle(),),
                            GestureDetector(
                                onTap: (){
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

              MyLoadingBtn(
                borderRadius: 30,
                width: size_W(150),
                text: "Save",
                callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                  if (btnState == ButtonState.idle) {
                    if(educations.isEmpty){
                      EasyLoading.showError("Please add at least one education");
                      return ;
                    } else if(skills.length < 3){
                      EasyLoading.showError("Please select at least 3 skill");
                      return ;
                    } else if (interests.length < 3){
                      EasyLoading.showError("Please select at least 3 interest");
                      return ;
                    } else if (filePathCV== null || filePathCV!.isEmpty){
                      EasyLoading.showError("Please upload your cv");
                      return ;
                    } else{




                    // String? firstName ;
                    // String? lastName ;
                    // String? id ;
                    // String? email ;
                    // String? phoneNumber ;
                    // String? dateOfBirth ;
                    // GeneralFireBaseList? country ;
                    // GeneralFireBaseList? city ;
                    // String? password ;
                    // String? confirmPassword ;
                    // String? filePathCV;
                    // List<GeneralFireBaseList> fieldOfStudyList = [] ;
                    // GeneralFireBaseList? selectedFieldOfStudy ;
                    // List<GeneralFireBaseList> durationList = [] ;
                    // GeneralFireBaseList? selectedDuration ;
                    // List<int> durationYearList = [1 , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10] ;
                    // int? selectedDurationYear ;
                    // List<Education> educations = [];
                    // List<LicensesOrCertification> licensesOrCertification = [];
                    // List<String> skills = [];
                    // List<String> interests = [];
                    //



                    /*
                    first_name
                    last_name
                    ID
                    email
                    phone_number
                    date_of_birth
                    country_id
                    city_id
                    password
                    list of education (as object =>{university_id , degree_id , feild_of_study_id , start_date, end_date , grade})
                    skill (as list of strings)
                    list of experience (as object =>{feild_of_study_id , number_of_experience , year or month})
                    interests (list of string)
                    cv_path
                     */


                    Experience userExperience = Experience(
                      name: '${selectedFieldOfStudy?.name}',
                      numberOfYear: '${selectedDurationYear}',
                      durationName: '${selectedDuration?.name}',
                    );



                    UserProfile userProfile = UserProfile(
                      firstName: "${widget.firstName}",
                      lastName: '${widget.lastName}',
                      id: '${widget.id}',
                      email: '${widget.email}',
                      phoneNumber: '${widget.phoneNumber}',
                      dateOfBirth: widget.dateOfBirth,
                      countryId: '${widget.country!.id}',
                      cityId: '${widget.city!.id}',
                      password: '${widget.password}',
                      education: educations,
                      skills: skills,
                      experience: userExperience,
                      interests: interests,
                      cvPath: '',
                      licensesOrCertifications: licensesOrCertification,
                    );
                    Map<String, dynamic> userData = userProfile.toJson();


                    if (widget.password!= null) {
                      startLoading();
                      await Provider.of<UserProvider>(context , listen: false).registerUser(widget.email! , widget.password! , userData , filePathCV).then((value) {
                        if(value != null){
                          if(value == true){
                            stopLoading();
                            // RegisteredSuccessfullyPage
                            Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => RegisteredSuccessfullyPage()));
                            return;
                          } else{
                            stopLoading();

                            EasyLoading.showError("There is a problem , Please try again");
                          }
                        }
                      });



                    }
                    else{
                      EasyLoading.showError("Please Fill the Form");
                      return;
                    }
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

