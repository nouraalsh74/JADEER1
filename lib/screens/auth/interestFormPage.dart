import 'package:flutter/material.dart';
import 'package:loading_btn/loading_btn.dart';

import '../../commonWidgets/backIcon.dart';
import '../../commonWidgets/myConfirmationDialog.dart';
import '../../commonWidgets/myLoadingBtn.dart';
import '../../commonWidgets/myTextForm.dart';
import '../../commonWidgets/titleSubTitleText.dart';
import '../../configuration/images.dart';
import '../../configuration/theme.dart';

class InterestFormPage extends StatefulWidget {
  const InterestFormPage({Key? key ,required this.interests}) : super(key: key);
  final List<String> interests ;
  @override
  State<InterestFormPage> createState() => _InterestFormPageState();
}

class _InterestFormPageState extends State<InterestFormPage> {
  TextEditingController _interestController = TextEditingController();
  List<String> _interests = [];
  List<String> _interestsSuggestions = ["Graphic Design" , "UI/UX" ,] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _interests.addAll(widget.interests) ;
    setState(() {});
  }

  void _addSkill({String? skill}) {
    String? newSkill ;
    if(skill != null){
      newSkill = skill ;
    } else{
      newSkill = _interestController.text.trim();
    }

    if (newSkill.isNotEmpty && !_interests.contains(newSkill)) {
      setState(() {
        _interests.add(newSkill!);
        _interestController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _interests.remove(skill);
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
                title: "Add Interest",
              ),
              SizedBox(height: size_H(40),),


              Padding(
                padding: const EdgeInsets.only(right: 8.0 , left: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: MyTextForm(
                        controller: _interestController,
                        // title: "Skills",
                        hint: "add interest",
                      ),
                    ),

                    Expanded(
                      child: InkWell(
                        onTap: (){
                          _addSkill();
                        },
                        child: IgnorePointer(
                          child: MyTextForm(
                            controller: TextEditingController(),
                            // title: "Skills",
                            hint: "+",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              
              SizedBox(height: size_H(10)),
              Text('Interests:' , style: ourTextStyle()),
              SizedBox(height: size_H(15)),
              Wrap(
                spacing: 8.0,
                children: _interests.map((skill) {
                  return Chip(
                    label: Text(skill),
                    onDeleted: () => _removeSkill(skill),
                  );
                }).toList(),
              ),

              SizedBox(height: size_H(15)),
              Padding(
                padding: const EdgeInsets.only(right: 15.0 , left: 15.0 , bottom: 8 , top: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Suggestions:' ,textAlign: TextAlign.left , style: ourTextStyle(color: Theme_Information.Primary_Color ,fontSize: 15))),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0 , left: 15.0),
                child: Divider(),
              ),
              Wrap(
                spacing: 8.0,
                children: _interestsSuggestions.map((skill) {
                  return Chip(
                    label: Text(skill),
                    deleteIcon: Icon(Icons.add_circle_outline , size: 20),
                    onDeleted: () => _addSkill(skill: skill),
                  );
                }).toList(),
              ),
              SizedBox(height: size_H(30)),


              MyLoadingBtn(
                borderRadius: 30,
                width: size_W(150),
                text: "Save",
                callBack: (Function startLoading, Function stopLoading, ButtonState btnState) async {
                  if (btnState == ButtonState.idle) {
                    // if (!_formKey.currentState!.validate()) {
                    if(_interests.isEmpty) {
                      MyConfirmationDialog().showConfirmationDialog(
                        context: context,
                        title: "Confirmation",
                        body: "Do you want to go back without adding any interest?",
                        saveBtn: "Back",
                        onSave: (){
                          Navigator.of(context).pop();
                        },
                      );
                    } else  {
                      startLoading();
                      await Future.delayed(const Duration(seconds: 1));
                      // LoginPage
                      print("Done");
                      stopLoading();
                      if (context.mounted) {
                        Navigator.of(context).pop(_interests);
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
