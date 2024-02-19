import 'package:flutter/material.dart';

import '../configuration/images.dart';
import '../configuration/theme.dart';

class HomePageItem extends StatelessWidget {
  final String text;
  final Function() callBack;

  HomePageItem({required this.text , required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          callBack();
        },
        child: Stack(
          children: [
            Image.asset("${ImagePath.homePageBox}", scale: 3),
            Positioned.fill(
              top: 25,
              left: 25,
              right: 25,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8),
                  child: Text(
                    text,
                    maxLines: 2,
                    style: ourTextStyle(color: Theme_Information.Color_1),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}