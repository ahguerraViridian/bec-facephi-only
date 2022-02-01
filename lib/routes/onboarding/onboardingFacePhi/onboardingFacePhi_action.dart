import '../../../base/classes/allClasses.dart';

class XUIOnboardingFacePhi extends XUIAction {
  bool reset;
  String errorMessage;
  String errorCode;
  bool isButtonLoading;
  bool isImageLoading;
  bool isScreenLoading;

  XUIOnboardingFacePhi(
      {this.errorMessage,
      this.errorCode,
      this.isButtonLoading,
      this.isImageLoading,
      this.isScreenLoading,
      this.reset});
}
