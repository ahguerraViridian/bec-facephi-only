import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
//Import state
import '../../base/state/appState.dart';
//Import
import '../../base/state/allState.dart';

class AppBarVM {
  GlobalKey<ScaffoldState> scaffoldKey;

  AppBarVM({
    this.scaffoldKey,
  });
  //return container for custom app bar
  static AppBarVM fromStore(Store<AppState> store) {
    return AppBarVM(
      scaffoldKey: store.state.navigation
          .getScaffoldKeyWithIndex(store.state.navigation.key),
    );
  }

  // operator ==(o) =>
  //     o is CustomAppBarVM &&
  //     o.tabNavigation == tabNavigation &&
  //     o.index == index &&
  //     o.scaffoldKey == scaffoldKey &&
  //     o.notificationCounter == notificationCounter &&
  //     o.exchangeRateList == exchangeRateList;

  // int get hashCode =>
  //     tabNavigation.hashCode ^
  //     index.hashCode ^
  //     scaffoldKey.hashCode ^
  //     notificationCounter.hashCode ^
  //     scaffoldKey.hashCode ^
  //     exchangeRateList.hashCode;
}
