import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:selphid_plugin/SelphIDConfiguration.dart';
import 'package:selphid_plugin/SelphIDOperation.dart';
import 'package:selphid_plugin/SelphIDScanMode.dart';
import 'package:selphid_plugin/SelphIDFinishStatus.dart';
import 'package:selphid_plugin/SelphIDErrorType.dart';
import 'package:selphid_plugin/selphid_plugin.dart';
import 'package:selphid_plugin/SelphIDDocumentType.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

/// SelphID Params

  final navigatorKey = GlobalKey<NavigatorState>();
  BuildContext context;
  SelphIDOperation _operationMode = SelphIDOperation.CAPTURE_WIZARD;
  String _resourcesPath = "fphi-selphid-widget-resources-selphid-1.0";
  SelphIDConfiguration _configurationWidget;
  String _licenseAndroid = "{\n"+
            "    \"customer\": \"Facephi\",\n"+
            "    \"documentType\": \"LicenseEnvelope\",\n"+
            "    \"license\": {\n"+
            "        \"comments\": \"Programming Example\",\n"+
            "        \"dateEnd\": \"2020-10-29\",\n"+
            "        \"extraData\": \"3D430F0C330D073504270A331D04230F17476A4A1A1416222411293F1F535A111C05332E38513327092E2D1407573C0333743753293E2A05100F0A4E2A5C1F1E2F15343A59210100052667211E0C0B3030142A070B061A0027315C345332103D1C2272090A36250A381713193F1E322E2D3353273C512D2A190A16665D306D182A27602500772E2257165E2E6912303619093A175136571A235872022F321806183423194A633F332C292D0E22121F2930172E29020435302E36265C590E3122361A25113509170A3D1F10705820293558112337391663215A205507030A290575360A2069210E74521632311A33042E150F7B510E75242A0C7B06283433321D340033772E1A35232E1E2E2E3414042D38740F2B543802062D28271D070927234A075608293E15190556672B043F340D5C665C5F09250A2D36070F153433291C3A283327414972040025040D16353C062D040D213F0B1C2B040D1172524B3D3D0D457048491A430010231C062B0411397252491A432504330D192E083F477C3407664143450C4A0D2902160835061D121813000C4A53663D4129390B0C281206203E1E0C2A0E13000C4A451A0F4345704835640D0A0635061A233D415F7013352841434570484966413F473307042B040D1123344B7C413F47001A06211302083D01072141261D3105192A043F477C340766414345704849663D4101311C0C030F07397252491A43515562584477514E5769344B6A3D0D45704849664143450C4A052F02060B230D2D2902160835061D1A4359450C4A1A1416222411293F1F535A111C05332E38513327092E2D1407573C0333743753293E2A05100F0A4E2A5C1F1E2F15343A59210100052667211E0C0B3030142A070B061A0027315C345332103D1C2272090A36250A381713193F1E322E2D3353273C512D2A190A16665D306D182A27602500772E2257165E2E6912303619093A175136571A235872022F321806183423194A633F332C292D0E22121F2930172E29020435302E36265C590E3122361A25113509170A3D1F10705820293558112337391663215A205507030A290575360A2069210E74521632311A33042E150F7B510E75242A0C7B06283433321D340033772E1A35232E1E2E2E3414042D38740F2B543802062D28271D070927234A075608293E15190556672B043F340D5C665C5F09250A2D36070F153433291C3A2833273F477C340766414345704849663D410A23344B7C413F4711060D340E0A010C4A451A0F434570484966414339721808250A02023526082B043F476A483564020C087E0E082504130D39461E2F050400244619233D41490C0649664143457048491A4313173F0C1C25153F476A483564320609200020023D41490C0649664143457048491A431500221B00290F3F476A483564504D550C4A35284143457015451A0F43457048356411110A26010D23133F476A4835642702063538012F3D41393E154B6A430F0A370F002806415F36090535041E\",\n"+
            "        \"licenseDocument\": true,\n"+
            "        \"licenseFacial\": false,\n"+
            "        \"licenseTokenDocument\": true,\n"+
            "        \"logging\": false,\n"+
            "        \"os\": \"Android\",\n"+
            "        \"packageName\": \"com.facephi.widget.pe\",\n"+
            "        \"product\": \"SelphID\",\n"+
            "        \"version\": \"1.0\"\n"+
            "    },\n"+
            "    \"provider\": \"FacePhi\"\n"+
            "}";
  String _licenseIOS = "{\n" +
            "    \"customer\": \"Facephi\",\n" +
            "    \"documentType\": \"LicenseEnvelope\",\n" +
            "    \"license\": {\n" +
            "        \"comments\": \"Programming Example\",\n" +
            "        \"dateEnd\": \"2020-10-29\",\n" +
            "        \"extraData\": \"3D430F0C330D073504270A331D04230F17476A4A1A14162224112D3F1F535A111C05332E38513327092E2D1407573C0333743753293E2A052955021408050D702909503E0E0A1F0F521D3E0D0A3704111F2A2B07732B0D016611280D0B2A27362A420F24105D6323336D3707153D013910322D0964112D35105B28291B3C2D102556662E1D0A0E512D3D29002C02564A272A1C13370200095024011624316243242D343151225D3A07535552222D251C282E22690F587602391F13471A0F580052252F0D32331B30002D3C2402250C13583A71042650321A2D2558301F0A035F1F18040D1B02336D242C1F691B2C2D05505407503C2914063205262B0F3705313B5C317E563A2C330A2F3E072051112902214A170A1F19331F3908501A3D2208090F34601A1D04332B37163F2A7E155223000C332928271D29211B3C0E0F553E3B0F7015414972040025040D16353C062D040D213F0B1C2B040D1172524B3D3D0D457048491A430010231C062B0411397252491A432504330D192E083F477C3407664143450C4A0D2902160835061D121813000C4A53663D4129390B0C281206203E1E0C2A0E13000C4A451A0F4345704835640D0A0635061A233D415F7013352841434570484966413F473307042B040D1123344B7C413F47001A06211302083D01072141261D3105192A043F477C340766414345704849663D4101311C0C030F07397252491A43515562584477514E5769344B6A3D0D45704849664143450C4A052F02060B230D2D2902160835061D1A4359450C4A1A14162224112D3F1F535A111C05332E38513327092E2D1407573C0333743753293E2A052955021408050D702909503E0E0A1F0F521D3E0D0A3704111F2A2B07732B0D016611280D0B2A27362A420F24105D6323336D3707153D013910322D0964112D35105B28291B3C2D102556662E1D0A0E512D3D29002C02564A272A1C13370200095024011624316243242D343151225D3A07535552222D251C282E22690F587602391F13471A0F580052252F0D32331B30002D3C2402250C13583A71042650321A2D2558301F0A035F1F18040D1B02336D242C1F691B2C2D05505407503C2914063205262B0F3705313B5C317E563A2C330A2F3E072051112902214A170A1F19331F3908501A3D2208090F34601A1D04332B37163F2A7E155223000C332928271D29211B3C0E0F553E3B0F70153F477C340766414345704849663D410A23344B7C413F4739273A1A434F393E484966414345704835641102063B090E232F020835344B7C413F47330704680702063518012F4F140C340F0C324F13000C4A451A0F43457048496641433972181B2905160624344B7C413F47030D0536092A210C4A451A0F434570484966414339721E0C34120A0A3E344B7C413F476146591A433F0B704849661C4F393E484966413F47201A063008070022344B7C413F4716090A23310B0C0C4A35281C414972040621060A0B374A5320000F163515\",\n" +
            "        \"licenseDocument\": true,\n" +
            "        \"licenseFacial\": false,\n" +
            "        \"licenseTokenDocument\": true,\n" +
            "        \"logging\": false,\n" +
            "        \"os\": \"iOS\",\n" +
            "        \"packageName\": \"com.facephi.widget.pe\",\n" +
            "        \"product\": \"SelphID\",\n" +
            "        \"version\": \"1.0\"\n" +
            "    },\n" +
            "    \"provider\": \"FacePhi\"\n" +
            "}";
  String _widgetResult = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
           children:<Widget>[
        Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(child: MaterialButton(child: Text('Capture Document'), onPressed: startSelphIDCapture, 
                    color: Colors.lightBlueAccent, textColor: Colors.black, splashColor: Colors.blueAccent, padding: EdgeInsets.all(20.0), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))))),
        Padding(
        padding: EdgeInsets.all(16.0),
        child: Card( child:Text("$_widgetResult")))
         ]))
        ),
    );
  }





