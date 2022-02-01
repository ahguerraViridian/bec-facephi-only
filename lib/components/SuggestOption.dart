import 'package:flutter/material.dart';

class SuggestOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final String bottomtitle;
  final IconData icon;
  SuggestOption({this.title, this.subtitle, this.bottomtitle, this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 2.0, bottom: 2.0, left: 5.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title != null
                        ? Text(
                            "$title",
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.w600),
                          )
                        : Container(),
                    subtitle != null
                        ? Text(
                            "$subtitle",
                            style: TextStyle(fontSize: 13.0),
                          )
                        : Container(),
                    bottomtitle != null
                        ? Text("$bottomtitle",
                            style: TextStyle(color: Colors.black38))
                        : Container(),
                  ],
                ),
              ),
              icon != null
                  ? Padding(
                    padding: const EdgeInsets.only(right:8.0),
                    child: Icon(icon,
                        color: Theme.of(context).textTheme.headline2.color),
                  )
                  : Container()
            ],
          ),
          Divider()
        ]));
  }
}
