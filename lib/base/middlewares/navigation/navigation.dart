import '../../../base/actions/allActions.dart';

import '../../../base/state/allState.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import '../../state/appState.dart';
import '../../../utils/allUtils.dart';

Middleware<AppState> navigation() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    String route = action.getRoute();
    dynamic payload = action.getPayload();

    // Remove until routes
    if (action.removeUntil) {
      store.state.navigation.removeUntil(
          route: action.route, routePredicate: action.pushReplacementPredicate);
      store.state.navigatorKey.currentState.pushAndRemoveUntil(
          new MaterialPageRoute(
              settings: RouteSettings(name: route),
              builder: (context) {
                dynamic widget = store.state.navigation.getContentRoute(route);
                if (widget.setData != null && payload != null) {
                  widget.setData(payload);
                }
                return widget;
              }),
          ModalRoute.withName(action.pushReplacementPredicate != null
              ? action.pushReplacementPredicate
              : "/dashboard"));
      return;
    }

    //Update routes with push or push replacement
    store.state.navigation.setRoute(
        route: action.route,
        pushReplacement: action.pushReplacement,
        push: action.push);
    if (action.isModalDialog != null) {
      if (action.isModalDialog) {
        dynamic widget = store.state.navigation.getContentRoute(route);
        if (widget.setData != null && payload != null) {
          widget.setData(payload);
        }
        // AppMessages.showRouteDialog(store, modal: widget);
        return;
      }
    }

    try {
      if (action.pushReplacement) {
        // Push Replacement
        store.state.navigatorKey.currentState
            .pushReplacement(new MaterialPageRoute(
                settings: RouteSettings(name: route),
                builder: (context) {
                  return store.state.navigation.getContentRoute(route);
                }));
      } else {
        if (store.state.navigation.getFullScreenDialogRoute(route) == true) {
          store.state.navigatorKey.currentState.push(new TransparentRoute(
            settings: RouteSettings(name: route),
            builder: (context) {
              dynamic widget = store.state.navigation.getContentRoute(route);
              if (widget.setData != null && payload != null) {
                widget.setData(payload);
              }
              return widget;
            },
          ));
        } else {
          store.state.navigatorKey.currentState.push(new MaterialPageRoute(
            settings: RouteSettings(name: route),
            builder: (context) {
              dynamic widget = store.state.navigation.getContentRoute(route);
              if (widget.setData != null && payload != null) {
                widget.setData(payload);
              }
              return widget;
            },
          ));
        }
      }
    } catch (e) {
      DynamicLog.devPrint(e);
    }
  };
}

Middleware<AppState> backNavigation() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action.routeUntil != null && action.routeUntil != "") {
      store.state.navigation.removeRoutesUntil(route: action.routeUntil);
      store.state.navigation.setRoute(route: action.routeUntil);
      store.state.navigatorKey.currentState
          .popUntil(ModalRoute.withName(action.routeUntil));
    } else {
      store.state.navigation.backRoute();
      if (action.pop) {
        store.state.navigatorKey.currentState.pop();
      }

      if (action.popModal) {
        final context = store.state.navigatorKey.currentState.overlay.context;
        Navigator.of(context).pop();
      }
    }

    next(action);
  };
}

Middleware<AppState> modalBackNavigation() {
  return (Store<AppState> store, action, NextDispatcher next) {
    Navigator.pop(action.context);
  };
}

Middleware<AppState> setDrawerState() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (action.isOpened != null) {
      store.state.navigation.setDrawerState(action.isOpened);
    }

    // next(action);
  };
}

Middleware<AppState> updateFavoriteBottomTabsLogin() {
  return (Store<AppState> store, action, NextDispatcher next) {
    // next(action);
  };
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({
    @required this.builder,
    RouteSettings settings,
  })  : assert(builder != null),
        super(settings: settings, fullscreenDialog: true);

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 350);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final result = builder(context);
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animation),
      child: Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: result,
      ),
    );
  }
}
