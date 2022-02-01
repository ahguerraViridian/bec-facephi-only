import 'package:flutter/material.dart';

import 'allComponents.dart';

class MainDropDownLabel extends StatelessWidget {
  final bool areTransactionsOpen;
  final String label;
  final EdgeInsets padding;
  final EdgeInsets subtitlePadding;
  final double fontSize;
  MainDropDownLabel({
    this.label,
    this.areTransactionsOpen,
    this.padding = const EdgeInsets.only(top: 10.0, bottom: 0.0),
    this.subtitlePadding,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return areTransactionsOpen
        ? Row(
            children: <Widget>[
              SubtitleForm(
                align: TextAlign.left,
                fontSize: fontSize,
                text: label,
                padding: subtitlePadding,
              ),
              Padding(
                padding: padding,
                child: Icon(
                  Icons.expand_less,
                  color: Theme.of(context).textTheme.headline2.color,
                ),
              )
            ],
          )
        : Row(
            children: <Widget>[
              SubtitleForm(
                color: areTransactionsOpen
                    ? Theme.of(context).textTheme.headline2.color
                    : Theme.of(context).primaryColor,
                align: TextAlign.left,
                fontSize: fontSize,
                text: label,
                padding: subtitlePadding,
              ),
              Padding(
                padding: padding,
                child: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          );
  }
}
