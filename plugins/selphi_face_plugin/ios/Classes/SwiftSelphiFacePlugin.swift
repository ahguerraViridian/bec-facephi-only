import Flutter
import UIKit
import Foundation
import FPhiWidgetSelphi

public class SwiftSelphiFacePlugin: NSObject, FlutterPlugin {
    var selphiWidget: SelphiWidget?
    var callPlugin: FlutterMethodCall?
    var resultPlugin: FlutterResult?
    var enableWidgetEventListener: Bool = false
    var enableGenerateTemplateRaw: Bool = false
    var enableWidgetEventQRListener: Bool = false
    var isQRValid: Bool = false
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "selphi_face_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSelphiFacePlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        resultPlugin = result;
        if (call.method.elementsEqual("startSelphiFaceWidget")) {
            self.startExtraction(call, result)
        }
        if (call.method.elementsEqual("generateTemplateRaw")) {
            self.generateTemplateRaw(call, result)
        }
    }
    
    func generateTemplateRaw(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let arguments = call.arguments as? NSDictionary
        guard let imageBase64 = arguments!["imageBase64"] as? String else {
            result(FlutterError.init(code: "GENERIC ERROR",
                                     message: "'ImageBase64' is null",
                                     details: nil))
            return
        }
        
        let data = Data(base64Encoded: imageBase64, options: .ignoreUnknownCharacters)
        if let templateRaw = FPhiWidget.generateTemplateRaw(from: data) {
            let templateRawBase64 = templateRaw.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            result(templateRawBase64)
        } else {
            result(FlutterError.init(code: "GENERIC ERROR",
                                     message: "The template generation failed",
                                     details: nil))
        }
    }
    
    public func startExtraction(_ call: FlutterMethodCall, _ result: FlutterResult) {
        let config = call.arguments as? NSDictionary
        guard let resourcesPath = config!["resourcesPath"] as? String else {
            result(FlutterError.init(code: "GENERIC ERROR",
                                     message: "Must provide a valid 'Resources Path'",
                                     details: nil))
            return
        }
        let strBundle = Bundle.main.path(forResource: resourcesPath, ofType: "zip")
        let arguments = config!["widgetConfigurationJSON"] as? NSDictionary
        let isCameraFrontalPreferred = arguments!["frontalCameraPreferred"] ?? true
        self.enableGenerateTemplateRaw = arguments!["enableGenerateTemplateRaw"] as? Bool ?? false
        
        do {
            try self.selphiWidget = SelphiWidget(
                    frontCameraIfAvailable: isCameraFrontalPreferred as! Bool,
                    resources: strBundle,
                    delegate: self)
        }
        catch let error {
            print(error)
            self.rejectPromise(errorMessage: "Error: Problem creating the widget instance")
            return
        }

        guard let currentSelphiWidget = self.selphiWidget else {
            rejectPromise(errorMessage: "Error: Problem creating the widget instance. The widget is null")
            return
        }
        
        currentSelphiWidget.qrMode = arguments!["qrMode"] as? Bool ?? false
        self.enableWidgetEventQRListener = currentSelphiWidget.qrMode
        currentSelphiWidget.debugMode = arguments!["debug"] as? Bool ?? false
        currentSelphiWidget.cropImagesToFace = arguments!["crop"] as? Bool ?? false
        if let cropRatio = arguments!["cropPercent"] as? NSNumber {
            currentSelphiWidget.cropRatio = Float(truncating: cropRatio)
        }
        currentSelphiWidget.stabilizationMode = arguments!["stabilizationMode"] as? Bool ?? true
        currentSelphiWidget.templateRawOptimized = arguments!["templateRawOptimized"] as? Bool ?? true
        if let sceneTimeout = arguments!["sceneTimeout"] as? NSNumber {
            currentSelphiWidget.sceneTimeout = Float(truncating: sceneTimeout)
        }
        if let jpgQuality = arguments!["jpgQuality"] as? NSNumber {
            currentSelphiWidget.jpgQuality = Float(truncating: jpgQuality)
        }
        
        currentSelphiWidget.logImages = arguments!["enableImages"] as? Bool ?? false
        self.enableWidgetEventListener = arguments!["enableWidgetEventListener"] as? Bool ?? false
        if let desiredCameraWidth = arguments!["desiredCameraWidth"] as? Int32 {
            currentSelphiWidget.desiredCameraWidth = Int32(truncating: NSNumber(value: desiredCameraWidth))
        }
        if let desiredCameraHeight = arguments!["desiredCameraHeight"] as? Int32 {
            currentSelphiWidget.desiredCameraHeight = Int32(truncating: NSNumber(value: desiredCameraHeight))
        }
        
        if let livenessMode = arguments!["livenessMode"] as? String {
            switch livenessMode {
                case SelphiEnums.LivenessDiagnostic.livenessPassive.rawValue:
                    currentSelphiWidget.desiredCameraWidth = 1280;
                    currentSelphiWidget.desiredCameraHeight = 720;
                    currentSelphiWidget.livenessMode = FPhiWidgetSelphi.FPhiWidgetLivenessMode.LMLivenessPassive
                    break
                case SelphiEnums.LivenessDiagnostic.none.rawValue:
                    currentSelphiWidget.livenessMode = FPhiWidgetSelphi.FPhiWidgetLivenessMode.LMLivenessNone
                    break
                default:
                    break
            }
        }

        if let userTags = arguments!["uTags"] as? Data {
            if let userTagsDecoded = Data(base64Encoded: userTags, options:   NSData.Base64DecodingOptions(rawValue: 0))
            {
                currentSelphiWidget.userTags = userTagsDecoded
            }
        }
              
        if let locale = arguments!["locale"] {
            currentSelphiWidget.locale = locale as? String;
        }
        
        if let translationsContent = arguments!["translationsContent"] as? String {
            if translationsContent != "" {
                currentSelphiWidget.translationsContent = translationsContent as String;
            }
        }
        
        if let viewsContent = arguments!["viewsContent"] as? String {
            if viewsContent != "" {
                currentSelphiWidget.viewsContent = viewsContent as String;
            }
        }

        let viewCtrl:UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        
        currentSelphiWidget.startExtraction()
        viewCtrl.present(currentSelphiWidget, animated: true, completion: nil)
    }
}

