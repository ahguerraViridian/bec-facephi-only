import '../utils/allUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OutlineSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final String color;
  final bool hasIcon;
  final IconData icon;
  final double simetricVertical;
  final double topBotEdge;
  final double size;
  OutlineSmallButton({
    this.onTap,
    this.label,
    this.icon,
    @required this.hasIcon,
    this.color = "enabled",
    this.simetricVertical: 0.0,
    this.topBotEdge = 10.0,
    this.size,
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
    } else {
      cColor = Theme.of(context).disabledColor;
      borderColor = cColor;
      textColor = cColor;
      fillColor = null;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: topBotEdge + simetricVertical,
            bottom: topBotEdge + simetricVertical,
            left: 5.0,
            right: 5.0),
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.0,
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
