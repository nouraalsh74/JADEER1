import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_application_2/providers/dataProvider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:provider/provider.dart';

import '../../commonWidgets/MyDatePicker.dart';
import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myDropDownWidget.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/theme.dart';
import '../../models/generalListFireBase.dart';
import '../../models/userProfileModel.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({Key? key}) : super(key: key);

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {

  List<GeneralFireBaseList> universitiesList = [] ;
  GeneralFireBaseList? selectedUniversity ;

  List<GeneralFireBaseList> degreeList = [] ;
  GeneralFireBaseList? selectedDegree ;

  List<GeneralFireBaseList> fieldOfStudyList = [] ;
  GeneralFireBaseList? selectedFieldOfStudy ;


  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  final TextEditingController _fromDate = TextEditingController();
  final TextEditingController _toDate = TextEditingController();
  final TextEditingController _grade = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      EasyLoading.show();
      universitiesList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("universities" , universitiesList);
      degreeList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("degree" , degreeList);
      fieldOfStudyList.clear();
      await Provider.of<DataProvider>(context, listen: false).fetchDataFromFirestore("field_of_study" , fieldOfStudyList);
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: size_H(30),),
                BackIcon(
                  backWidget: Padding(
                    padding: const EdgeInsets.only(right: 8.0 , left: 8),
                    child: Image.asset("${ImagePath.removeIcon}" , scale: 4 ),
                  ),
                    onBack: (){
                      onWillPop(context);
                    }
                ),
                const TitleSubTitleText(
                  title: "Add Education",
                ),
                SizedBox(height: size_H(40),),

                /// universities
                MyDropDownWidget(
                  // controller: _country,
                  title: "University",
                  selectedValue: selectedUniversity,
                  listOfData: universitiesList,
                  callBack: (GeneralFireBaseList? newValue){
                    setState(() {
                      selectedUniversity = newValue ;
                    });
                  },
                ),
                SizedBox(height: size_H(10),),

                /// degree
                MyDropDownWidget(
                  // controller: _country,
                  title: "Degree",
                  selectedValue: selectedDegree,
                  listOfData: degreeList,
                  callBack: (GeneralFireBaseList? newValue){
                    setState(() {
                      selectedDegree = newValue ;
                    });
                  },
                ),
                SizedBox(height: size_H(10),),


             /// field of Study
                MyDropDownWidget(
                  // controller: _country,
                  title: "field of Study",
                  selectedValue: selectedFieldOfStudy,
                  listOfData: fieldOfStudyList,
                  callBack: (GeneralFireBaseList? newValue){
                    setState(() {
                      selectedFieldOfStudy = newValue ;
                    });
                  },
                ),
                SizedBox(height: size_H(10),),

                /// from date
                GestureDetector(
                  onTap: (){
                    MyDatePicker().selectDate(context , _selectedFromDate).then((value) {
                      if(value != null){
                        setState(() {
                          final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
                          _fromDate.text = serverFormater.format(value);
                        });
                      }
                    });
                  },
                  child: MyTextForm(
                    isRequired: true,
                    enabled: false,
                    controller: _fromDate,
                    title: "Start date",
                    hint: "Choose Date",
                  ),
                ),
                SizedBox(height: size_H(10),),


                /// to date
                GestureDetector(
                  onTap: (){
                    MyDatePicker().selectDate(context , _selectedToDate).then((value) {
                      if(value != null){
                        setState(() {
                          final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
                          _toDate.text = serverFormater.format(value);
                        });
                      }
                    });
                  },
                  child: MyTextForm(
                    isRequired: true,
                    enabled: false,
                    controller: _toDate,
                    title: "End date (or expected)",
                    hint: "Choose Date",
                    // validator: ,
                  ),
                ),
                SizedBox(height: size_H(10),),

                /// Grade
                MyTextForm(
                  isRequired: true,
                  controller: _grade,
                  title: "Grade (Ex: 4/5)",
                  hint: "Enter Your Grade",
                  // keyboardType: TextInputType.numberWithOptions,
                  validator: (String? value) {
                    // Define the regular expression to match the format "x/x"
                    RegExp regExp = RegExp(r'^\d+(\.\d+)?\/\d+$');

                    // Check if the input matches the regular expression
                    if (value == null || !regExp.hasMatch(value!)) {
                      return 'Please enter a fraction like thid format "4/5"';
                    }

                    // If input is valid, return null
                    return null;
                  },
                ),

                SizedBox(height: size_H(10),),

                MyLoadingBtn(
                  borderRadius: 30,
                  width: size_W(150),
                  text: "Save",
                  callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                    if (btnState == ButtonState.idle) {

                      if(selectedUniversity == null) {
                        EasyLoading.showError("Please Select University");
                      }
                      else if(selectedDegree == null) {
                        EasyLoading.showError("Please Select Degree");
                      }
                      else if(selectedFieldOfStudy == null) {
                        EasyLoading.showError("Please Select Field of Study");
                      }
                      else if(_grade.text.isEmpty ) {
                        EasyLoading.showError("Please fill the grade");
                      }
                      else  if (!_formKey.currentState!.validate()) {
                        EasyLoading.showError("Please fill the correct grade");
                      }
                      else if(_fromDate.text.isEmpty ||  _toDate.text.isEmpty) {
                        EasyLoading.showError("Please fill the start and end date");
                      } else  {
                        startLoading();
                        await Future.delayed(const Duration(seconds: 1));
                        // LoginPage
                        print("Done");
                        stopLoading();
                        if (context.mounted) {
                          Education education = Education(
                            degreeId: selectedDegree!.id,
                            degreeName: selectedDegree!.name,
                            fieldId: selectedFieldOfStudy!.id,
                            fieldName: selectedFieldOfStudy!.name,
                            universityId: selectedUniversity!.id,
                            universityName: selectedUniversity!.name,
                            startDate: _fromDate.text,
                            endDate: _toDate.text,
                          );
                          Navigator.of(context).pop(education);
                        }
                        return;
                      }
                    }
                  },
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
  String? _validateInputV(String value) {
    // Define the regular expression to match the format "x/x"
    RegExp regExp = RegExp(r'^\d+\/\d+$');

    // Check if the input matches the regular expression
    if (!regExp.hasMatch(value)) {
      return 'Please enter a fraction like thid format "4/5"';
    }

    // If input is valid, return null
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
