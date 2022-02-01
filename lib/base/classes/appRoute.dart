import 'package:flutter/material.dart';

import 'appPage.dart';

// A class Route need push replacement
class AppRoute {
  bool active; // Current active route
  String key;
  Widget content;
  List<AppPage> pages;
  Widget tabBar;
  IconData icon;
  Widget customIcon;
  String desc;
  String shortDesc;
  bool bottomNavigation;
  bool tabNavigation;
  int indexNavigation;
  bool fullScreenDialog = false;
  bool opaque = true;
  GlobalKey<ScaffoldState> scaffoldKey;

  AppRoute({
    this.key,
    this.pages,
    this.active = false,
    this.bottomNavigation,
    this.tabNavigation,
    this.tabBar,
    this.indexNavigation = 0,
    this.content,
    opaque = true,
    this.fullScreenDialog = false,
    this.scaffoldKey,
    this.customIcon,
    this.icon,
    this.desc,
    this.shortDesc,
  });

  List<Widget> getContentPages() {
    List<Widget> contentPages = [];
    pages.forEach((page) {
      contentPages.add(page.content);
    });
    return contentPages;
  }

  List<Widget> getContentPagesR() {
    if (pages.length > 0) {
      return pages[indexNavigation].getContentPagesR();
    } else {
      List<Widget> contentPages = [];
      pages.forEach((page) {
        contentPages.add(page.content);
      });
      return contentPages;
    }
  }

  List<Map> getIconPages() {
    List<Map> iconPages = [];
    pages.forEach((dynamic page) {
      iconPages.add(page.content.getIconTab());
    });
    return iconPages;
  }

  List<Map> getIconPagesR() {
    if (pages.length > 0) {
      if (pages[indexNavigation].pages.length <= 0) {
        List<Map> iconPages = [];
        pages.forEach((dynamic page) {
          iconPages.add(page.content.getIconTab());
        });
        return iconPages;
      } else {
        return pages[indexNavigation].getIconPagesR();
      }
    } else {
      return [];
    }
  }

  void setIndexNavigation(int ind) {
    if (tabNavigation) {
      indexNavigation = ind;
    } else {
      if (pages.length > 0) {
        pages[indexNavigation].setIndexNavigation(ind);
      }
    }
  }

  bool getTabNavigation() {
    if (pages.length > 0) {
      return pages[indexNavigation].getTabNavigation();
    } else {
      return tabNavigation;
    }
  }

  Widget getTabBar() {
    if (pages.length > 0) {
      return pages[indexNavigation].getTabBar();
    } else {
      return tabBar;
    }
  }

  bool getTabNavigationRoute() {
    return tabNavigation;
  }

  int getIndexNavigation() {
    if (pages.length > 0) {
      if (pages[indexNavigation].pages.length > 0) {
        return pages[indexNavigation].getIndexNavigation();
      } else {
        return indexNavigation;
      }
    }
    return -1;
  }

  int getIndexNavigationRoute() {
    return indexNavigation;
  }
}
