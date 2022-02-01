import 'dart:async';

import '../../../base/state/allState.dart';

class VStOnboardingFacePhi {
  MessageAlertState messageAlert;
  String errorCode;
  bool isButtonLoading;
  bool isImageLoading;
  bool isScreenLoading;
  String labelButton;
  String buttonStatus;

  VStOnboardingFacePhi(
      {this.isButtonLoading,
      this.isImageLoading,
      this.messageAlert,
      this.labelButton,
      this.buttonStatus,
      this.isScreenLoading});

  factory VStOnboardingFacePhi.initial() {
    return VStOnboardingFacePhi(
        isScreenLoading: false,
        isButtonLoading: false,
        isImageLoading: false,
        messageAlert: null,
        labelButton: "Continuar",
        buttonStatus: "enabled");
  }

  factory VStOnboardingFacePhi.loading() {
    return VStOnboardingFacePhi(
        isButtonLoading: true,
        isImageLoading: true,
        messageAlert: null,
        buttonStatus: "disabled",
        labelButton: "Cargando");
  }

  factory VStOnboardingFacePhi.error(String error) {
    return VStOnboardingFacePhi(
        isButtonLoading: false,
        isImageLoading: false,
        messageAlert: MessageAlertState(message: error),
        buttonStatus: "enabled",
        labelButton: "Continuar");
  }

  factory VStOnboardingFacePhi.success() {
    return VStOnboardingFacePhi(
        isButtonLoading: false,
        isImageLoading: false,
        messageAlert: null,
        buttonStatus: "enabled",
        labelButton: "Continuar");
  }

  void setParams(
      {String error,
      bool isNewLoading,
      bool isNewImageLoading,
      bool isNewScreenLoading,
      String newCode}) {
    isButtonLoading = isNewLoading != null ? isNewLoading : isButtonLoading;
    isScreenLoading =
        isNewScreenLoading != null ? isNewScreenLoading : isScreenLoading;
    isImageLoading =
        isNewImageLoading != null ? isNewImageLoading : isImageLoading;
    errorCode = newCode != null ? newCode : errorCode;
    new Timer(Duration(milliseconds: 10), () {
      messageAlert = null;
    });
    messageAlert = error != null ? MessageAlertState(message: error) : null;
  }
}
