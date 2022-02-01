import '../../../utils/allUtils.dart';

import '../../../routes/config.dart';

import '../../../base/classes/allClasses.dart';

import '../../../base/actions/allActions.dart';
import '../../../base/state/allState.dart';

AppState updateBottomTabsOrder(AppState state, XBottomNavigationOrder action) {
  List<AppPage> currentPages = state.navigation.routes["/dashboard"].pages;
  void insertOnly() {
    Map pag = screenGlobalConfFindByKey(action.bottomTabKey);
    if (pag != null) {
      currentPages
        ..add(AppPage(
          scaffoldKey: pag["scaffoldKey"] != null ? pag["scaffoldKey"] : null,
          key: pag["key"],
          root: pag["root"],
          content: pag["view"],
          bottomNavigation: pag["bottomNavigation"],
          tabNavigation: pag["tabNavigation"],
          // tabBar: pag["tabBar"] != null ? pag["tabBar"] : null,
          tabBar: pag["tabBar"],
          indexNavigation: pag[""],
          pages: [],
          icon: pag["icon"],
          customIcon: pag["customIcon"],
          description: pag["description"],
          shortDesc: pag["shortDescription"],
        ));
    }
  }

  int oldPageIndex =
      currentPages.indexWhere((element) => element.key == action.bottomTabKey);
  AppPage pageToBeFavorite;
  if (oldPageIndex != -1)
    pageToBeFavorite = currentPages.elementAt(oldPageIndex);
  if (oldPageIndex != null && oldPageIndex != -1) {
    AppPage pageToBeReplaced = currentPages.elementAt(action.bottomIndexTarget);

    // eliminating and the previous favorite and placing the new
    pageToBeFavorite.indexNavigation = action.bottomIndexTarget;
    currentPages.removeAt(action.bottomIndexTarget);
    currentPages.insert(action.bottomIndexTarget, pageToBeFavorite);
    // positioning old favorite to new position
    pageToBeReplaced.indexNavigation = oldPageIndex;
    currentPages.removeAt(oldPageIndex);
    currentPages.insert(oldPageIndex, pageToBeReplaced);
  } else {
    insertOnly();
  }
  return state;
}

AppState updateFavoriteBottomTabsLogin(
    AppState state, XUpdateFavoriteBottomTabsLogin action) {
  // ORIGINAL MENU PERSISTENCE
  List<StDeepLinkDataItem> originalDeepLinks = [];

  return state;
}
