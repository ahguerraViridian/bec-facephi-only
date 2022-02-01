import '../base/enums/allEnums.dart';
import '../base/state/allState.dart';

//todo: change to FL_TESTING, FL_DEV, FL_BOT, FL_MASTER, FL_STAGE, FL_PROD
enum Flavor {
  STAGE_V,
  DEV,
  TEST,
  STAGE,
  PROD,
  PREPROD,
  DEMO,
  BETA,
}

class Config {
  static Flavor appFlavor;
  static AppClient appClient;
  static String iOSAppID;
  static List<String> lock = [
    "/login",
    "/externalGMap",
    "/loginTimeout",
    "/help",
    "/permissions",
    "/geoPermissions",
    "/initScreen",
    "/loginRetry",
    "/additionalOnboardingData",
    "/additionalOnboardingDataVU",
    "/cameraScreen",
    "/frontIDPicture",
    "/frontIDPictureVU",
    "/signaturePicture",
    "/signaturePictureVU",
    "/backIDPicture",
    "/backIDPictureVU",
    "/personalPhoto",
    "/personalPhotoVU",
    "/documentsData",
    "/documentsDataVU",
    "/onboardingComplete",
    "/onboardingCompleteVU",
    "/onboardingData",
    "/onboardingTypeSelection",
    "/onboardingTypeSelectionVU",
    "/onboardingCardPickupLocationVU",
    "/onboardingCardPickupLocation",
    "/phoneConfirmation",
    "/phoneConfirmationVU",
    "/signUpSelection",
    "/signUpSelectionVU",
    "/cardPickupLocation",
    "/cardPickupLocationVU",
    "/onboardingBankSelection",
    "/onboardingBankSelectionVU",
    "/repeatCardPickupLocationVU",
    "/repeatCardPickupLocation",
    "/faceRecognitionCamera",
    "/appTerms",
    "/forgottenPassword",
    "/onboardingFacePhi",
    "/locationAddressPicker",
    "/identityVerification",
    "/clientPhoto",
    "/clientDocId",
    "/clientBackDocId",
  ];

  //todo: use only one file
  static String getFileExt(bool colored,
      {flavored = true, alternative = true}) {
    String result = "";
    String flavor = "";
    String alt = "";
    switch (appClient) {
      case AppClient.BANECO:
        if (!flavored) {
          flavor = "";
        }
        result = "_baneco" + flavor;

        break;

      default:
        result = "";
    }
    return result;
  }
}
