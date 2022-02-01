import 'dart:typed_data';

import '../../../base/state/allState.dart';

import '../../../base/enums/allEnums.dart';
import 'package:camera/camera.dart';

class XStConfig {
  String deviceID;
  String deviceType;
  String deviceOSDisplay;
  String operativeSystem;
  String operativeSystemVersion;
  String appVersion;
  String appName;
  String deviceBrowser;
  String deviceName;
  String deviceManufacturer;

  XStConfig({
    this.deviceID,
    this.deviceType,
    this.deviceOSDisplay,
    this.appName,
    this.deviceBrowser,
    this.appVersion,
    this.deviceManufacturer,
    this.deviceName,
    this.operativeSystem,
    this.operativeSystemVersion,
  });
}

class XStCurrentCamera {
  CameraLensDirection lensDirection;
  XStCurrentCamera({this.lensDirection});
}

class XStResetSharedImage {}
