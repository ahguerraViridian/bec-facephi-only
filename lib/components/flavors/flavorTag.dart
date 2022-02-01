import '../../config/config.dart';
import 'package:flutter/material.dart';

class FlavorTag extends StatelessWidget {
  final double fontSize;
  final EdgeInsets padding;
  FlavorTag({
    this.fontSize = 25,
    this.padding = const EdgeInsets.all(5),
  });
  @override
  Widget build(BuildContext context) {
    String tagLabel = "";
    Color color = Colors.white;
    switch (Config.appFlavor) {
      case Flavor.BETA:
        tagLabel = "BETA";
        color = Colors.blue;
        // color = Colors.purple;
        break;
      case Flavor.DEMO:
        tagLabel = "DEMO";
        color = Colors.blue;
        // color = Colors.deepPurple;
        break;
      case Flavor.DEV:
        tagLabel = "DEV";
        color = Colors.blue;
        break;
      case Flavor.PREPROD:
        tagLabel = "PREPROD";
        color = Colors.blue;
        // color = Colors.greenAccent;
        break;
      case Flavor.PROD:
        tagLabel = "PROD";
        color = Colors.blue;
        // color = Colors.transparent;
        break;
      case Flavor.STAGE:
        tagLabel = "STAGE";
        color = Colors.blue;
        // color = Colors.lightGreenAccent;
        break;
      case Flavor.STAGE_V:
        tagLabel = "STAGE V";
        color = Colors.blue;
        // color = Colors.purple;
        break;
      case Flavor.TEST:
        tagLabel = "TEST";
        color = Colors.blue;
        // color = Colors.yellow;
        break;
      default:
    }
    return Config.appFlavor == Flavor.PROD
        ? Container()
        : Container(
            color: color,
            padding: padding,
            child: Text(tagLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColorLight,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900)));
  }
}
