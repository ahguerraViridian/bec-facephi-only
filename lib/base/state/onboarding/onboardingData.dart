import '../allState.dart';
import 'formData.dart';
import 'onboardingAddress.dart';
import 'onboardingRequest.dart';
import 'onboardingBanks.dart';

class StOnboardingData {
  StOnboardingProduct onboardingProduct;
  String requestStep;
  String phone;
  int requestID;
  String productCode;
  String bankCode;
  String authCode;
  StOnboardingBankData currentOnboardingBank;

  StOnboardingRequestData requestData;
  StOnboardingFormData formData = StOnboardingFormData();

  String firstName;
  String paternalSurName;
  String maternalSurName;
  String marriedSurName;
  String docIDNumber;
  String docIDComplement;
  String docIDIssueState;
  String birthplaceState;
  String docIDDueDate;

  String currentSelfiePath;
  String selfieDetectionPhase = "FIRST";
  String base64Selfie;
  String currentBackIdPicPath;
  String base64BackIdPic;
  String currentFrontIdPicPath;
  String base64FrontIdPic;
  String currentSignaturePicPath;
  String base64SignaturePic;
  String requestStatus;
  String productName;

  String base64RegularSelfie;
  String base64EyesClosedSelfie;
  String regularSelfiePath;
  String eyesClosedSelfiePath;

  String activityTypeCode;
  String activityTypeDesc;
  String taxID;
  double monthlyIncome;
  String monthlyIncomeCurrency;
  String email;
  String branchCode;
  String officeCode;
  String homeAddress;
  String loginId;
  String workEmployerName;
  String workPosition;
  String workAdmissionDate;
  String genderCode;
  String homeCountryCode;
  String homeStateCode;
  String homeCityCode;
  String nationalityCode;
  String educationDegreeCode;
  String personalReference;
  String referencePhone;
  String ciiuCode;

  String accountCode;
  String accountType;

  String base64OnboardingDocument;

  bool bankPickUp;
  StOnboardingAddress onboardingAddress;
  bool includeInsurance;
  int deliveryID;
  StFacePhiData facePhiData;

  StOnboardingData({
    this.requestStep,
    this.base64Selfie,
    this.currentSelfiePath,
    this.base64BackIdPic,
    this.currentBackIdPicPath,
    this.base64SignaturePic,
    this.currentSignaturePicPath,
    this.base64FrontIdPic,
    this.currentFrontIdPicPath,
    this.authCode,
    this.bankCode,
    this.docIDComplement,
    this.docIDDueDate,
    this.docIDIssueState,
    this.docIDNumber,
    this.firstName,
    this.maternalSurName,
    this.paternalSurName,
    this.marriedSurName,
    this.phone,
    this.productCode,
    this.requestID,
    this.onboardingProduct,
    this.selfieDetectionPhase,
    this.requestStatus,
    this.productName,
    this.activityTypeCode,
    this.activityTypeDesc,
    this.branchCode,
    this.currentOnboardingBank,
    this.educationDegreeCode,
    this.email,
    this.genderCode,
    this.homeAddress,
    this.homeCityCode,
    this.homeCountryCode,
    this.loginId,
    this.monthlyIncome,
    this.monthlyIncomeCurrency,
    this.nationalityCode,
    this.officeCode,
    this.personalReference,
    this.referencePhone,
    this.taxID,
    this.workAdmissionDate,
    this.workEmployerName,
    this.workPosition,
    this.homeStateCode,
    this.ciiuCode,
    this.base64OnboardingDocument,
    this.bankPickUp,
    this.onboardingAddress,
    this.accountCode,
    this.accountType,
    this.birthplaceState,
    this.base64EyesClosedSelfie,
    this.base64RegularSelfie,
    this.eyesClosedSelfiePath,
    this.regularSelfiePath,
    this.deliveryID,
    this.includeInsurance,
    this.facePhiData,
  });
}
