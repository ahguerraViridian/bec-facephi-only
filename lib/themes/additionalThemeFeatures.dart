import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AdditionalThemeFeatures {
  static BoxDecoration getLightDecotarion(BuildContext context,
      {Alignment backgroundImgAlignment = Alignment.center,
      ImageProvider<Object> customImageProvider}) {
    BoxDecoration boxDecotarion = BoxDecoration(
      color: Theme.of(context).primaryColor,
    );
    return boxDecotarion;
  }
}
