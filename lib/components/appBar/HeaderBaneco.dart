import '../../themes/additionalThemeFeatures.dart';
import 'package:flutter/material.dart';

class HeaderBaneco extends StatelessWidget {
  final String img;
  HeaderBaneco({this.img});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(0.0),
      decoration: AdditionalThemeFeatures.getLightDecotarion(context),
      // color: Theme.of(context).primaryColor,
      height: 50.0,
      child: Container(
          child: Image.asset(
        img,
        height: 17.0,
      )),
    );
  }
}
