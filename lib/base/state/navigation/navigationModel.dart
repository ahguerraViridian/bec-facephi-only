import 'package:flutter/material.dart';
import '../../../base/classes/allClasses.dart';
import 'buildRoutes.dart';
import '../../../utils/allUtils.dart';

class NavigationModel {
  String key = "/onboardingFacePhi";
  String iosKey = "/onboardingFacePhi";

  List<String> stack = [];
  Map<String, AppRoute> routes = allRoutes;

  Widget getContentRoute(key) {
    return routes[key].content;
  }

  bool isDrawerOpen = false;

  void setDrawerState(bool newState) {
    isDrawerOpen = newState;
  }

  bool getFullScreenDialogRoute(key) {
    return routes[key].fullScreenDialog;
  }

  Widget getInitialRoute({bool ios}) {
    if (ios) {
      key = iosKey;
      stack.add(iosKey);
      return routes[iosKey].content;
    }
    return routes[key].content;
  }

  // Widget getContentTabBar(key) {}

  // If root is true the route save the last route
  void setRoute(
      {String route, bool push = false, bool pushReplacement = false}) {
    if (pushReplacement) {
      stack = [route];
    }
    if (push) {
      stack.add(route);
    }
    key = route;
  }

  void removeUntil({String route, String routePredicate}) {
    String auxPredicate =
        routePredicate != null ? routePredicate : "/dashboard";
    for (int counter = stack.length - 1; counter >= 0; counter--) {
      if (stack[counter] != auxPredicate) {
        stack.removeAt(counter);
      } else {
        break;
      }
      if (counter > 0) {
        // counter--;
      } else {}
    }
    stack.add(route);
    key = route;
  }

  void removeRoutesUntil({String route}) {
    bool flag = true;
    List bk = stack;
    while (flag && bk.length > 0) {
      if (bk[bk.length - 1] != route) {
        bk.removeAt(bk.length - 1);
      } else {
        flag = false;
      }
    }
    if (!flag) {
      stack = bk;
    }
  }

  void backRoute() {
    stack.removeLast();
    key = stack[stack.length - 1];
  }

  void setIndexNavigationRoute(int ind) {
    routes[key].indexNavigation = ind;
  }

  void setIndexNavigationRouteKey(String tabKey) {
    int targetIndex = routes[key].pages.indexWhere(
          (element) => element.key == tabKey,
        );
    if (targetIndex != null) {
      routes[key].indexNavigation = targetIndex;
    }
  }

  void setIndexNavigation(int ind) {
    routes[key].setIndexNavigation(ind);
  }

  void setIndexNavigationByKey(int ind, String k) {
    if (routes[k] != null) {
      routes[k].setIndexNavigation(ind);
    }
  }

  //Return the pages from current route
  List<Widget> getContentPagesRoute() {
    return routes[key].getContentPages();
  }

  List<Widget> getContentPagesR() {
    return routes[key].getContentPagesR();
  }

  bool getTabNavigation() {
    return routes[key].getTabNavigation();
  }

  Widget getTabBar() {
    return routes[key].getTabBar();
  }

  bool getTabNavigationRoute() {
    return routes[key].tabNavigation;
  }

  List<Map> getIconPages() {
    return routes[key].getIconPages();
  }

  List<Map> getIconPagesR() {
    return routes[key].getIconPagesR();
  }

  List<Map> getIconPagesRoute() {
    return routes[key].getIconPages();
  }

  //Return the index navigation forn current Route
  int getIndexNavigation() {
    return routes[key].getIndexNavigation();
  }

  int getIndexNavigationRoute() {
    return routes[key].indexNavigation;
  }

  bool getBottomNavigationRoute() {
    return routes[key].bottomNavigation;
  }

  GlobalKey<ScaffoldState> getScaffoldKey() {
    //DynamicLog.devPrint('$key - ${routes[key].scaffoldKey.hashCode}');
    return routes[key].scaffoldKey;
  }

  GlobalKey<ScaffoldState> getScaffoldKeyWithIndex(String routeKey) {
    //DynamicLog.devPrint('$key - ${routes[routeKey].scaffoldKey.hashCode}');
    return routes[routeKey].scaffoldKey;
  }

  void printStackList() {
    DynamicLog.devPrint('--------CURRENT STACK--------');
    stack.forEach((route) {
      DynamicLog.devPrint(route);
    });
    DynamicLog.devPrint('----------------------');
  }

  void resetRoutes() {
    routes = allRoutes;
  }
}
