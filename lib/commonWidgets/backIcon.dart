import 'package:flutter/material.dart';

import '../configuration/images.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({Key? key , this.onBack , this.backWidget , this.titleWidget, this.padding}) : super(key: key);
  final Function()? onBack ;
  final Widget? backWidget ;
  final EdgeInsetsGeometry? padding ;
  final Widget? titleWidget ;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: titleWidget != null? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: (){
                if(onBack != null){
                  onBack!();
                  // Navigator.of(context).pop();
                } else{
                  Navigator.of(context).pop();
                }

              },
              child: backWidget ?? Image.asset("${ImagePath.backBtn}", scale: 3,)),
          if(titleWidget != null)titleWidget!,
          if(titleWidget != null)Opacity(opacity: 0, child: titleWidget!),
        ],
      ),
    );
  }
}