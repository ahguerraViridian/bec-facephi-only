import '../../../base/state/allState.dart';
import 'package:redux/redux.dart';
import 'onboardingFacePhi_action.dart';

Middleware<AppState> _updateUIOnboardingFacePhi() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
  };
}

List<Middleware<AppState>> midUIOnboardingFacePhi = [
  TypedMiddleware<AppState, XUIOnboardingFacePhi>(_updateUIOnboardingFacePhi())
];
