import 'package:selphid_plugin/SelphIDDocumentType.dart';
import 'package:selphid_plugin/SelphIDTimeout.dart';
import 'SelphIDScanMode.dart';


class SelphIDConfiguration{
  bool mDebug;
  bool mShowResultAfterCapture;
  bool mShowTutorial;
  SelphIDScanMode mScanMode;
  String mSpecificData;
  bool mFullscreen;
  double mTokenImageQuality;
  String mLocale;
  SelphIDDocumentType mDocumentType;
  SelphIDTimeout mTimeout;

  SelphIDConfiguration({
    this.mDebug = false,
    this.mShowResultAfterCapture = true,
    this.mShowTutorial = false,
    this.mScanMode = SelphIDScanMode.CAP_MODE_GENERIC,
    this.mSpecificData = "",
    this.mFullscreen = true,
    this.mLocale = "",
    this.mTokenImageQuality =0.5,
    this.mDocumentType = SelphIDDocumentType.DT_IDCARD,
    this.mTimeout = SelphIDTimeout.T_SHORT,
  });


  set debug(bool debug) {
    mDebug = debug;
  }

  bool get debug {
    return mDebug;
  }

  set documentType(SelphIDDocumentType documentType) {
    mDocumentType = documentType;
  }

  SelphIDDocumentType get documentType {
    return mDocumentType;
  }

  set showResultAfterCapture(bool showResultAfterCapture) {
    mShowResultAfterCapture = showResultAfterCapture;
  }

  bool get showResultAfterCapture {
    return mShowResultAfterCapture;
  }

  set showTutorial(bool showTutorial) {
    mShowTutorial = showTutorial;
  }

  bool get showTutorial {
    return mShowTutorial;
  }

  set tokenImageQuality(double tokenImageQuality) {
    mTokenImageQuality = tokenImageQuality;
  }

  double get tokenImageQuality {
    return mTokenImageQuality;
  }

  set scanMode(SelphIDScanMode scanMode) {
      mScanMode = scanMode;
  }

  SelphIDScanMode get scanMode {
    return mScanMode;
  }

  set timeout(SelphIDTimeout timeout) {
    mTimeout = timeout;
  }

  SelphIDTimeout get timeout {
    return mTimeout;
  }

  set specificData(String specificData) {
    mSpecificData = specificData;
  }

  String get specificData {
    return mSpecificData;
  }

  set fullscreen(bool fullscreen) {
    mFullscreen = fullscreen;
  }

  bool get fullscreen {
    return mFullscreen;
  }


  set locale(String locale) {
    mLocale = locale;
  }

  String get locale {
    return mLocale;
  }

  factory SelphIDConfiguration.fromJson(Map<String, dynamic> parsedJson){
    return SelphIDConfiguration(
        mDebug: parsedJson['debug'],
        mShowResultAfterCapture : parsedJson['showResultAfterCapture'],
        mShowTutorial : parsedJson ['showTutorial'],
        mScanMode: parsedJson['scanMode'],
        mDocumentType: parsedJson['documentType'],
        mSpecificData : parsedJson['specificData'],
        mFullscreen: parsedJson['fullscreen'],
        mLocale : parsedJson ['locale'],
	      mTokenImageQuality : parsedJson ['tokenImageQuality'],
        mTimeout : parsedJson ['timeout'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'debug': mDebug,
        'showResultAfterCapture': mShowResultAfterCapture,
        'showTutorial': mShowTutorial,
        'scanMode': mScanMode.toString(),
        'documentType': mDocumentType.toString(),
        'specificData': mSpecificData,
        'fullscreen': mFullscreen,
        'locale': mLocale,
	      'tokenImageQuality': mTokenImageQuality,
        'timeout': mTimeout.toString(),
      };
}