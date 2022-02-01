import 'navigation/bottomNavigation.dart';

import 'package:redux/redux.dart';
// Import model
import '../state/appState.dart';
// Import all actions
import '../actions/allActions.dart';

import 'ui/messageAlert.dart';
import 'ui/globalui.dart';
import '../../routes/config.dart';

List<Reducer<AppState>> buildReducers() {
  screenGlobalConfiguration.forEach((conf) {
    if (conf["reducer"] != null) {
      _reducers.addAll(conf["reducer"]);
    }
  });
  return _reducers;
}

AppState appReducer(AppState state, action) {
  return toDoListReducer(state, action);
}

List<Reducer<AppState>> _reducers = [
//Using
  TypedReducer<AppState, XBottomNavigationOrder>(
      updateBottomTabsOrder), //Using\
  TypedReducer<AppState, XUpdateFavoriteBottomTabsLogin>(
      updateFavoriteBottomTabsLogin), //Using
  TypedReducer<AppState, XUIMessageAlert>(updateMessageAlert), // Using
  TypedReducer<AppState, XStGlobalUI>(updateGlobalUI), // Using


];

Reducer<AppState> toDoListReducer = combineReducers(buildReducers());
