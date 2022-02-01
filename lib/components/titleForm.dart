// A card with the recipe's image, author, and title.

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TitleForm extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double fontSize;
  final int maxLines;
  final Color color;
  TitleForm(
      {@required this.text,
      this.align,
      this.fontSize,
      this.maxLines,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Text(
        "$text",
        maxLines: maxLines,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
        ),
        textAlign: align,
      ),
    );
  }
}

class FixedSizeTitleForm extends StatelessWidget {
  final String text;
  final TextAlign align;
  final double fontSize;
  final int maxLines;
  final Color color;
  FixedSizeTitleForm(
      {this.text, this.align, this.fontSize, this.maxLines, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: AutoSizeText(
        text,
        maxLines: maxLines,
        maxFontSize: fontSize,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: color,
          fontFamily: Theme.of(context).textTheme.bodyText1.fontFamily,
        ),
        textAlign: align,
      ),
    );
  }
}
