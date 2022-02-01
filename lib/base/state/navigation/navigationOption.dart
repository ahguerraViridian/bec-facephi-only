import 'package:flutter/material.dart';

class NavigationOption {
  String title;
  String desc;
  Function onTap;
  bool isNew;
  bool isSettingsPrimary;
  IconData iconData;
  NavigationOption({
    this.title,
    this.desc,
    this.onTap,
    this.isNew = false,
    this.iconData,
    this.isSettingsPrimary = false,
  });
}
