import 'dart:core';

import '../../../base/classes/allClasses.dart';
import '../../../routes/config.dart';
import '../../../utils/allUtils.dart';

// Import the screens

Map<String, AppRoute> allRoutes = buildR();

Map<String, AppRoute> buildR() {
  Map<String, AppRoute> ls = {};
  screenGlobalConfiguration.forEach((conf) {
    if (conf["route"] is AppRoute) {
      ls..addAll({conf["key"]: conf["route"]});
    }
    if (conf["route"] == null) {
      if (conf["type"] != null && conf["type"] == "page") {
        ls
          ..addAll({
            conf["key"]: AppRoute(
              scaffoldKey: conf["scaffoldKey"],
              key: conf["key"],
              bottomNavigation: conf["bottomNavigation"],
              tabNavigation: conf["tabNavigation"],
              tabBar: conf["tabBar"] != null ? conf["tabBar"] : null,
              content: conf["view"],
              pages: [],
              icon: conf["icon"],
              customIcon: conf["customIcon"],
              desc: conf["description"],
              shortDesc: conf["shortDescription"],
            )
          });
      } else {
        ls
          ..addAll({
            conf["key"]: AppRoute(
                scaffoldKey: conf["scaffoldKey"],
                key: conf["key"],
                bottomNavigation: conf["bottomNavigation"],
                tabNavigation: conf["tabNavigation"],
                tabBar: conf["tabBar"] != null ? conf["tabBar"] : null,
                content: conf["view"],
                pages: _buildPages(conf["pages"]))
          });
      }
    }
  });
  return ls;
}

List<AppPage> _buildPages(List pages) {
  List<AppPage> ls = [];
  pages.forEach((conf) {
    Map pag = screenGlobalConfFindByKey(conf["key"]);
    if (pag != null) {
      ls
        ..add(AppPage(
            scaffoldKey: pag["scaffoldKey"] != null ? pag["scaffoldKey"] : null,
            key: pag["key"],
            root: pag["root"],
            content: pag["view"],
            bottomNavigation: pag["bottomNavigation"],
            tabNavigation: pag["tabNavigation"],
            // tabBar: pag["tabBar"] != null ? pag["tabBar"] : null,
            tabBar: pag["tabBar"],
            pages: pag["pages"] != null ? _buildPages(pag["pages"]) : [],
            icon: pag["icon"],
              customIcon: pag["customIcon"],
              description: pag["description"],
              shortDesc: pag["shortDescription"],
            ));
      DynamicLog.devPrint("${pag["tabBar"]}");
    }
  });
  return ls;
}
