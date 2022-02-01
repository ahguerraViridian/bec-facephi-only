import 'package:flutter/material.dart';
import '../../config/appConfig.dart';
import 'allState.dart';

class AppState {
  bool connectivity = true;
  StGlobalUI globalUI = StGlobalUI();

  AppConfig config = new AppConfig();

  // Onboarding
  StOnboardingData onboardingData = StOnboardingData();

  StOnboardingProducts onboardingProducts = StOnboardingProducts();
  StOnboardingProducts onboardingAccountProducts = StOnboardingProducts();
  StOnboardingBanks onboardingBanks = StOnboardingBanks();

  NavigationModel navigation = new NavigationModel();
  MessageAlertState messageAlert;

  //Navigator globalkey
  GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  GlobalKey globalKey = new GlobalKey();

  //UiViews
  UIViews viewsState = new UIViews();
  String nameApp;

  AppState({this.nameApp: "baneco"});
  factory AppState.loading() => AppState(nameApp: "baneco");

  void setConnectivity(bool conn) {
    this.connectivity = conn;
  }
}
