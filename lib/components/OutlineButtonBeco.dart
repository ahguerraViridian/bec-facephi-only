import '../utils/allUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OutlineButtonBeco extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String color;
  final double simetricVertical;
  final double simetricHorizontal;
  final int maxLines;
  OutlineButtonBeco({
    this.onTap,
    @required this.label,
    this.color = "enabled",
    this.simetricVertical: 0.0,
    this.simetricHorizontal = 20,
    this.maxLines,
  });
  @override
  Widget build(BuildContext context) {
    Color cColor;
    Color borderColor;
    Color textColor;
    Color fillColor;
    if (color == "enabled") {
      cColor = Theme.of(context).primaryColor;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "light") {
      cColor = Theme.of(context).primaryColorLight;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "disabled") {
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "transparent") {
      cColor = Colors.transparent;
      borderColor = cColor;
      textColor = cColor;
    } else {
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: 10.0 + simetricVertical,
            bottom: 10.0 + simetricVertical,
            left: simetricHorizontal,
            right: simetricHorizontal),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(5.0),
          border: Border(
              top: BorderSide(width: 2.0, color: borderColor),
              bottom: BorderSide(width: 2.0, color: borderColor),
              left: BorderSide(width: 2.0, color: borderColor),
              right: BorderSide(width: 2.0, color: borderColor)),
        ),
        child: Text(
          label,
          maxLines: maxLines,
          style: TextStyle(color: textColor, fontSize: 16.0),
        ),
      ),
    );
  }
}

class OutlineIconButtonBeco extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String color;
  final double simetricVertical;
  final double simetricHorizontal;
  final Widget icon;
  OutlineIconButtonBeco(
      {this.onTap,
      @required this.label,
      @required this.icon,
      this.color = "enabled",
      this.simetricVertical: 2.5,
      this.simetricHorizontal = 20});
  @override
  Widget build(BuildContext context) {
    Color cColor;
    Color borderColor;
    Color textColor;
    Color fillColor;
    if (color == "enabled") {
      cColor = Theme.of(context).primaryColor;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "light") {
      cColor = Theme.of(context).primaryColorLight;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "disabled") {
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    } else if (color == "transparent") {
      cColor = Colors.transparent;
      borderColor = cColor;
      textColor = cColor;
    } else {
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: simetricVertical,
            bottom: simetricVertical,
            left: simetricHorizontal,
            right: simetricHorizontal),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(5.0),
          border: Border(
              top: BorderSide(width: 2.0, color: borderColor),
              bottom: BorderSide(width: 2.0, color: borderColor),
              left: BorderSide(width: 2.0, color: borderColor),
              right: BorderSide(width: 2.0, color: borderColor)),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                label,
                style: TextStyle(color: textColor, fontSize: 16.0),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
