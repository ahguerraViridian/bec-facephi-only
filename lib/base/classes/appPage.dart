// A class Route not need push replacement
import 'package:flutter/material.dart';

class AppPage {
  String root;
  String key;
  GlobalKey<ScaffoldState> scaffoldKey;
  Widget content;
  List<AppPage> pages;
  bool bottomNavigation;
  bool tabNavigation;
  Widget tabBar;
  int indexNavigation;
  IconData icon;
  Widget customIcon;
  String description;
  String shortDesc;

  AppPage({
    this.root,
    this.key,
    this.content,
    this.pages = const [],
    this.bottomNavigation = false,
    this.tabNavigation = false,
    this.tabBar,
    this.scaffoldKey,
    this.indexNavigation = 0,
    this.customIcon,
    this.description,
    this.icon,
    this.shortDesc,
  });

  bool getTabNavigation() {
    if (pages.length > 0) {
      if (indexNavigation <= pages.length) {
        if (pages[indexNavigation].tabNavigation) {
          return pages[indexNavigation].getTabNavigation();
        } else {
          return tabNavigation;
        }
      } else {
        return tabNavigation;
      }
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

  int getIndexNavigation() {
    if (pages.length > 0) {
      //   if (pages[indexNavigation].pages.length > 0) {
      //     return pages[indexNavigation].getIndexNavigation();
      //   } else {
      return indexNavigation;
      // }
    }
    return -1;
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

  List<Widget> getContentPagesR() {
    // if (pages.length > 0) {
    //   return pages[indexNavigation].getContentPagesR();
    // }
    List<Widget> contentPages = [];
    pages.forEach((page) {
      contentPages.add(page.content);
    });
    return contentPages;
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
}
