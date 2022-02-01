import 'SelphiFaceLivenessMode.dart';


class SelphiFaceConfiguration {
  bool mDebug;
  bool mFullscreen;
  bool mCrop;
  double mCropPercent;
  double mSceneTimeout;
  SelphiFaceLivenessMode mLivenessMode;
  double mJPGQuality;
  String mQrValidatorExpression;
  bool mEnableImages;
  String mUTags;
  bool mFrontalCameraPreferred;
  String mLocale;
  bool mStabilizationMode;
  bool mTemplateRawOptimized;
  int mDesiredCameraWidth;
  int mDesiredCameraHeight;
  bool mEnableGenerateTemplateRaw;
  bool mEnableWidgetEventListener;
  bool mQRMode;
  String mTranslationsContent;
  String mViewsContent;
  
  SelphiFaceConfiguration({
    this.mDebug = false,
    this.mFullscreen = true,
    this.mLocale = "",
    this.mCrop = false,
    this.mCropPercent = 1.0,
    this.mSceneTimeout = 0.0,
    this.mEnableImages = false,
    this.mQrValidatorExpression = null,
    this.mLivenessMode = SelphiFaceLivenessMode.LM_PASSIVE,
    this.mUTags = null,
    this.mJPGQuality = 0.95,
    this.mFrontalCameraPreferred = true,
    this.mStabilizationMode = false,
    this.mTemplateRawOptimized = true,
    this.mDesiredCameraWidth = null,
    this.mDesiredCameraHeight = null,
    this.mEnableGenerateTemplateRaw = false,
    this.mEnableWidgetEventListener = false,
    this.mQRMode = false,
    this.mTranslationsContent = "",
    this.mViewsContent = "",
  });
  
  set viewsContent(String viewsContent) {
    mViewsContent = viewsContent;
  }

  String get viewsContent {
    return mViewsContent;
  }
  
  set translationsContent(String translationsContent) {
    mTranslationsContent = translationsContent;
  }

  String get translationsContent {
    return mTranslationsContent;
  }
  
  set qrMode(bool qrMode) {
    mQRMode = qrMode;
  }

  bool get qrMode {
    return mQRMode;
  }
  
  set enableWidgetEventListener(bool enableWidgetEventListener) {
    mEnableWidgetEventListener = enableWidgetEventListener;
  }

  bool get enableWidgetEventListener {
    return mEnableWidgetEventListener;
  }

  set desiredCameraHeight(int desiredCameraHeight) {
    mDesiredCameraHeight = desiredCameraHeight;
  }

  int get desiredCameraHeight {
    return mDesiredCameraHeight;
  }

  set desiredCameraWidth(int desiredCameraWidth) {
    mDesiredCameraWidth = desiredCameraWidth;
  }

  int get desiredCameraWidth {
    return mDesiredCameraWidth;
  }

  set debug(bool debug) {
    mDebug = debug;
  }

  bool get debug {
    return mDebug;
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

  set crop(bool crop) {
    mCrop = crop;
  }

  bool get crop {
    return mCrop;
  }

  set cropPercent(double cropPercent) {
    mCropPercent = cropPercent;
  }

  double get cropPercent {
    return mCropPercent;
  }

  set sceneTimeout(double sceneTimeout) {
    mSceneTimeout = sceneTimeout;
  }

  double get sceneTimeout {
    return mSceneTimeout;
  }

  set jpgQuality(double jpgQuality) {
    mJPGQuality = jpgQuality;
  }

  double get jpgQuality {
    return mJPGQuality;
  }

  set enableImages(bool enableImages) {
    mEnableImages = enableImages;
  }

  bool get enableImages {
    return mEnableImages;
  }

  set livenessMode(SelphiFaceLivenessMode livenessMode) {
    mLivenessMode = livenessMode;
  }

  SelphiFaceLivenessMode get livenessMode {
    return mLivenessMode;
  }

  set uTags(String uTags) {
    mUTags = uTags;
  }

  String get uTags {
    return mUTags;
  }

  set frontalCameraPreferred(bool frontalCameraPreferred) {
    mFrontalCameraPreferred = frontalCameraPreferred;
  }

  bool get frontalCameraPreferred {
    return mFrontalCameraPreferred;
  }

  set stabilizationMode(bool stabilizationMode) {
    mStabilizationMode = stabilizationMode;
  }

  bool get stabilizationMode {
    return mStabilizationMode;
  }

  set templateRawOptimized(bool templateRawOptimized) {
    mTemplateRawOptimized = templateRawOptimized;
  }

  bool get templateRawOptimized {
    return mTemplateRawOptimized;
  }

  set enableGenerateTemplateRaw(bool enableGenerateTemplateRaw) {
    mEnableGenerateTemplateRaw = enableGenerateTemplateRaw;
  }

  bool get enableGenerateTemplateRaw {
    return mEnableGenerateTemplateRaw;
  }

  factory SelphiFaceConfiguration.fromJson(Map<String, dynamic> parsedJson){
    return SelphiFaceConfiguration(
      mDebug: parsedJson['debug'],
      mCrop: parsedJson ['crop'],
      mCropPercent: parsedJson['cropPercent'],
      mSceneTimeout: parsedJson['sceneTimeout'],
      mJPGQuality: parsedJson['jpgQuality'],
      mEnableImages: parsedJson['enableImages'],
      mLivenessMode: parsedJson ['livenessMode'],
      mQrValidatorExpression: parsedJson['qrValidatorExpression'],
      mFrontalCameraPreferred: parsedJson['frontalCameraPreferred'],
      mStabilizationMode: parsedJson['stabilizationMode'],
      mTemplateRawOptimized: parsedJson['templateRawOptimized'],
      mFullscreen: parsedJson['fullscreen'],
      mUTags: parsedJson['uTags'],
      mLocale: parsedJson['locale'],
      mDesiredCameraHeight: parsedJson['desiredCameraHeight'],
      mDesiredCameraWidth: parsedJson['desiredCameraWidth'],
      mEnableGenerateTemplateRaw: parsedJson['enableGenerateTemplateRaw'],
      mEnableWidgetEventListener: parsedJson['enableWidgetEventListener'],
      mQRMode: parsedJson['qrMode'],
      mTranslationsContent: parsedJson['translationsContent'],
      mViewsContent: parsedJson['viewsContent'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'debug': mDebug,
        'crop': mCrop,
        'cropPercent': mCropPercent,
        'sceneTimeout': mSceneTimeout,
        'enableImages': mEnableImages,
        'jpgQuality': mJPGQuality,
        'livenessMode': mLivenessMode.toString(),
        'qrValidatorExpression': mQrValidatorExpression,
        'frontalCameraPreferred': mFrontalCameraPreferred,
        'stabilizationMode': mStabilizationMode,
        'templateRawOptimized': mTemplateRawOptimized,
        'fullscreen': mFullscreen,
        'uTags': mUTags,
        'locale': mLocale,
        'desiredCameraHeight': mDesiredCameraHeight,
        'desiredCameraWidth': mDesiredCameraWidth,
        'enableGenerateTemplateRaw': mEnableGenerateTemplateRaw,
        'enableWidgetEventListener': mEnableWidgetEventListener,
        'qrMode': mQRMode,
        'translationsContent': mTranslationsContent,
        'viewsContent': mViewsContent,
      };
}
