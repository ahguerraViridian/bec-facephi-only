import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
//import 'package:selphi_face_plugin/SelphiFaceOperation.dart';
import 'package:selphi_face_plugin/SelphiFaceConfiguration.dart';

class SelphiFacePlugin {
  static const MethodChannel _channel =
      const MethodChannel('selphi_face_plugin');

  static Future<Map> startSelphiFaceWidget({
    @required String resourcesPath,
    SelphiFaceConfiguration widgetConfigurationJSON,
  }) async {
    final Map result = await _channel.invokeMethod('startSelphiFaceWidget', {"resourcesPath": resourcesPath, "widgetConfigurationJSON": widgetConfigurationJSON.toJson()});
    return result;
  }

  static Future<String> generateTemplateRaw({
    @required String imageBase64
  }) async {
    final String result = await _channel.invokeMethod('generateTemplateRaw', {"imageBase64": imageBase64});
    return result;
  }
}
