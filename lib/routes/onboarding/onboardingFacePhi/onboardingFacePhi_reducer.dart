import '../../../base/state/appState.dart';
import 'package:redux/redux.dart';
import '../../../routes/export.dart';
import 'onboardingFacePhi.dart';

AppState redOnboardingFacePhi(AppState state, XUIOnboardingFacePhi action) {
  if (action.reset != null) {
    state.viewsState.setUIView(
        onboardingFacePhiConfig["key"], VStOnboardingFacePhi.initial());
    return state;
  }

  VStOnboardingFacePhi stView =
      state.viewsState.getUIView(onboardingFacePhiConfig["key"]);
  stView.setParams(
      error: action.errorMessage,
      newCode: action.errorCode,
      isNewLoading: action.isButtonLoading,
      isNewImageLoading: action.isImageLoading,
      isNewScreenLoading: action.isScreenLoading);
  return state;
}

List<Reducer<AppState>> reducers = [
  TypedReducer<AppState, XUIOnboardingFacePhi>(redOnboardingFacePhi)
];