// MARK: - Widget delegate methods
extension SwiftSelphiFacePlugin: FPhiWidgetProtocol
{
    func rejectPromise(errorMessage: String) {
        print("Returning reject result")
        self.resultPlugin!(FlutterError.init(code: "GENERIC ERROR",
                                 message: errorMessage,
                                 details: nil))
     }
    
    public func extractionFinished() {
         //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction finished")
         // Get extractor result
         guard let results = self.selphiWidget!.results else {
            rejectPromise(errorMessage: "Extraction failed: Results are not valid")
            return
         }
        
        // Get best image
        guard let recordBestImage = results.bestImage else {
            rejectPromise(errorMessage: "Best image is not valid")
            return
        }
         guard let bestImage = recordBestImage.image else {
            rejectPromise(errorMessage: "Best image cropped is not valid")
            return
         }
        let bestImageData = bestImage.jpegData(compressionQuality: 0.9)
        // Convert image Data to base64 encodded string
        let bestImageBase64String = bestImageData?.base64EncodedString()
                
        // Get best image cropped
        guard let recordBestImageCropped = results.bestImageCropped else {
            rejectPromise(errorMessage: "Best image cropped is not valid")
            return
        }
        guard let bestImageCropped = recordBestImageCropped.image else {
            rejectPromise(errorMessage: "Best image cropped is not valid")
            return
        }
        let bestImageCroppedData = bestImageCropped.jpegData(compressionQuality: 0.9)
        // Convert image Data to base64 encodded string
        let bestImageCroppedBase64String = bestImageCroppedData?.base64EncodedString()
               
        var templateBase64 = ""
        if let template = self.selphiWidget!.results.result.getTemplate() {
            templateBase64 = template.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        }
              
        var templateRawBase64 = ""
        if let templateRaw = self.selphiWidget!.results.result.getTemplateRaw() {
            templateRawBase64 = templateRaw.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        }
        
        let qrData = self.selphiWidget!.results.qrData ?? ""
        let eyeGlassesScore = self.selphiWidget!.results.result.templateInfo.eyeGlassesScore
        let templateScore = self.selphiWidget!.results.result.templateInfo.templateScore
        
        var result: [String : Any] = [
            "finishStatus": 1 ,
            "finishStatusDescription": "Extraction completed",
            "errorType": 2,
            "template": templateBase64,
            "templateRaw": templateRawBase64,
            "eyeGlassesScore": eyeGlassesScore,
            "templateScore": templateScore,
            "qrData": qrData,
            "bestImage": bestImageBase64String ?? "",
            "bestImageCropped": bestImageCroppedBase64String ?? "",
        ]
        
        if (self.enableGenerateTemplateRaw) {
            let data = Data(base64Encoded: bestImageBase64String ?? "", options: .ignoreUnknownCharacters)
            if let templateRaw = FPhiWidget.generateTemplateRaw(from: data)
            {
                result["bestImageTemplateRaw"] = templateRaw.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
            }
        }
        
        self.resultPlugin!(result)
    }

