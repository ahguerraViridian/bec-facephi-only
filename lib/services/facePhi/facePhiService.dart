import '../../routes/export.dart';

import '../../base/enums/allEnums.dart';

import '../../base/state/appState.dart';
import 'package:redux/redux.dart';
import '../../base/actions/allActions.dart';
import '../../utils/allUtils.dart';
import 'package:dartz/dartz.dart';
import 'package:selphid_plugin/SelphIDConfiguration.dart';
import 'package:selphid_plugin/selphid_plugin.dart';
import 'package:selphid_plugin/SelphIDDocumentType.dart';
import 'package:selphid_plugin/SelphIDScanMode.dart';
import 'package:selphid_plugin/SelphIDOperation.dart';
import 'package:selphid_plugin/SelphIDTimeout.dart';
import 'package:selphi_face_plugin/SelphiFaceConfiguration.dart';
import 'package:selphi_face_plugin/SelphiFaceLivenessMode.dart';
import 'package:selphi_face_plugin/selphi_face_plugin.dart';
import 'selphiFaceResult.dart';

import 'selphIDResult.dart';

class FacePhiService {
  static final FacePhiService _singleton = new FacePhiService._internal();

  factory FacePhiService() {
    return _singleton;
  }

  FacePhiService._internal();

  void init(Store<AppState> store) async {}
  Future<Either<Exception, SelphIDResult>> launchSelphIDCapture(
      String resourcesPath, String license) async {
    return launchSelphIDCaptureWithConfiguration(
        resourcesPath, license, createStandardConfiguration());
  }

// START SELPHID
  Future<Either<Exception, SelphIDResult>>
      launchSelphIDCaptureWithConfiguration(String resourcesPath,
          String license, SelphIDConfiguration configuration) async {
    try {
      final Map resultJson = await SelphidPlugin.startSelphIDWidget(
          operationMode: SelphIDOperation.CAPTURE_WIZARD,
          resourcesPath: resourcesPath,
          widgetLicense: license,
          previousOCRData: null,
          widgetConfigurationJSON: createStandardConfiguration());

      if (resultJson != null)
        return Right(SelphIDResult.fromMap(resultJson));
      else
        throw Exception('Plugin internal error');
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  SelphIDConfiguration createStandardConfiguration() {
    SelphIDConfiguration configurationWidget;
    configurationWidget = SelphIDConfiguration();
    configurationWidget.documentType = SelphIDDocumentType
        .DT_IDCARD; // IDCard, Passport, DriverLic or ForeignCard
    configurationWidget.fullscreen = true;

    configurationWidget.scanMode = SelphIDScanMode.CAP_MODE_SEARCH;
    configurationWidget.specificData = 'BO|<ALL>';
    configurationWidget.showResultAfterCapture = true;

    // configurationWidget.timeout = SelphIDTimeout.T_SHORT;

    // configurationWidget.tokenImageQuality = 1.0;
    return configurationWidget;
  }
  //END SELPHID

  // START SELPHI
  Future<Either<Exception, SelphiFaceResult>> launchSelphiAuthenticate(
      String resourcesPath) async {
    return launchSelphiAuthenticateWithConfiguration(
        resourcesPath, createSelphiStandardConfiguration());
  }

  Future<Either<Exception, SelphiFaceResult>>
      launchSelphiAuthenticateWithConfiguration(
          String resourcesPath, SelphiFaceConfiguration configuration) async {
    try {
      final Map resultJson = await SelphiFacePlugin.startSelphiFaceWidget(
          resourcesPath: resourcesPath,
          widgetConfigurationJSON: createSelphiStandardConfiguration());

      if (resultJson != null)
        return Right(SelphiFaceResult.fromMap(resultJson));
      else
        throw Exception('Plugin internal error');
    } on Exception catch (e) {
      return (Left(e));
    }
  }

  /// Sample of standard plugin configuration
  SelphiFaceConfiguration createSelphiStandardConfiguration() {
    SelphiFaceConfiguration configurationWidget;
    configurationWidget = SelphiFaceConfiguration();
    configurationWidget.livenessMode =
        SelphiFaceLivenessMode.LM_PASSIVE; // Liveness mode
    configurationWidget.fullscreen = true;
    configurationWidget.enableImages = false;
    configurationWidget.jpgQuality = 0.95;
    configurationWidget.stabilizationMode = true;
    return configurationWidget;
  }

  Future<String> generateTemplateRaw({String imageBase64}) async {
    return await SelphiFacePlugin.generateTemplateRaw(imageBase64: imageBase64);
  }

  // END SELPHI
}
