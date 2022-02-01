// A card with the recipe's image, author, and title.

import 'package:flutter/material.dart';

class SubtitleForm extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color color;
  final FontWeight fontWeight;
  SubtitleForm(
      {this.padding, this.text, this.align, this.fontSize, this.color,
      this.fontWeight =FontWeight.w600,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null
          ? padding
          : EdgeInsets.only(left: 15.0, right: 5.0, top: 8.0, bottom: 0.0),
      child: Text(
        text,
        style: TextStyle(
            color: color != null
                ? color
                : Theme.of(context).textTheme.headline2.color,
            fontSize: fontSize,
            fontWeight: fontWeight),
        textAlign: align,
      ),
    );
  }
}

class SubtitleCustom extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  SubtitleCustom({this.text, this.align, this.fontSize, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding != null
          ? padding
          : EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0, bottom: 0.0),
      child: Text(
        text,
        style: TextStyle(
            color: Theme.of(context).textTheme.headline2.color,
            fontSize: fontSize,
            fontWeight: FontWeight.w600),
        textAlign: align,
      ),
    );
  }
}
