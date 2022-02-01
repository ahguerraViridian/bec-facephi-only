// Import states
import '../../state/allState.dart';
// Import all actions
import '../../actions/allActions.dart';

AppState updateGlobalUI(AppState state, XStGlobalUI action) {
  if (action.newUIState != null)
    state.globalUI.setCurrentUIState(action.newUIState);

  return state;
}
