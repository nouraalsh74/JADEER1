import 'package:flutter/material.dart';

import '../configuration/theme.dart';
import '../models/generalListFireBase.dart';

class MyDropDownWidget extends StatefulWidget {
  MyDropDownWidget(
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
  State<MyDropDownWidget> createState() => _MyDropDownWidgetState();
}

class _MyDropDownWidgetState extends State<MyDropDownWidget> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
      child: Column(
        children: [
          Row(
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
          SizedBox(height: size_H(10),),
          Container(
            decoration: BoxDecoration(
              color: Theme_Information.Color_9,
              borderRadius: BorderRadius.circular(15.0),
            ),
            height: size_H(45),
            child: Center(
              child: IgnorePointer(
                ignoring: !widget.isEditable!,
                child: DropdownButton<GeneralFireBaseList>(
                  borderRadius: BorderRadius.circular(15.0),
                  isExpanded: true,
                  dropdownColor: Theme_Information.Color_9,
                  padding: const EdgeInsets.only(right: 8 , left: 8),
                  underline: Container(),

                  value: widget.selectedValue,
                  onChanged: (GeneralFireBaseList? newValue) {
                    widget.callBack!(newValue);
                  },
                  items: widget.listOfData!.map((GeneralFireBaseList value) {
                    return DropdownMenuItem<GeneralFireBaseList>(
                      value: value,
                      child: Text("${value.name}" ,maxLines: 5, style: ourTextStyle(color: Theme_Information.Color_5 , fontSize: 11)),
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
