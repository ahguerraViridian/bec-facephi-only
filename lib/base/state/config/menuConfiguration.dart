import 'package:flutter/foundation.dart';

class StMenuConfig {
  String menuType;
  List<StDeepLinkDataItem> deepLinkDataList = [];

  bool isMenuType(String valueToEvaluate) {
    if (menuType == null) return false;
    return menuType == valueToEvaluate;
  }

  List<StDeepLinkDataItem> getMenuEnabledDeepLinks() {
    List<StDeepLinkDataItem> result = [];
    for (StDeepLinkDataItem item in deepLinkDataList) {
      if (item.menuEnabled) result.add(item);
    }
    return result;
  }

  StMenuConfig({
    @required this.deepLinkDataList,
    @required this.menuType,
  });
}

class StDeepLinkDataItem {
  String description;
  String shortDescription;
  String hint;
  bool menuEnabled;
  String deepLink;
  bool isExternal;
  StDeepLinkDataItem({
    @required this.description,
    @required this.shortDescription,
    @required this.isExternal,
    @required this.menuEnabled,
    @required this.deepLink,
    @required this.hint,
  });
}
