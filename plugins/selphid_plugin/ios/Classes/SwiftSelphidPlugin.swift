//
//  SelphidPlugin.swift
//  selphid_plugin
//
//  Created by lariel on 10/5/21.
//
import Foundation
import Flutter
import FPhiSelphIDWidgetiOS

public class SwiftSelphIdPlugin: NSObject, FlutterPlugin
{
    var enableWidgetEventListener: Bool = false
    var selphIDWidget: FPhiSelphIDWidget?
    var callPlugin: FlutterMethodCall?
    var resultPlugin: FlutterResult?
    var testImage: UIImage?
    var format: String = "jpeg"
    var quality: CGFloat = CGFloat(1)
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "selphid_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftSelphIdPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        resultPlugin = result;
        if (call.method.elementsEqual("startSelphIDWidget")) {
            self.startSelphIDWgt(call, result: result)
        }
        else if (call.method.elementsEqual("startSelphIDTestImageWidget")) {
            let args = call.arguments as? NSDictionary
            
            self.testImage = readImage((args?.value(forKey: "testImageName") as? String)!);
            self.startSelphIDWgt(call, result: result)
        }
    }
    
    func readImage(_ testImageName: String) -> UIImage {
        var content: UIImage? = nil

        let path = Bundle.main.path(forResource: testImageName, ofType: nil)
        if let path = path {
            content = UIImage(contentsOfFile: path)
        }
        return content!
    }
    
    func startSelphIDWgt(_ call: FlutterMethodCall, result: @escaping FlutterResult)
    {
        let args = call.arguments as? NSDictionary
        let config = args?.value(forKey: "widgetConfigurationJSON") as? NSObject
        
        guard let resourcesPath = args?.value(forKey: "resourcesPath") as? String else {
            result(FlutterError.init(code: "GENERIC ERROR",
                                     message: "Must provide a valid 'Resources Path'",
                                     details: nil))
            return
        }
        guard let license = args?.value(forKey: "widgetLicense") as? String else {
            result(FlutterError.init(code: "GENERIC ERROR",
                                     message: "Must provide a 'License'",
                                     details: nil))
            return
        }

        let strBundle = Bundle.main.path(forResource: resourcesPath, ofType: "zip")

        do {
            try self.selphIDWidget = FPhiSelphIDWidget(
                    backCameraIfAvailable: true,
                    resources: strBundle,
                    delegate: self,
                    license: license)
        } catch {
            self.rejectPromise(errorMessage: "Error: Problem creating the widget instance")
            return
        }

        guard let currentSelphIDWidget = self.selphIDWidget else {
            rejectPromise(errorMessage: "Error: Problem creating the widget instance. The widget is null")
            return
        }
        
        self.enableWidgetEventListener = config?.value(forKey: "enableWidgetEventListener") as? Bool ?? false
        currentSelphIDWidget.generateRawImages = config?.value(forKey: "generateRawImages") as? Bool ?? false
        currentSelphIDWidget.debugMode = config?.value(forKey: "debug") as? Bool ?? currentSelphIDWidget.debugMode
        currentSelphIDWidget.showAfterCapture = config?.value(forKey: "showResultAfterCapture") as? Bool ?? currentSelphIDWidget.showAfterCapture
        currentSelphIDWidget.showTutorial = config?.value(forKey: "showTutorial") as? Bool ?? currentSelphIDWidget.showTutorial
        currentSelphIDWidget.specificData = config?.value(forKey: "specificData") as? String ?? currentSelphIDWidget.specificData
        currentSelphIDWidget.locale = config?.value(forKey: "locale") as? String ?? currentSelphIDWidget.locale
        if let tokenImageQuality = config?.value(forKey: "tokenImageQuality") as? String {
            currentSelphIDWidget.tokenImageQuality = Float(tokenImageQuality) ?? currentSelphIDWidget.tokenImageQuality
        }

        
        if let operationMode = args?.value(forKey: "operationMode") as? String {
            switch operationMode {
            case SelphidEnums.SelphIDOperation.Front.rawValue:
                currentSelphIDWidget.scanSide = FPhiSelphIDWidgetDocumentSide.DSFront
                currentSelphIDWidget.wizardMode = false
                break
            case SelphidEnums.SelphIDOperation.Back.rawValue:
                currentSelphIDWidget.scanSide = FPhiSelphIDWidgetDocumentSide.DSBack
                currentSelphIDWidget.wizardMode = false
                break
            case SelphidEnums.SelphIDOperation.Wizard.rawValue:
                currentSelphIDWidget.scanSide = FPhiSelphIDWidgetDocumentSide.DSFront
                currentSelphIDWidget.wizardMode = true
            default:
                rejectPromise(errorMessage: "Error: Parameter 'operation' is not valid.")
                break
            }
        }
        
        if let format = config?.value(forKey: "compressFormat") as? String {
            switch format {
            case "jpeg":
                self.format = format
                break
            case "png":
                self.format = format
                break
            default:
                self.format = "jpeg"
                break
            }
        }
        
        if let quality = config?.value(forKey: "imageQuality") as? Int {
            self.quality = CGFloat(Int(quality)) / 100.0
            if quality > 0 && quality < 90 {
                print("Warning: imageQuality selection not recommended")
            }
            if (quality < 0 || quality > 100) {
                self.quality = CGFloat(1)
            }
        }
        else {
            self.quality = CGFloat(1)
        }
        
        if let scanMode = config?.value(forKey: "scanMode") as? String {
            switch scanMode {
            case SelphidEnums.SelphIDScanMode.Generic.rawValue:
                currentSelphIDWidget.scanMode = FPhiSelphIDWidgetScanMode.SMGeneric
                break
            case SelphidEnums.SelphIDScanMode.Specific.rawValue:
                currentSelphIDWidget.scanMode = FPhiSelphIDWidgetScanMode.SMSpecific
                break
            case SelphidEnums.SelphIDScanMode.Search.rawValue:
                currentSelphIDWidget.scanMode = FPhiSelphIDWidgetScanMode.SMSearch
            default:
                rejectPromise(errorMessage: "Error: Parameter 'scanMode' is not valid.")
                break
            }
        }

        if let documentType = config?.value(forKey: "documentType") as? String {
            switch documentType {
            case SelphidEnums.SelphIDDocumentType.IDCard.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTIDCard
                break
            case SelphidEnums.SelphIDDocumentType.Passport.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTPassport
                break
            case SelphidEnums.SelphIDDocumentType.DriverLicense.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTDriversLicense
                break
            case SelphidEnums.SelphIDDocumentType.ForeignCard.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTForeignCard
                break
            case SelphidEnums.SelphIDDocumentType.CreditCard.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTCreditCard
                break
            case SelphidEnums.SelphIDDocumentType.Custom.rawValue:
                currentSelphIDWidget.scanType = FPhiSelphIDWidgetDocumentType.DTCustom
                break
            default:
                rejectPromise(errorMessage: "Error: Parameter 'documentType' is not valid.")
                break
            }
        }
        
        if let timeout = config?.value(forKey: "timeout") as? String {
            switch timeout {
            case SelphidEnums.SelphIDTimeout.Short.rawValue:
                currentSelphIDWidget.timeout = FPhiSelphIDWidgetTimeout.TShort
                break
            case SelphidEnums.SelphIDTimeout.Medium.rawValue:
                currentSelphIDWidget.timeout = FPhiSelphIDWidgetTimeout.TMedium
                break
            case SelphidEnums.SelphIDTimeout.Long.rawValue:
                currentSelphIDWidget.timeout = FPhiSelphIDWidgetTimeout.TLong
                break
            default:
                rejectPromise(errorMessage: "Error: Parameter 'timeout' is not valid.")
                break
            }
        }
        
        if (self.testImage != nil) {
            currentSelphIDWidget.testImage = self.testImage;
        }
        
        currentSelphIDWidget.startExtraction()
        if let viewController = (UIApplication.shared.keyWindow?.rootViewController) {
            viewController.present(currentSelphIDWidget, animated: true, completion: nil)
        }
        else
        {
            self.rejectPromise(errorMessage: "Error: viewController Exception.")
            return
        }
    }
}

