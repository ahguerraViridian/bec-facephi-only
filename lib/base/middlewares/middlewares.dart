import 'package:redux/redux.dart';
import '../state/appState.dart';
//Import all actions
import '../actions/allActions.dart';

import 'navigation/navigation.dart';

import "../../routes/config.dart";

List<Middleware<AppState>> createMiddlewares() {
  return [
    TypedMiddleware<AppState, XNavigation>(navigation()), // In use

    // TypedMiddleware<AppState, XUpdateFavoriteBottomTabsLogin>(
    //     updateFavoriteBottomTabsLogin()), // In use

    // Money order end

    TypedMiddleware<AppState, XSetDrawerState>(setDrawerState()), // In use
    TypedMiddleware<AppState, XBackNavigation>(backNavigation()), // In use
    // DB

    // Global end

    // Native end
  ]..addAll(buildMiddlewares());
}

List<Middleware<AppState>> buildMiddlewares() {
  List<Middleware<AppState>> ls = [];
  screenGlobalConfiguration.forEach((conf) {
    if (conf["middleware"] != null) {
      ls..addAll(conf["middleware"]);
    }
  });
  return ls;
}
