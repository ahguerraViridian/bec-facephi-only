// Import states
import 'dart:async';
import '../../state/allState.dart';
// Import all actions
import '../../actions/allActions.dart';

AppState updateMessageAlert(AppState state, XUIMessageAlert action) {
  state.messageAlert = MessageAlertState(
      message: action.message, type: action.type, color: action.color);

  new Timer(Duration(milliseconds: 10), () {
    state.messageAlert = null;
  });
  return state;
}
