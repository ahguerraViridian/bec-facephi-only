import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:selphid_plugin/SelphIDConfiguration.dart';
import 'package:selphid_plugin/SelphIDOperation.dart';

class SelphidPlugin {
  static const MethodChannel _channel =
      const MethodChannel('selphid_plugin');

  static Future<Map> startSelphIDWidget({
    @required SelphIDOperation operationMode,
    @required String resourcesPath,
    @required String widgetLicense,
    @required String previousOCRData,
    SelphIDConfiguration widgetConfigurationJSON,
  }) async {
    final Map result = await _channel.invokeMethod('startSelphIDWidget', {"operationMode":operationMode.toString(), "resourcesPath": resourcesPath,
      "widgetLicense": widgetLicense, "previousOCRData":previousOCRData, "widgetConfigurationJSON": widgetConfigurationJSON.toJson()});
    return result;
  }

  static Future<Map> startSelphIDTestImageWidget({
    @required SelphIDOperation operationMode,
    @required String resourcesPath,
    @required String widgetLicense,
    @required String previousOCRData,
    SelphIDConfiguration widgetConfigurationJSON,
    @required String testImageName,
  }) async {
    final Map result = await _channel.invokeMethod('startSelphIDTestImageWidget', {"operationMode":operationMode.toString(), "resourcesPath": resourcesPath,
      "widgetLicense": widgetLicense, "previousOCRData":previousOCRData, "widgetConfigurationJSON": widgetConfigurationJSON.toJson(), "testImageName": testImageName});
    return result;
  }
}