    public func extractionFailed(_ error: Error!) {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction failed: \(error.debugDescription)")
        rejectPromise(errorMessage: error.debugDescription)
 
    }

    public func extractionCancelled() {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction cancelled")
        resultPlugin!([
            "finishStatus": 3,
            "finishStatusDescription": "Cancelled by user",
            "errorType": 2
        ])
    }

    public func extractionTimeout() {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction timeout")
        resultPlugin!([
            "finishStatus": 4,
            "finishStatusDescription": "Timeout",
            "errorType": 2
        ])
    }

    public func onEvent(_ time: Date?, type: String?, info: String?) {
        if (self.enableWidgetEventListener) {
            //print(String(format: "onSelphiLogEvent: (%lums) %@ - %@", UInt(time!.timeIntervalSince1970 * 1000), type!, info!))
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            let timeDouble = NSNumber(value: time!.timeIntervalSince1970)
            let stringEvent: String = String(format: "{\"selphiLogInfo\":{\"time\":\"%@\", \"type\":\"%@\", \"info\":\"%@\"}}", timeDouble.stringValue, type!, info!)
            
            DispatchQueue.main.async {
                let eventViewCtrl: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
                let channel = FlutterBasicMessageChannel(
                    name: "onSelphiLogEvent",
                    binaryMessenger: eventViewCtrl as! FlutterBinaryMessenger,
                    codec: FlutterStringCodec.sharedInstance())

                channel.sendMessage(stringEvent)
            }
        }
    }
    
    public func qrValidator (_ qrData: String?) -> Bool {
        if (self.enableWidgetEventQRListener) {
            print(String(format: "qrData: %@", qrData!))
            DispatchQueue.main.async {
                let eventViewCtrl: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
                let channel = FlutterBasicMessageChannel(
                    name: "onSelphiLogQREvent",
                    binaryMessenger: eventViewCtrl as! FlutterBinaryMessenger,
                    codec: FlutterStringCodec.sharedInstance())

                let stringEvent: String = String(format: "{\"qrData\":\"%@\"}", qrData!)
                // Send message to Dart and receive reply.
                channel.sendMessage(stringEvent) {(reply: Any?) -> Void in
                    let fromFront: String = reply as? String ?? ""
                    print(fromFront);
                    if (fromFront == "true") {
                        self.enableWidgetEventQRListener = false
                        self.isQRValid = true
                    }
                }
            }
        }
        
        if (self.isQRValid) {
            return true
        }
        return false
    }
}
