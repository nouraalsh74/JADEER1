import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/images.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:loading_btn/loading_btn.dart';

import '../../commonWidgets/MyDatePicker.dart';
import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myDropDownWidget.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/theme.dart';
import '../../models/educationModel.dart';
import '../../models/generalListFireBase.dart';
import '../../models/licensesOrCertificationModel.dart';

class LicensesOrCertificationFormPage extends StatefulWidget {
  const LicensesOrCertificationFormPage({Key? key}) : super(key: key);

  @override
  State<LicensesOrCertificationFormPage> createState() => _LicensesOrCertificationFormPageState();
}

class _LicensesOrCertificationFormPageState extends State<LicensesOrCertificationFormPage> {


  DateTime _selectedFromDate = DateTime.now();
  DateTime _selectedToDate = DateTime.now();
  final TextEditingController _fromDate = TextEditingController();
  final TextEditingController _toDate = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _issuingOrganization = TextEditingController();


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
                title: "Add Licenses Or Certification",
              ),
              SizedBox(height: size_H(40),),


              /// Name
              MyTextForm(
                controller: _name,
                title: "Name",
                hint: "Enter licenses or certification name",
              ),

              SizedBox(height: size_H(10),),

              /// Issuing organization
              MyTextForm(
                controller: _issuingOrganization,
                title: "Issuing organization",
                hint: "Enter issuing organization",
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
                  enabled: false,
                  controller: _toDate,
                  title: "End date (or expected)",
                  hint: "Choose Date",
                ),
              ),
              SizedBox(height: size_H(10),),


              MyLoadingBtn(
                borderRadius: 30,
                width: size_W(150),
                text: "Save",
                callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                  if (btnState == ButtonState.idle) {
                    if (_name.text.isEmpty &&
                        _issuingOrganization.text.isEmpty &&
                        _fromDate.text.isEmpty &&
                        _toDate.text.isEmpty) {
                      MyConfirmationDialog().showConfirmationDialog(
                        context: context,
                        title: "Confirmation",
                        body: "Do you want to go back without add any licenses or certification?",
                        saveBtn: "Back",
                        onSave: (){
                          Navigator.of(context).pop();
                        },
                      );
                    }
                    // else if (_name.text.isEmpty ||
                    //     _issuingOrganization.text.isEmpty ||
                    //     _fromDate.text.isEmpty ||
                    //     _toDate.text.isEmpty) {
                    //   MyConfirmationDialog().showConfirmationDialog(
                    //     context: context,
                    //     title: "Confirmation",
                    //     body: "Do you want to go back without fill all information?",
                    //     saveBtn: "Back",
                    //     onSave: (){
                    //       if (context.mounted) {
                    //         LicensesOrCertification tempLicensesOrCertification = LicensesOrCertification(
                    //           name: _name.text,
                    //           issuingOrganization:  _issuingOrganization.text,
                    //           startDate: _fromDate.text,
                    //           endDate: _toDate.text,
                    //         );
                    //         Navigator.of(context).pop(tempLicensesOrCertification);
                    //       }
                    //     },
                    //   );
                    // }
                    else {
                      startLoading();
                      await Future.delayed(const Duration(seconds: 1));
                      // LoginPage
                      print("Done");
                      stopLoading();
                      if (context.mounted) {
                        LicensesOrCertification tempLicensesOrCertification = LicensesOrCertification(
                          name: _name.text,
                          issuingOrganization:  _issuingOrganization.text,
                          startDate: _fromDate.text,
                          endDate: _toDate.text,
                        );
                        Navigator.of(context).pop(tempLicensesOrCertification);
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