/************************SELPHID DOCUMENT DETECTION METHODS ******************************/



/* Launch the "SelphID" Plugin and returns the document data and all the images captured from it. */
  Future<void> startSelphIDCapture() async {
// Platform messages may fail, so we use a try/catch PlatformException.
    Map resultJson; // Result
    String previousOCRData;
    try {
    _configurationWidget = SelphIDConfiguration();
    _configurationWidget.showTutorial = false;
    _configurationWidget.specificData = "ES|<ALL>";
    _configurationWidget.scanMode = SelphIDScanMode.CAP_MODE_SEARCH;
    _configurationWidget.documentType = SelphIDDocumentType.DT_IDCARD; // ID_CARD option detects documents, ID_PASSPORT option detects passports
    
    try {
      if (Platform.isIOS) {
        resultJson = await SelphidPlugin.startSelphIDWidget(operationMode: _operationMode, resourcesPath: _resourcesPath,
          widgetLicense: _licenseIOS, previousOCRData: previousOCRData, widgetConfigurationJSON: _configurationWidget);
  } else if(Platform.isAndroid) {
    resultJson = await SelphidPlugin.startSelphIDWidget(operationMode: _operationMode, resourcesPath: _resourcesPath,
          widgetLicense: _licenseAndroid, previousOCRData: previousOCRData, widgetConfigurationJSON: _configurationWidget);
  } else {
    _widgetResult = 'Error: Incorrect platform.';
  }
    } on PlatformException {
      _widgetResult = 'Error: Failed to get widget information.';
    }

    

    } on Exception catch(e) {
    _widgetResult = ('error caught: $e');
  }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
     if(manageSelphIDStatus(resultJson)) {
      // _documentData: OCR info
      _widgetResult = resultJson['documentData']; // OCR

      /* 
      // Diagnostic result
      resultJson["finishStatus"]; 
      resultJson["errorType"];
      
      // Plain data Results
      resultJson["frontDocumentImage"]; // Imagen frontal del documento entero
      resultJson["backDocumentImage"];  // Imagen trasera del documento entero
      resultJson["faceImage"];
      
      
      // Encrypted and tokenized data Results (send to the server)
      resultJson["tokenOCR"]; // Datos del OCR encriptados. Para el proceso Extracción de datos (OCR)
      resultJson["tokenFaceImage"]; // Imagen de la cara del documento encriptada. Para el proceso de autenticación facial (plantillas)
      resultJson["tokenFrontDocument"]; // Imagen frontal del documento entero encriptadas
      resultJson["tokenBackDocument"]; // Imagen trasera del documento entero encriptadas
      */
     }
   
      //showDialogAlert(context);
    });

  }


