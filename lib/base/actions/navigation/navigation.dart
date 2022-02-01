import 'package:flutter/foundation.dart';

class XNavigation {
  bool reset = false; // Reset the navigation for logout
  String route;
  String pushReplacementPredicate;
  bool push;
  bool pushReplacement;
  bool removeUntil;
  bool pop;
  bool isModalDialog;
  int index;
  dynamic payload;
  dynamic payloadState; //Payload to state
  XNavigation(
      {this.route,
      this.pushReplacementPredicate,
      this.index = 0,
      this.payload,
      this.payloadState,
      this.push = false,
      this.pop = false,
      this.isModalDialog = false,
      this.pushReplacement = false,
      this.removeUntil = false});

  String getRoute() => this.route;
  dynamic getPayload() => this.payload;
}

class XBottomNavigation {
  int tab;
  dynamic payload;
  XBottomNavigation({this.tab, this.payload = Null});

  int getRoute() => this.tab;
  dynamic getPayload() => this.payload;
}

class XBottomNavigationKey {
  String key;

  XBottomNavigationKey({
    @required this.key,
  });
}

class XBottomNavigationOrder {
  int bottomIndexTarget;
  String bottomTabKey;

  XBottomNavigationOrder({
    @required this.bottomTabKey,
    @required this.bottomIndexTarget,
  });
}

class XTabNavigation {
  int tab;
  dynamic payload;
  XTabNavigation({this.tab, this.payload = Null});
  int getRoute() => this.tab;
  dynamic getPayload() => this.payload;
}

class XBackNavigation {
  bool pop;
  String routeUntil;
  bool popModal;

  dynamic payload;
  XBackNavigation(
      {this.routeUntil,
      this.payload = Null,
      this.pop = false,
      this.popModal = false});

  dynamic getPayload() => this.payload;
}

class XResetNavigation {}

class XSetDrawerState {
  bool isOpened;
  XSetDrawerState({this.isOpened});
}

class XUpdateDynamicDataBottomTabs {}

class XUpdateFavoriteBottomTabsLogin {}