// MARK: - Widget delegate methods
extension SwiftSelphIdPlugin: FPhiSelphIDWidgetProtocol
{
    func rejectPromise(errorMessage: String) {
        print("Returning reject result")
        self.resultPlugin!(FlutterError.init(code: "GENERIC ERROR",
                                 message: errorMessage,
                                 details: nil))
     }
    
    func parseJson(_ results: FPhiSelphIDWidgetExtractionData, _ jsonString: inout String?) {
        var dictData: Data? = nil
        do {
            dictData = try JSONSerialization.data(
                withJSONObject: results.ocrResults as Any,
                options: [])
            
            if let dictData = dictData {
                jsonString = String(data: dictData, encoding: .utf8)
            }
        }
        catch let errorData {
            print("\(errorData)")
            rejectPromise(errorMessage: "Could not parse ocrResults")
            return
        }
    }
    
    public func captureFinished() {
         //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction finished")
         // Get extractor result
         guard let results = self.selphIDWidget!.results else {
            rejectPromise(errorMessage: "Extraction failed: Results are not valid")
            return
         }
        
        let tokenFrontDocument = results.tokenFrontDocument ?? ""
        let tokenBackDocument = results.tokenBackDocument ?? ""
        let tokenFaceImage = results.tokenFaceImage ?? ""
        let tokenOCR = results.tokenOCR ?? ""
        let matchingSidesScore = results.matchingSidesScore
        let documentCaptured = results.documentCaptured ?? ""
        let captureProgress = results.captureProgress
        let tokenRawFrontDocument = results.tokenRawFrontDocument ?? ""
        let tokenRawBackDocument = results.tokenRawBackDocument ?? ""
        
        var frontDocumentImage = ""
        if results.frontDocument != nil {
            frontDocumentImage = proccessImage(format: self.format, stream: results.frontDocument)
        }
        
        var faceImage = ""
        if results.faceImage != nil {
            faceImage = proccessImage(format: self.format, stream: results.faceImage)
        }
        
        var signatureImage = ""
        if results.signatureImage != nil {
            signatureImage = proccessImage(format: self.format, stream: results.signatureImage)
        }
        
        var backDocumentImage = ""
        if results.backDocument != nil {
            backDocumentImage = proccessImage(format: self.format, stream: results.backDocument)
        }
        
        var fingerprintImage = ""
        if results.fingerprintImage != nil {
            //fingerprintImage = results.fingerprintImage.jpegData(compressionQuality: self.quality)?.base64EncodedString() ?? ""
            fingerprintImage = proccessImage(format: self.format, stream: results.fingerprintImage)
        }
        
        var rawFrontDocumentImage = ""
        if results.rawFrontDocument != nil {
            rawFrontDocumentImage = proccessImage(format: self.format, stream: results.rawFrontDocument)
        }
        
        var rawBackDocumentImage = ""
        if results.rawBackDocument != nil {
            rawBackDocumentImage = proccessImage(format: self.format, stream: results.rawBackDocument)
        }
        
        var jsonString: String? = nil
        parseJson(results, &jsonString)
        
        var result: [String : Any] = [
            "finishStatus": 1,
            "finishStatusDescription": "Extraction completed",
            "errorType": 2,
            "documentData": jsonString ?? "",
            "tokenBackDocument": tokenBackDocument,
            "tokenFrontDocument": tokenFrontDocument,
            "tokenFaceImage": tokenFaceImage,
            "tokenOCR": tokenOCR,
            "documentCaptured": documentCaptured,
            "matchingSidesScore": matchingSidesScore,
            "captureProgress": captureProgress
        ]
        
        if tokenRawFrontDocument != "" {
            result["tokenRawFrontDocument"] = tokenRawFrontDocument
        }
        if tokenRawBackDocument != "" {
            result["tokenRawBackDocument"] = tokenRawBackDocument
        }
        if frontDocumentImage != "" {
            result["frontDocumentImage"] = frontDocumentImage
        }
        if faceImage != "" {
            result["faceImage"] = faceImage
        }
        if signatureImage != "" {
            result["signatureImage"] = signatureImage
        }
        if backDocumentImage != "" {
            result["backDocumentImage"] = backDocumentImage
        }
        if fingerprintImage != "" {
            result["fingerprintImage"] = fingerprintImage
        }
        if rawFrontDocumentImage != "" {
            result["rawFrontDocument"] = rawFrontDocumentImage
        }
        if rawBackDocumentImage != "" {
            result["rawBackDocument"] = rawBackDocumentImage
        }
        
        self.resultPlugin!(result)
    }

