import 'package:auto_size_text/auto_size_text.dart';
import '../utils/allUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OutlineCustomButtonBeco extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String color;
  final bool hasIcon;
  final IconData icon;
  final double simetricVertical;
  final int maxLines;
  final double topBotEdge;
  final double size;
  final double fontSize;
  final double minHeight;
  final double maxHeight;
  OutlineCustomButtonBeco(
      {this.onTap,
      this.label,
      this.icon,
      this.hasIcon,
      this.color = "enabled",
      this.simetricVertical: 0.0,
      this.topBotEdge = 7.0,
      this.size,
      this.fontSize = 16.0,
      this.maxLines,
      this.minHeight,
      this.maxHeight});
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
    } else {
      fillColor = null;
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
            minHeight: minHeight != null ? minHeight : 0,
            maxHeight: maxHeight != null ? maxHeight : double.infinity),
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: topBotEdge + simetricVertical,
            bottom: topBotEdge + simetricVertical,
            left: 20.0,
            right: 20.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.transparent,
            ),
            Flexible(
              fit: FlexFit.tight,
              child: AutoSizeText(
                label,
                maxLines: maxLines,
                maxFontSize: fontSize,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Icon(
              icon,
              color: hasIcon ? textColor : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
