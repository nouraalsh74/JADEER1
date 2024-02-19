


import 'package:flutter/material.dart';
import 'package:loading_btn/loading_btn.dart';

import '../configuration/theme.dart';

class MyLoadingBtn extends StatelessWidget {
  final String? text ;
  final Function(Function startLoading, Function stopLoading, ButtonState btnState)? callBack ;
  final double? borderRadius ;
  final double? width ;
  final Color? color ;
  final Widget? icon ;
  const MyLoadingBtn({Key? key ,required this.text, required this.callBack , this.borderRadius , this.width, this.icon , this.color }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingBtn(
      height: size_H(40),
      borderRadius: borderRadius ?? 15,
      animate: true,
      color: color ?? Theme_Information.Primary_Color,
      width: width?? size_W(200),
      loader: Container(
        padding: const EdgeInsets.all(10),
        width: 40,
        height: 40,
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
      child:  Row(
        mainAxisAlignment: icon != null ? MainAxisAlignment.spaceAround :MainAxisAlignment.center,
        children: [
          Text("$text", style: ourTextStyle(fontSize: 15 , color: Theme_Information.Color_1)),
          if(icon != null)icon!,
        ],
      ),
      onTap: (startLoading, stopLoading, btnState) async {

        callBack!(startLoading, stopLoading, btnState);
        // if (btnState == ButtonState.idle) {
        //   startLoading();
        //   await Future.delayed(const Duration(seconds: 1));
        //   callBack!();
        //   stopLoading();
        // }
      },
    );
  }
}

