import 'package:flutter/material.dart';

class MultipleText extends StatelessWidget {
  final List<String> list;
  final String title;

  MultipleText({this.list, this.title});

  @override
  Widget build(BuildContext context) {
    List<Widget> res = [];

    res = list.map((String t) {
      if (t == null) {
        return Container();
      }
      return Text(
        t,
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1.color,
            fontWeight: FontWeight.w600,
            fontSize: 16.0),
      );
    }).toList();

    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                    TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
          ]..addAll(res)),
    );
  }
}
