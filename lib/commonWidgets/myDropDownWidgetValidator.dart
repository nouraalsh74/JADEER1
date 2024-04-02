import 'package:flutter/material.dart';

import '../configuration/theme.dart';
import '../models/generalListFireBase.dart';

class MyDropDownWidgetValidator extends StatefulWidget {
  MyDropDownWidgetValidator(
      {Key? key, required this.listOfData,    this.validator, this.title,required this.callBack, required this.selectedValue , this.isEditable = true, this.isRequired = true})
      : super(key: key);
  late GeneralFireBaseList? selectedValue ;
  final String? title ;
  final bool? isEditable ;
  final bool  isRequired ;
  final String? Function(GeneralFireBaseList?)? validator;
  final Function(GeneralFireBaseList? newValue)? callBack ;
  final List<GeneralFireBaseList>? listOfData ;

  @override
  State<MyDropDownWidgetValidator> createState() => _MyDropDownWidgetValidatorState();
}

class _MyDropDownWidgetValidatorState extends State<MyDropDownWidgetValidator> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 0.0 , left: 0.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Text("${widget.title}", style: ourTextStyle(color: Theme_Information.Primary_Color))),
                ),
                if(widget.isRequired)
                  Text("*" , style: ourTextStyle(color: Theme_Information.Color_10 , fontSize: 15),)
              ],
            ),
          ),
          SizedBox(height: size_H(10),),
          Container(
            height: size_H(45),
            child: Center(
              child: IgnorePointer(
                ignoring: !widget.isEditable!,
                child: DropdownButtonFormField<GeneralFireBaseList>(

                  validator: widget.validator,
                  borderRadius: BorderRadius.circular(15.0),
                  isExpanded: true,
                  dropdownColor: Theme_Information.Color_9,
                  padding: const EdgeInsets.only(right: 8 , left: 8),
                  decoration:  InputDecoration(
                    hintText: "Choose ${widget.title}",
                    hintStyle: ourTextStyle(fontSize: 13 , color: Theme_Information.Color_7),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                      const BorderSide(color: Colors.transparent, width: 0),
                    ),
                    errorStyle: ourTextStyle(color: Theme_Information.Color_10 , fontSize: 10),
                    border: InputBorder.none, // Removes the default underline
                    fillColor: Theme_Information.Color_9,
                    filled: true,
                  ),
                  // underline: Container(),
                  value: widget.selectedValue,
                  onChanged: (GeneralFireBaseList? newValue) {
                    widget.callBack!(newValue);
                  },
                  items: widget.listOfData!.map((GeneralFireBaseList value) {
                    return DropdownMenuItem<GeneralFireBaseList>(
                      value: value,
                      child: Text("${value.name}" , style: ourTextStyle(color: Theme_Information.Color_5)),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }


}
