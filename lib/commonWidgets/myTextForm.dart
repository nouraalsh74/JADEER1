import 'package:flutter/material.dart';
import 'package:flutter_application_2/configuration/theme.dart';

class MyTextForm extends StatefulWidget {
  MyTextForm({Key? key,
  required this.controller,
  required this.hint,
  this.suffixIconBase,
  this.title,
  this.maxLength,
  this.prefixIcon,
    this.isRequired = false,
    this.isPassword = false,
    this.isSuffixIcon = false,
    this.enabled = true,
    this.isPadding = true,
    this.keyboardType,
    this.validator,
  }) : super(key: key);
  final String? title ;
  final String? hint ;
  final TextInputType? keyboardType ;
  final bool? isSuffixIcon ;
  final int? maxLength ;
  final bool? isPadding ;
  final bool isRequired ;
  final Widget? prefixIcon ;
  final Widget? suffixIconBase ;
  final bool? enabled ;
  late  bool isPassword  ;
  final TextEditingController? controller ;
  final String? Function(String?)? validator;

  @override
  State<MyTextForm> createState() => _MyTextFormState();
}

class _MyTextFormState extends State<MyTextForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0 , left: 8.0),
      child: Column(
        children: [
         if(widget.title != null) Row(
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
          if(widget.title != null) SizedBox(height: size_H(10),),
          TextFormField(
              keyboardType: widget.keyboardType,
              enabled: widget.enabled,
              obscureText: widget.isPassword ,
              controller: widget.controller,
              maxLength: widget.maxLength,
              style: ourTextStyle(),
              decoration: InputDecoration(
                errorStyle:ourTextStyle(color: Theme_Information.Color_10 , fontSize: 10) ,
                // suffixIcon: ,
                suffixIcon:  widget.suffixIconBase ?? suffixIcon(),
                prefixIcon: widget.prefixIcon,
                hintStyle: ourTextStyle(color: Theme_Information.Color_8),
                filled: true,
                hintText: "${widget.hint}",
                fillColor: Theme_Information.Color_9,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
               validator: widget.validator,
          ),
        ],
      ),
    );
  }

  Widget suffixIcon() {
    if (!widget.isSuffixIcon!) {
      return SizedBox();
    } else if(widget.enabled != null && !widget.enabled!){
      return Icon(Icons.keyboard_arrow_down);
    } else {
      return InkWell(
                  onTap: (){
                    setState(() {
                      widget.isPassword = !widget.isPassword ;
                    });
                  },
                  child: Icon(widget.isPassword ? Icons.remove_red_eye_outlined :
                  Icons.remove_red_eye
                  ));
    }
  }
}
