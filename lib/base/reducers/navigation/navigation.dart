// Import model
import '../../state/appState.dart';
import '../../state/allState.dart';
// Import all actions
import '../../actions/allActions.dart';

AppState updateBottomNavigation(AppState state, XBottomNavigation action) {
  state.navigation.setIndexNavigationRoute(action.tab);
  return state;
}

AppState updateBottomNavigationKey(
    AppState state, XBottomNavigationKey action) {
  state.navigation.setIndexNavigationRouteKey(action.key);
  return state;
}

AppState updateTabNavigation(AppState state, XTabNavigation action) {
  state.navigation.setIndexNavigation(action.tab);
  return state;
}

AppState updateBackNavigation(AppState state, XBackNavigation action) {
  return state;
}

AppState resetNavigation(AppState state, XResetNavigation action) {
  state.navigation = new NavigationModel();
  return state;
}
