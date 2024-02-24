import 'package:flutter/material.dart';

import '../configuration/theme.dart';
import '../models/generalListFireBase.dart';

class MyDropDownWidgetNumber extends StatefulWidget {
  MyDropDownWidgetNumber(
      {Key? key, required this.listOfData, this.title,required this.callBack, required this.selectedValue, this.isEditable = true})
      : super(key: key);
  late int? selectedValue ;
  final String? title ;
  final bool? isEditable ;
  final Function(int? newValue)? callBack ;
  final List<int>? listOfData ;

  @override
  State<MyDropDownWidgetNumber> createState() => _MyDropDownWidgetNumberState();
}

class _MyDropDownWidgetNumberState extends State<MyDropDownWidgetNumber> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
      child: Column(
        children: [
            Padding(
            padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(widget.title??"", style: ourTextStyle(color: Theme_Information.Primary_Color))),
          ),
          SizedBox(height: size_H(10),),
          Container(
            height: size_H(45),
            decoration: BoxDecoration(
              color: Theme_Information.Color_9,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child:  IgnorePointer(
    ignoring: !widget.isEditable!,
                child: DropdownButton<int>(

                  borderRadius: BorderRadius.circular(15.0),
                  isExpanded: true,
                  padding: const EdgeInsets.only(right: 15 , left: 15),
                  underline: Container(),
                  value: widget.selectedValue,
                  onChanged: (int? newValue) {
                    widget.callBack!(newValue);
                  },
                  items: widget.listOfData!.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text("${value}" , style: ourTextStyle(color: Theme_Information.Color_5)),
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
