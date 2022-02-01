import '../../../base/classes/allClasses.dart';
import 'package:flutter/material.dart';
import 'onboardingFacePhi_view.dart';
import 'onboardingFacePhi_state.dart';
import 'onboardingFacePhi_reducer.dart';
import 'onboardingFacePhi_middleware.dart';

Map<String, dynamic> onboardingFacePhiConfig = {
  "route": AppRoute(
      scaffoldKey: new GlobalKey<ScaffoldState>(),
      key: "/onboardingFacePhi",
      bottomNavigation: false,
      tabNavigation: false,
      content: VOnboardingFacePhi(),
      pages: []),
  "viewState": VStOnboardingFacePhi.initial(),
  "reducer": reducers,
  "middleware": midUIOnboardingFacePhi,
  "key": "/onboardingFacePhi"
};
