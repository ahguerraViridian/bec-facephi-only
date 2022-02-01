import 'dart:async';
import 'package:redux/redux.dart';
import '../../state/appState.dart';
import '../../state/allState.dart';

Middleware<AppState> setTimedFunction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action.seconds == null && action.miliseconds != null) {
      new Timer(Duration(milliseconds: action.miliseconds), () {
        action.function();
      });
    } else {
      if (action.seconds != null && action.miliseconds == null) {
        new Timer(Duration(seconds: action.seconds), () {
          action.function();
        });
      } else {
        new Timer(
            Duration(seconds: action.seconds, milliseconds: action.miliseconds),
            () {
          action.function();
        });
      }
    }
  };
}
