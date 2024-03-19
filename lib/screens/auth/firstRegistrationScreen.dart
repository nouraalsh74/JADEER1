import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/auth/secondRegistrationScreen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_btn/loading_btn.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:provider/provider.dart';
import '../../commonWidgets/MyDatePicker.dart';
import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/customDatePickerTheme.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myDropDownWidget.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/theme.dart';
import '../../models/generalListFireBase.dart';
import '../../providers/dataProvider.dart';

class RegistrationScreenStep1 extends StatefulWidget {
  const RegistrationScreenStep1({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenStep1> createState() => _RegistrationScreenStep1State();
}

class _RegistrationScreenStep1State extends State<RegistrationScreenStep1> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _id = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _dateOfBirth = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  List<GeneralFireBaseList> countryList = [] ;
  GeneralFireBaseList? selectedCountry ;

  List<GeneralFireBaseList> cityList = [] ;
  GeneralFireBaseList? selectedCity ;

  DateTime _selectedDateOfBirth = DateTime.now();

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
                    onBack: (){
                      onWillPop(context);
                    }
                ),
                const TitleSubTitleText(
                  title: "Create an account,",
                  subTitle: "Let’s create account together",
                ),
                SizedBox(height: size_H(40),),
                /// _firstName
                MyTextForm(
                  isRequired: true,
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
                  isRequired: true,
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
                  isRequired: true,
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
                  isRequired: true,
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
                  isRequired: true,
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
                  onTap: (){
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
                    isRequired: true,
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
                  isRequired: true,
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
                  isRequired: true,
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
                SizedBox(height: size_H(10),),

                /// _password
                MyTextForm(
                  isRequired: true,
                  controller: _password,
                  isPassword: true,
                  isSuffixIcon: true,
                  title: "Password",
                  hint: "Enter Password",
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
                  isRequired: true,
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
                  width: size_W(150),
                  text: "Next",
                  callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                    if (btnState == ButtonState.idle) {
                      if(selectedCountry == null) {
                        EasyLoading.showError("Please Select Country");
                      }
                      else if(selectedCity == null) {
                        EasyLoading.showError("Please Select City");
                      }
                      else if(_password.text.isEmpty) {
                        EasyLoading.showError("Please fill the Password");
                      } else if (_formKey.currentState!.validate()) {
                        startLoading();
                        await Future.delayed(const Duration(seconds: 1));
                        // LoginPage
                        print("Done");
                        stopLoading();
                        if (context.mounted) {
                          Navigator.push(context, MyCustomRoute(builder: (BuildContext context) => RegistrationScreenStep2(
                            id: _id.text,
                            email: _email.text,
                            city:selectedCity,
                            password: _password.text,
                            confirmPassword:_confirmPassword.text,
                            country: selectedCountry,
                            dateOfBirth:_dateOfBirth.text,
                            firstName:_firstName.text,
                            lastName:_lastName.text,
                            phoneNumber: _phoneNumber.text,
                          )));
                        }
                        return;
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

