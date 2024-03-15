import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';

class MyBtnSelector extends StatefulWidget {
  MyBtnSelector({Key? key,
  // @required this.controller,
  required this.hint,
  required this.title,
  this.iconWidget,
  required this.callback,
  }) : super(key: key);
  final String? title ;
  final String? hint ;
  final Widget? iconWidget ;
  final Function() callback;

  @override
  State<MyBtnSelector> createState() => _MyBtnSelectorState();
}

class _MyBtnSelectorState extends State<MyBtnSelector> {
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
                child: Text("${widget.title}",style: ourTextStyle(color: Theme_Information.Primary_Color))),
          ),
          SizedBox(height: size_H(10),),
          GestureDetector(
            onTap: (){
              widget.callback();
            },
            child: Container(
              height: size_H(50),
              decoration: BoxDecoration(
                color: Theme_Information.Color_9,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Row(
                  children: [
                    SizedBox(width: size_W(30),),
                    if(widget.iconWidget != null)widget.iconWidget!,
                    if(widget.iconWidget == null) Icon(Icons.add , color: Theme_Information.Primary_Color,),
                    SizedBox(width: size_W(30),),
                    Text("${widget.title}" , style: ourTextStyle(color: Theme_Information.Primary_Color, fontWeight: FontWeight.w500),)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
