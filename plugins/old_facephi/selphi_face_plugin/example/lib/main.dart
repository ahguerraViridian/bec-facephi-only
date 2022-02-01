import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:selphi_face_plugin/SelphiFaceConfiguration.dart';
import 'package:selphi_face_plugin/SelphiFaceOperation.dart';
import 'package:selphi_face_plugin/SelphiFaceLivenessMode.dart';
import 'package:selphi_face_plugin/selphi_face_plugin.dart';
import 'package:selphi_face_plugin/SelphiFaceFinishStatus.dart';
import 'package:selphi_face_plugin/SelphiFaceLivenessDiagnostic.dart';
import 'package:selphi_face_plugin/SelphiFaceErrorType.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _resourcesPath = "fphi-selphi-widget-resources-selphi-live-1.2";
  SelphiFaceConfiguration _configurationWidget;
  SelphiFaceLivenessMode _livenessMode; 
  String _widgetResult;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Map resultJson;
    _livenessMode = SelphiFaceLivenessMode.LM_PASSIVE;
    _configurationWidget = SelphiFaceConfiguration();
    _configurationWidget.livenessMode = _livenessMode; // Liveness mode
    _configurationWidget.fullscreen = true;
    _configurationWidget.enableImages = true;
    _configurationWidget.jpgQuality = 0.8;
    _configurationWidget.templateRawOptimized = false;
    _configurationWidget.stabilizationMode = true;
  
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
                  
      resultJson = await SelphiFacePlugin.startSelphiFaceWidget(resourcesPath: _resourcesPath,
            widgetConfigurationJSON: _configurationWidget);
    } on Exception catch(e) {
    _widgetResult = ('error caught: $e');
  }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if(manageStatus(resultJson)) {
          // Get the Plugin Results (for more info about the JSON content see the documentation)
           _widgetResult = "Length: " + resultJson['bestImage'].length.toString(); // Biometric pattern
          // _widgetResult = resultJson['templateRaw']; // image encrypted.
          /*if(resultJson['images'].length > 0) // Plain base64 images
            _widgetResult = resultJson['images'][0]; // image encrypted.*/
        } 
      });
    }


  bool manageStatus(Map<dynamic, dynamic> resultJson) {
    if(resultJson != null)
    {
        // Manage Plugin process Status
        switch (SelphiFaceFinishStatus.getEnum(resultJson['finishStatus'])) {
            case SelphiFaceFinishStatus.STATUS_OK: // OK
                break;
            case SelphiFaceFinishStatus.STATUS_ERROR: // Error
                // Manage error type
                if (resultJson['errorType']) {
                    if (resultJson['errorType'] == SelphiFaceErrorType.TE_UNKNOWN_ERROR.toInt()) // Unknown Error
                    {
                        _widgetResult = resultJson['errorMessage'];
                    }
                    if (resultJson['errorType'] == SelphiFaceErrorType.TE_CAMERA_PERMISSION_DENIED.toInt()) // Camera Permission Denied
                    {
                        _widgetResult = 'Camera permission denied';
                    }
                    if (resultJson['errorType'] ==  SelphiFaceErrorType.TE_SETTINGS_PERMISSION_ERROR.toInt()) // Settings Permission Denied
                    {
                        _widgetResult = 'Write Settings permission denied';
                    }
                    if (resultJson['errorType'] == SelphiFaceErrorType.TE_HARDWARE_ERROR.toInt()) // Hardware error
                    {
                        _widgetResult = 'Hardware Error';
                    }
					          if (resultJson['errorType'] ==  SelphiFaceErrorType.TE_EXTRACTION_LICENSE_ERROR.toInt()) 
                    {
                        _widgetResult = 'Extraction License Error';
                    }
					          if (resultJson['errorType'] == SelphiFaceErrorType.TE_UNEXPECTED_CAPTURE_ERROR.toInt()) 
                    {
                        _widgetResult = 'Unexpected Capture Error';
                    }
					          if (resultJson['errorType'] == SelphiFaceErrorType.TE_CONTROL_NOT_INITIALIZATED_ERROR.toInt()) 
                    {
                        _widgetResult = 'Control Not Initializated Error';
                    }
					          if (resultJson['errorType'] == SelphiFaceErrorType.TE_BAD_EXTRACTOR_CONFIGURATION_ERROR.toInt()) 
                    {
                        _widgetResult = 'Bad Extractor Configuration Error';
                    }
                }
                else {
                       _widgetResult = 'Unknown Error';
                }
                return false;
            case SelphiFaceFinishStatus.STATUS_CANCEL_BY_USER: // CancelByUser
                _widgetResult = 'Canceled by the user';
                return false;
            case SelphiFaceFinishStatus.STATUS_TIMEOUT: // Timeout
                _widgetResult = 'Extractor timeout';
                return false;
            default:
        }
    } else return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Result: $_widgetResult\n'),
        ),
      ),
    );
  }
}