bool manageSelphIDStatus(Map<dynamic, dynamic> resultJson) {
    if(resultJson != null)
    {
        // Manage Plugin process Status
        switch (SelphIDFinishStatus.getEnum(resultJson['finishStatus'])) {
            case SelphIDFinishStatus.STATUS_OK: // OK
            _widgetResult = 'Ok Process. TimeoutStatus: ' + SelphIDFinishStatus.getEnum(resultJson['timeoutStatus']).toString();
                break;
            case SelphIDFinishStatus.STATUS_ERROR: // Error
                // Manage error type
                if (resultJson['errorType']) {
                    if (resultJson['errorType'] == SelphIDErrorType.TE_UNKNOWN_ERROR.toInt()) // Unknown Error
                    {
                        _widgetResult = resultJson['errorMessage'];
                    }
                    if (resultJson['errorType'] == SelphIDErrorType.TE_CAMERA_PERMISSION_DENIED.toInt()) // Camera Permission Denied
                    {
                        _widgetResult = 'Camera permission denied';
                    }
                    if (resultJson['errorType'] ==  SelphIDErrorType.TE_SETTINGS_PERMISSION_ERROR.toInt()) // Settings Permission Denied
                    {
                        _widgetResult = 'Write Settings permission denied';
                    }
                    if (resultJson['errorType'] == SelphIDErrorType.TE_HARDWARE_ERROR.toInt()) // Hardware error
                    {
                        _widgetResult = 'Hardware Error';
                    }
					          if (resultJson['errorType'] ==  SelphIDErrorType.TE_EXTRACTION_LICENSE_ERROR.toInt()) 
                    {
                        _widgetResult = 'Extraction License Error';
                    }
					          if (resultJson['errorType'] == SelphIDErrorType.TE_UNEXPECTED_CAPTURE_ERROR.toInt()) 
                    {
                        _widgetResult = 'Unexpected Capture Error';
                    }
					          if (resultJson['errorType'] == SelphIDErrorType.TE_CONTROL_NOT_INITIALIZATED_ERROR.toInt()) 
                    {
                        _widgetResult = 'Control Not Initializated Error';
                    }
					          if (resultJson['errorType'] == SelphIDErrorType.TE_BAD_EXTRACTOR_CONFIGURATION_ERROR.toInt()) 
                    {
                        _widgetResult = 'Bad Extractor Configuration Error';
                    }
                }
                else {
                       _widgetResult = 'Unknown Error';
                }
                return false;
            case SelphIDFinishStatus.STATUS_CANCEL_BY_USER: // CancelByUser
                _widgetResult = 'Canceled by the user';
                return false;
            case SelphIDFinishStatus.STATUS_TIMEOUT: // Timeout
                _widgetResult = 'Extractor Timeout. Status: ' + SelphIDFinishStatus.getEnum(resultJson['timeoutStatus']).toString();
                return false;
            default:
        }
    } else return false;

    return true;
  }
}
