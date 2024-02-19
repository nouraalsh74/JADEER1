import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig {
  static double? _screenWidth;
  static double? _screenHeight;
  static double _blockWidth = 0;
  static double _blockHeight = 0;
  static bool? isPortrait;

  static double? textMultiplier;
  static double? imageSizeMultiplier;
  static double? heightMultiplier;
  static double? widthMultiplier;

  void init(BoxConstraints constraints, Orientation orientation) {
/*    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;

    }*/
    _screenWidth = constraints.maxWidth;
    _screenHeight = constraints.maxHeight;

    if (_screenWidth! < _screenHeight!){
      isPortrait = true;
    }else{
      isPortrait = false ;
    }

    _blockWidth =    _screenWidth! / 100  ;
    _blockHeight = _screenHeight! / 100  ;


    textMultiplier = _blockHeight  ;
    imageSizeMultiplier = _blockWidth ;
    heightMultiplier = _blockHeight ;
    widthMultiplier = _blockWidth ;

    print("_blockWidth= $_blockWidth");
    print("_blockHeight= $_blockHeight");
  }
}