    public func proccessImage(format: String, stream: UIImage) -> String {
        var proccessedImage = ""
        if (format == "jpeg") {
            proccessedImage = stream.jpegData(compressionQuality: self.quality)?.base64EncodedString() ?? ""
        }
        else {
            proccessedImage = stream.pngData()?.base64EncodedString() ?? ""
        }
        
        return proccessedImage
    }
    
    public func captureFailed(_ error: Error!) {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction failed: \(error.debugDescription)")
        rejectPromise(errorMessage: error.debugDescription)
    }

    public func captureCancelled() {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction cancelled")
        self.resultPlugin!([
            "finishStatus": 3,
            "finishStatusDescription": "Cancelled by user",
            "errorType": 2
        ])
    }

    public func captureTimeout() {
        //os_log("[Extractor] - %s", log: .default, type: .debug, "Extraction timeout")
        self.resultPlugin!([
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
            let stringEvent: String = String(format: "{\"selphidLogInfo\":{\"time\":\"%@\", \"type\":\"%@\", \"info\":\"%@\"}}", timeDouble.stringValue, type!, info!)
            
            DispatchQueue.main.async {
                let eventViewCtrl: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
                let channel = FlutterBasicMessageChannel(
                    name: "onSelphidLogEvent",
                    binaryMessenger: eventViewCtrl as! FlutterBinaryMessenger,
                    codec: FlutterStringCodec.sharedInstance())

                channel.sendMessage(stringEvent)
            }
        }
    }
}
