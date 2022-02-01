import '../../../services/images/imagesServices.dart';

import '../../../components/allComponents.dart';
import 'package:flutter/services.dart';

import '../../../config/config.dart';

import '../../../base/enums/allEnums.dart';
import '../../../routes/export.dart';

import '../../../config/appConfig.dart';

import '../../../base/actions/allActions.dart';
import '../../../base/state/allState.dart';
import '../../../routes/onboarding/onboardingFacePhi/export.dart';
import '../../../routes/onboarding/onboardingFacePhi/onboardingFacePhi.dart';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';

class VMOnboardingFacePhi {
  Function({
    String selfieFacePhiImage,
    String selfieRawImage,
    String frontDocIdFacePhiImage,
    String frontDocIdRawIamge,
    String backDocIdRawImage,
    String ocrDocIdNumber,
    String ocrFullname,
    String ocrDocIdDueDate,
    String ocrBirthDate,
    String ocrAddress,
    bool noExpireDate,
  }) onCreate;
  Function onPop;
  Function onInit;
  Function showSnack;
  Function(bool, Function) showTimeoutDialog;
  Function(bool) setLoadingState;
  Function goToCamera;
  Function goToFaceCamera;
  Function exitApp;
  MessageAlertState messageAlert;
  AppConfig config;
  StOnboardingData onboardingData;
  GlobalKey globalKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  static String routeKey = "/onboardingFacePhi";

  VStOnboardingFacePhi viewState;

  VMOnboardingFacePhi({
    this.onCreate,
    this.onPop,
    this.onInit,
    this.showSnack,
    this.setLoadingState,
    this.scaffoldKey,
    this.messageAlert,
    this.viewState,
    this.config,
    this.goToCamera,
    this.onboardingData,
    this.globalKey,
    this.exitApp,
    this.goToFaceCamera,
    this.showTimeoutDialog,
  });
  //return container for New Beneficiary Screen
  static VMOnboardingFacePhi fromStore(Store<AppState> store) {
    return VMOnboardingFacePhi(
      exitApp: () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      },
      setLoadingState: (newState) {},
      onCreate: ({
        String selfieFacePhiImage,
        String selfieRawImage,
        String frontDocIdFacePhiImage,
        String frontDocIdRawIamge,
        String backDocIdRawImage,
        String ocrDocIdNumber,
        String ocrFullname,
        String ocrDocIdDueDate,
        String ocrBirthDate,
        String ocrAddress,
        bool noExpireDate,
      }) async {},
      globalKey: store.state.globalKey,
      viewState:
          store.state.viewsState.getUIView(onboardingFacePhiConfig["key"]),
      onInit: (BuildContext context) {},
      onPop: () async {
        Future<bool> result;
        if (Config.appFlavor != Flavor.PROD &&
            Config.appFlavor != Flavor.STAGE &&
            Config.appFlavor != Flavor.STAGE_V) {
          store.dispatch(new XBackNavigation(pop: true));
        }
        result = Future.value(false);
        return result;
      },
      goToCamera: (BuildContext context) {},
      goToFaceCamera: (BuildContext context) {},
      onboardingData: store.state.onboardingData,
      config: store.state.config,
      showSnack: (String msg, {Function onFinished}) {
        store.dispatch(XUIPopUpMessage(
            message: msg,
            context: null,
            onClose: onFinished != null ? onFinished : () {}));
      },
      scaffoldKey: store.state.navigation.getScaffoldKeyWithIndex(routeKey),
      messageAlert: store.state.messageAlert,
    );
  }
}
