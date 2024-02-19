import 'package:flutter/material.dart';

import '../configuration/theme.dart';

class TitleSubTitleText extends StatelessWidget {
  const TitleSubTitleText({Key? key , @required this.title , this.subTitle}) : super(key: key);
  final String? title ;
  final String? subTitle ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(child: FittedBox(child: Text("${title}" ,style: ourTextStyle(color: Theme_Information.Primary_Color , fontSize: 22 , fontWeight: FontWeight.w600),))),
        if (subTitle != null)Center(child: FittedBox(child: Text("${subTitle}" ,style: ourTextStyle(color: Theme_Information.Color_7 , fontSize: 14 , fontWeight: FontWeight.w400),))),
      ],
    );
  }
}
