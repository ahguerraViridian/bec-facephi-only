//
//  ViewController.swift
//  OnboardingSDKExample
//
//  Created by Facundo Matias Beron on 2/11/17.
//  Copyright © 2017 VU Security. All rights reserved.
//

import UIKit
import OnboardingSDK
import AVFoundation
import AVKit

class MainViewController: UIViewController, RecordButtonDelegate {
    
    var scannedDocument : Document = Document()
    @IBOutlet weak var recordButton: RecordButton!
    @IBOutlet weak var usernameTextFiedl: UITextField!
    
    @IBAction func goToConfiguration(_ sender: Any) {
        performSegue(withIdentifier: "toConfig", sender: sender)
    }
    @IBAction func unwind( segue: UIStoryboardSegue) {
    }
    @IBAction func startOnboardingButton(_ sender: Any) {
        self.startOnboardingDemo();
    }
    
    @IBAction func registerFaceButton(_ sender: Any) {
        registerFace()
    }
    
    @IBAction func loginFaceButton(_ sender: Any) {
        loginFace()
    }
    
    @IBAction func startFrontButton(_ sender: Any) {
        startFront()
    }
    
    @IBAction func startBackButton(_ sender: Any) {
        startBack()
    }
    
    @IBAction func startSelfieButton(_ sender: Any) {
        startSelfie();
    }
    
    @IBAction func startBarcodeButton(_ sender: Any) {
        startBarcode()
    }
    
    func tapButton(isRecording: Bool) {

            if isRecording {
                JustHUD.shared.showInView(view: view, withHeader: "Inicializando grabación", andFooter: "Espere un momento...")
                VUOnboardingSDK.sharedInstance.startRecording(videoQualityLevel: 3, landscapeMode: false, success: { (message) in
                    DispatchQueue.main.async {
                        JustHUD.shared.hide()
                    }
                }, onFailure: { (errorMessage) in
                    self.showError(errorMessage.description)
                    DispatchQueue.main.async {
                        JustHUD.shared.hide()
                    }
                    self.recordButton.endRecording()
                    })
            }
            else
            {
                JustHUD.shared.showInView(view: view, withHeader: "Preparando video", andFooter: "Espere un momento...")
                
                VUOnboardingSDK.sharedInstance.stopRecording(success: { (message) in
                    DispatchQueue.main.async {
                        JustHUD.shared.hide()
                    }
                    let url = URL(fileURLWithPath: message)
                        DispatchQueue.main.async {
                            let player = AVPlayer(url: url)
                            let playerController = AVPlayerViewController()
                            playerController.player = player
                            self.present(playerController, animated: true) {
                                        player.play()
                            }
                    }
                }, onFailure: { (errorMessage) in
                    DispatchQueue.main.async {
                        JustHUD.shared.hide()
                    }
                    self.showError("No se pudo grabar la pantalla")
                })
        }
    }
    
    @IBAction func startNativeAuthentication(_ sender: Any) {
        VUOnboardingSDK.sharedInstance.PerformLocalNativeAuthentication(onSuccess: {_ in
            self.showError(title : "Autenticación correcta", error : "Usted pudo pasar la validación biométrica local")
        }, onFailure: {_ in
            self.showError(title : "Autenticación incorrecta", error : "No pudo pasar la validación biométrica local")
        })
    }
    
    var pendingMessage = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        recordButton.delegate = self
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if(pendingMessage != "")
        {
            self.showError(title: "Onboarding", error: self.pendingMessage)
            self.pendingMessage = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeOnboarding(){
        
        
        let serverURL : String = SdkConfig.apiUrl;
        let serverAPIKEY : String = SdkConfig.apikey;
        let onboardingPin : String = "Vjs8r4z+80wjNcr1YKepWQboSIRi63WsWXhIMN+eWys=";
        
        let args = [
            "device-info" : "info",
            "tokenSeguridad" : "token"
        ]
        
        VUOnboardingSDK.sharedInstance.initialize(serviceURL: serverURL, serviceAPIKEY: serverAPIKEY, serviceArgs: args, onboardingPin: onboardingPin)
    }
    
    func startOnboardingDemo(){
        
        if((usernameTextFiedl.text?.isEmpty)!){
            self.showError(title : "Campo Obligatorio", error : "Debe completar el campo Usuario para poder continuar.");
            return
        }
        
        let userIdentifier = usernameTextFiedl.text!
        let ipAddress = ""
        let deviceHash = ""
        let rooted = ""
        var countryCode = Countries.Desconocido;
        let applicationVersion : String = "1.3.2"
        let operativeSystem : String = "iOS"
        let operativeSystemVersion : String = "11"
        let deviceManufacture : String = "Apple"
        let deviceName : String = "Iphone"
        
        var response = OnboardingResponse();
        
        JustHUD.shared.showInView(view: view, withHeader: "Iniciando Operacion", andFooter: "Espere un momento...")
        
        initializeOnboarding();
        VUOnboardingSDK.sharedInstance.newOperationOnboardingService(userIdentifier : userIdentifier, ipAddress: ipAddress, deviceHash: deviceHash, rooted: rooted, applicationVersion : applicationVersion, operativeSystem : operativeSystem, operativeSystemVersion : operativeSystemVersion, deviceManufacture : deviceManufacture, deviceName : deviceName, onSuccess: { (result) in
            DispatchQueue.main.async {
                JustHUD.shared.hide()
            }
            print("New Operation Success:" + result)
            
            response = OnboardingResponse(String(result));
            if(response.code != 901){
                self.showError("Ocurrió un error al intentar iniciar la operación en OnBoarding: " + response.message);
                return
            }
            
            let dictResult = self.convertToDictionary(text: result)
            let operationId : Int = dictResult!["operationId"] as! Int
            let operationGuid : String? = dictResult!["operationGuid"] as! String?
            
            print("OperationID " + String(operationId))
            
            DispatchQueue.main.async {
                let frontController = FrontController(controller: self)
                frontController.showController(scanCountry : countryCode.rawValue, title: "FRENTE DE DOCUMENTO", instructions: "Centre el documento ocupando toda la pantalla", showTutorial: 1, tutorialTitle: "Frente del Documento", tutorialDescription: "Siga la animacion", tutorialNextButtonText: "Entendido", color : "", showPreview : 1, previewConfirmationText: "", buttonTutorialCloseEnabled: true, faceDetectionMaximumWait: 10000, focusOnTouch: false, noDocumentFound: "", faceNotFound: "", previewConfirmationTitle: "", yesPreviewText: "", noPreviewText: "", noDocumentFoundTitle: "", faceNotFoundTitle: "", okText: "", enableAudio: false, showCustomBackground: true, enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "", onSuccess: { (resultFront) in
                    print("Capture Front Success")
                    
                    if(resultFront.document != nil && resultFront.document!.rawValue != nil && resultFront.document!.rawValue! != "")
                    {
                        self.scannedDocument = resultFront.document!
                    }
                    
                    DispatchQueue.main.async {
                        JustHUD.shared.showInView(view: self.view, withHeader: "Enviando el Frente", andFooter: "Espere un momento...")
                    }
                    VUOnboardingSDK.sharedInstance.addFrontOnboardingService(userIdentifier : userIdentifier, operationId: String(operationId), imageBase64: resultFront.imageBase64!, operationGuid: operationGuid, onSuccess: { (result) in
                        
                        DispatchQueue.main.async {
                            JustHUD.shared.hide()
                        }
                        
                        print("Add Front Success" + String(result))
                        
                        
                        response = OnboardingResponse(String(result));
                        if(response.code != 909)
                        {
                            self.showError("Ocurrió un error al intentar enviar el frente del documento a Onboarding: " + response.message);
                            return;
                        }else{
                            do{
                                let decoder = JSONDecoder();
                                let frontResponse = try decoder.decode(AddFrontResponse.self, from: result.data(using: .utf8)!);
                                countryCode = self.detectedToScanCountry(detectedCountry: frontResponse.detectedCountry!);
                                
                                if(frontResponse.addDocumentPictureRequired!)
                                {
                                    if(resultFront.faceBase64 != nil && resultFront.faceBase64! != "")
                                    {
                                        self.addDocumentImage(operationId: operationId, userIdentifier: userIdentifier, resultFront: resultFront, countryCode: countryCode, addBackRequired: frontResponse.addBackRequired!, operationGuid: operationGuid);
                                    }else{
                                        self.showError("No se detecto un rostro en el documento, vuelva a intentarlo: " + response.message);
                                        return;
                                    }
                                }else if(frontResponse.addBackRequired!)
                                {
                                    self.captureBack(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid)
                                }else{
                                    self.addBarcode(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid);
                                }

                            }catch
                            {
                                self.showError("Ocurrió un error al intentar enviar el frente del documento a Onboarding");
                                return;
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            JustHUD.shared.showInView(view: self.view, withHeader: "Enviando recorte de cara", andFooter: "Espere un momento...")
                        }
                        
                    }) { (error) in
                        //addFrontOnboardingService
                        self.showError("Ocurrió un error de comunicación al intentar enviar el frente del documento a OnBoarding");
                        print("Error addFrontOnboardingService" + error)
                    }
                }) { (error) in
                    //frontController
                    self.showError("Ocurrió un error de comunicación al intentar capturar el frente del documento");
                    print("Error frontController" + error.errorMessage!)
                }
            }
        }) { (error) in
            //newOperationOnboardingService
            self.showError("Ocurrió un error de comunicación al intentar iniciar la operación");
            print("Error newOperationOnboardingService" + error)
        }
    }
    
    func addBack(operationId: Int, userIdentifier : String, countryCode : Countries, operationGuid: String?, resultBack : BackCallback){
        DispatchQueue.main.async {
            JustHUD.shared.showInView(view: self.view, withHeader: "Enviando el Dorso", andFooter: "Espere un momento...")
        }
        VUOnboardingSDK.sharedInstance.addBackOnboardingService(userIdentifier : userIdentifier, operationId: String(operationId), imageBase64: resultBack.imageBase64!, operationGuid: operationGuid, onSuccess: { (result) in
            
            DispatchQueue.main.async {
                JustHUD.shared.hide()
            }
            
            print("Add Back Success" + String(result))
            
            let response = OnboardingResponse(String(result));
            if(response.code != 912)
            {
                self.showError("Ocurrió un error al intentar enviar el dorso del documento a Onboarding: " + response.message);
                return;
            }
            
            if(self.requiresBarcode(countryCode: countryCode))
            {
            self.addBarcode(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid)
            }
            else
            {
                self.captureSelfie(operationId: operationId, userIdentifier: userIdentifier, operationGuid: operationGuid)
            }
            
        }) { (error) in
            //addBackOnboardingService
            self.showError("Ocurrió un error de comunicación al intentar enviar el barcode del documento a OnBoarding");
            print("Error selfieController" + error)
        }
    }
    
    func captureSelfie(operationId: Int, userIdentifier : String, operationGuid: String?)
    {
        DispatchQueue.main.async {
            let selfieController = SelfieController(controller: self)
            
            selfieController.showController(smileText : "", closeEyesText : "", winkEyeText : "", moveFaceToLeftText : "", moveFaceToRightText : "", showTutorial: 1, tutorialTitle: "", tutorialDescription: "", color: "", winkMinSeconds: 3, winkMaxSeconds: 5, eyesClosedMinSeconds: 3, eyesClosedMaxSeconds: 5, smileMinSeconds: 3, smileMaxSeconds: 5, minimumAngle: 30, maxAngleJumpAllowed: 30, smileMinimumScore: 10, winkMinimumScore: 10, eyesClosedMinimumScore: 10, minimumValidGestures: 1, maxResetsBeforeBlock: 5, maxInactivitySeconds: 5, disableFaceMoveGesture : true, gesturesAmount: 3, buttonTutorialCloseEnabled: true, buttonCloseEnabled: true, tutorialNextButtonText: "Continuar", faceCenterText : "", hideCircleProgressBar : false, hideGestureInstructionAnimation: false, backgroundColor: "", textColor: "", closeText: "", progressBarColor: "", progressCirclesColor: "", clearBackgroundRecommendation: "", lightEnvironmentRecommendation: "", clearFaceRecommendation: "", centerMobileRecommendation: "", resultsTitle: "", resultsSubtitle: "", resultsContinueButtonText: "", watchRecommendationsAgain: "", smileHelpText: "", winkHelpText: "", closeEyesHelpText: "", moveFaceHelpText: "", placeFaceInSilhouette: "", keepMobileFirm: "", avoidMobileMoves: "", clearBackgroundProcessRecommendation: "", cameraNotAvailableTitle: "", cameraNotAvailableDescription: "", understoodText: "", processingText: "", showRoundedTopBar: false, topBarTitle: "", hideInstructionsText: false, hideSoundButton: false, showCloseButtonBorders: false, showStageIndicator: false, stageIndicatorColor: "", beginWithoutPreview: false, centerInstructionGif: false,  showLargeSoundIndicator: false, soundIndicatorInstructions: "", disableWinkGesture : false, disableEyesClosedGesture : false, disableSmileGesture : false , showResultInFailure: true, showFullScreenLoader: false, validatingText: "", middleInstructionGif: false, welcomeText: "", showFinalMessage: false, finalSuccessMessage: "", finalFailMessage: "", resultsCompactVersion: false, showCenterProgressCircle: false, centerProgressCircleColor: "", disableWelcomeAudio: false, disableInstructionsAudios: false, showLeftInstructionGif: false, showHorizontalProgress: false, showBottomTip: false, bottomTipText: "", showBottomCloseText: false, bottomCloseTextColor: "", bottomCloseText: "", onSuccess: { (resultSelfie) in

                print("Capture Selfie Success")
                
                let selfieBodyList : [SelfieBody] = resultSelfie.selfieBodyList!
                let analysisSelfieBodyList : [SelfieBody] = resultSelfie.analysisSelfieBodyList!
                
                DispatchQueue.main.async {
                    JustHUD.shared.showInView(view: self.view, withHeader: "Registrando", andFooter: "Espere un momento...")
                }
                VUOnboardingSDK.sharedInstance.registerOnboardingService(selfieBodyList: selfieBodyList, analysisSelfieBodyList: analysisSelfieBodyList, userIdentifier : userIdentifier, operationId: String(operationId), operationGuid: operationGuid, onSuccess: { (result) in
                    DispatchQueue.main.async {
                        JustHUD.shared.hide()
                    }
                    print("Register Onboarding Success" + String(result))
                    
                    let response = OnboardingResponse(String(result));
                    if(response.code != 932)
                    {
                        self.showError("Ocurrió un error al intentar realizar el registro en Onboarding: " + response.message);
                        return;
                    }
                    
                    DispatchQueue.main.async {
                        JustHUD.shared.showInView(view: self.view, withHeader: "Terminando", andFooter: "Espere un momento...")
                    }
                    VUOnboardingSDK.sharedInstance.endOperationOnboardingService(userIdentifier : userIdentifier, operationId: String(operationId), operationGuid: operationGuid, onSuccess: { (result) in
                        DispatchQueue.main.async {
                            JustHUD.shared.hide()
                        }
                        print("End Operation Onboarding Success" + String(result))
                        
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Resultado", message: result, preferredStyle: UIAlertController.Style.alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                                (result : UIAlertAction) -> Void in
                                print("OK")
                            }
                            
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }) { (error) in
                        //endOperationOnboardingService
                        self.showError("Ocurrió un error de comunicación al intentar finalizar la operación en OnBoarding");
                        print("Error endOperationOnboardingService" + error)
                    }
                }) { (error) in
                    //registerOnboardingService
                    self.showError("Ocurrió un error al de comunicación intentar realizar el registro en OnBoarding");
                    print("Error registerOnboardingService" + error)
                }
            }) { (selfieErrorCallback) in
                //selfieController
                self.showError("Ocurrió un error de comunicación al capturar la selfie");
                print("Error selfieController" + selfieErrorCallback.errorMessage)
            }
        }
    }
    
    func requiresBarcode(countryCode : Countries) -> Bool {
        var requires = false;
        
        switch (countryCode) {
        case .Colombia, .Peru, .Panama, .RepublicaDominicana, .ElSalvador, .PeruNuevo, .Argentina, .Ecuador:
            requires = true;
            break;
        default:
            requires = false;
            break;
        }
        
        return requires;
    }
    
    func addBarcode(operationId: Int, userIdentifier : String, countryCode : Countries, operationGuid: String?)
    {
        if(self.scannedDocument.rawValue != nil && self.scannedDocument.rawValue! != "")
        {
            self.scannedDocument = DocumentParser.Parse(rawValue: self.scannedDocument.rawValue!, country: countryCode);
        }
        
        if (self.scannedDocument.number == nil){
            DispatchQueue.main.async {
                self.showError("No fue posible leer el barcode del documento");
            }
        } else {
            
            DispatchQueue.main.async {
                JustHUD.shared.showInView(view: self.view, withHeader: "Enviando el Barcode", andFooter: "Espere un momento...")
            }
            VUOnboardingSDK.sharedInstance.addBarcodeOnboardingService(userIdentifier : userIdentifier, operationId: String(operationId), document: self.scannedDocument, operationGuid: operationGuid, onSuccess: { (result) in
                DispatchQueue.main.async {
                    JustHUD.shared.hide()
                }
                
                print("Add Barcode Success: " + String(result))
                
                let response = OnboardingResponse(String(result));
                if(response.code != 920)
                {
                    self.showError("Ocurrió un error al intentar enviar el barcode del documento a Onboarding: " + response.message);
                    return;
                }
                
                self.captureSelfie(operationId: operationId, userIdentifier: userIdentifier, operationGuid: operationGuid)
                
                
                
            }) { (error) in
                //addBarcodeOnboardingService
                self.showError("Ocurrió un error de comunicación al intentar enviar el barcode del documento a OnBoarding");
                print("Error addBarcodeOnboardingService: " + error)
            }
        }
    }
    func captureBack(operationId: Int, userIdentifier : String, countryCode : Countries, operationGuid: String?)
    {
        DispatchQueue.main.async {
            let backController = BackController(controller: self)
            backController.showController(scanCountry : countryCode.rawValue, title: "DORSO DEL DOCUMENTO", instructions: "Centre el documento ocupando toda la pantalla", showTutorial: 1, tutorialTitle: "", tutorialDescription: "", tutorialNextButtonText: "Entendido", color : "", showPreview: 1, previewConfirmationText: "", barcodeDetectionMaximumWait: 10000, buttonTutorialCloseEnabled: true, focusOnTouch: false, documentNotDetected: "", codeNotRead: "", yesText: "", noText: "", documentPictureNotDetected: "", previewConfirmationTitle: "", yesPreviewText: "", noPreviewText: "", enableAudio: false, showCustomBackground: true, enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "",  onSuccess: { (resultBack) in
                
                print("Capture Back Success")
                
                if(resultBack.document != nil && resultBack.document!.rawValue != nil && resultBack.document!.rawValue! != "")
                {
                    self.scannedDocument = resultBack.document!;
                }
                
                
                self.addBack(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid, resultBack: resultBack)
            }) { (error) in
                //backController
                self.showError("Ocurrió un error de comunicación al intentar capturar el dorso del documento");
                print("Error backController" + error.errorMessage!)
            }
        }
    }
    
    func addDocumentImage(operationId: Int, userIdentifier : String, resultFront : FrontCallback, countryCode : Countries, addBackRequired : Bool, operationGuid: String?){
        VUOnboardingSDK.sharedInstance.addDocumentImageOnboardingService(userIdentifier : userIdentifier, operationId: String(operationId), imageBase64: resultFront.faceBase64!, operationGuid: operationGuid, onSuccess: { (result) in
            
            DispatchQueue.main.async {
                JustHUD.shared.hide()
            }
            
            print("Add Document Image Success" + String(result))
            
            let response = OnboardingResponse(String(result));
            if(response.code != 938)
            {
                self.showError("Ocurrió un error al intentar enviar la foto del documento a Onboarding: " + response.message);
                return;
            }
            
            if(addBackRequired)
            {
                self.captureBack(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid)
            }else{
                self.addBarcode(operationId: operationId, userIdentifier: userIdentifier, countryCode: countryCode, operationGuid: operationGuid);
            }
            
            
        }) { (error) in
            //addDocumentImageOnboardingService
            self.showError("Ocurrió un error de comunicación al intentar enviar la foto del documento a OnBoarding");
            print("Error addDocumentImageOnboardingService" + error)
        }
        
    }
    

    
    func registerFace(){
        if((usernameTextFiedl.text?.isEmpty)!){
            self.showError(title : "Campo Obligatorio", error : "Debe completar el campo Usuario para poder continuar.");
            return
        }
        self.initializeOnboarding();
        
        let userIdentifier : String = self.usernameTextFiedl.text!
        
        let selfieController = SelfieController(controller: self)
        
        
        selfieController.showController(smileText : "", closeEyesText : "", winkEyeText : "", moveFaceToLeftText : "", moveFaceToRightText : "", showTutorial: 1, tutorialTitle: "", tutorialDescription: "", color: "", winkMinSeconds: 3, winkMaxSeconds: 5, eyesClosedMinSeconds: 3, eyesClosedMaxSeconds: 5, smileMinSeconds: 3, smileMaxSeconds: 5, minimumAngle: 30, maxAngleJumpAllowed: 30, smileMinimumScore: 10, winkMinimumScore: 10, eyesClosedMinimumScore: 10, minimumValidGestures: 1, maxResetsBeforeBlock: 5, maxInactivitySeconds: 5, disableFaceMoveGesture : true, gesturesAmount: 3, buttonTutorialCloseEnabled: true, buttonCloseEnabled: true, tutorialNextButtonText: "Continuar", faceCenterText: "", hideCircleProgressBar : false, hideGestureInstructionAnimation: false, backgroundColor: "", textColor: "", closeText: "", returnAnalysisSelfies: false, progressBarColor: "", progressCirclesColor: "", clearBackgroundRecommendation: "", lightEnvironmentRecommendation: "", clearFaceRecommendation: "", centerMobileRecommendation: "", resultsTitle: "", resultsSubtitle: "", resultsContinueButtonText: "", watchRecommendationsAgain: "", smileHelpText: "", winkHelpText: "", closeEyesHelpText: "", moveFaceHelpText: "", placeFaceInSilhouette: "", keepMobileFirm: "", avoidMobileMoves: "", clearBackgroundProcessRecommendation: "", cameraNotAvailableTitle: "", cameraNotAvailableDescription: "", understoodText: "", processingText: "", showRoundedTopBar: false, topBarTitle: "", hideInstructionsText: false, hideSoundButton: false, showCloseButtonBorders: false, showStageIndicator: false, stageIndicatorColor: "", beginWithoutPreview: false, centerInstructionGif: false,  showLargeSoundIndicator: false, soundIndicatorInstructions: "", disableWinkGesture : false, disableEyesClosedGesture : false, disableSmileGesture : false, showResultInFailure: true, showFullScreenLoader: false, validatingText: "", middleInstructionGif: false, welcomeText: "", showFinalMessage: false, finalSuccessMessage: "", finalFailMessage: "", resultsCompactVersion: false, showCenterProgressCircle: false, centerProgressCircleColor: "", disableWelcomeAudio: false, disableInstructionsAudios: false, showLeftInstructionGif: false, showHorizontalProgress: false, showBottomTip: false, bottomTipText: "", showBottomCloseText: false, bottomCloseTextColor: "", bottomCloseText: "", enableScreenRecording: false, videoQualityLevel: 1, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "", onSuccess: { (resultSelfie) in
            
            let selfieBodyList : [SelfieBody] = resultSelfie.selfieBodyList!
            let analysisSelfieBodyList : [SelfieBody] = resultSelfie.analysisSelfieBodyList!
            
            let applicationVersion : String = "1.3.2"
            let operativeSystem : String = "iOS"
            let operativeSystemVersion : String = "11"
            let deviceManufacture : String = "Apple"
            let deviceName : String = "Iphone"
            
            DispatchQueue.main.async {
                JustHUD.shared.showInView(view: self.view, withHeader: "Registrando", andFooter: "Espere un momento...")
            }
            
            VUOnboardingSDK.sharedInstance.registerFaceService(selfieBodyList: selfieBodyList, analysisSelfieBodyList: analysisSelfieBodyList, userIdentifier: userIdentifier, applicationVersion : applicationVersion, operativeSystem : operativeSystem, operativeSystemVersion : operativeSystemVersion, deviceManufacture : deviceManufacture, deviceName : deviceName, onSuccess: { (result) in
                DispatchQueue.main.async {
                    JustHUD.shared.hide()
                }
                print("Example App - Register Success. Response received...: " + String(describing: result))

                let response = OnboardingResponse(String(result));
                if(response.code == 932)
                {
                    self.showError(title: "Registro Exitoso", error: "El registro finalizó correctamente");
                }
                else
                {
                    self.showError(response.message);
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    JustHUD.shared.hide()
                }
                
                self.showError(title: "Registro Fallido", error: error);
            }
            
        }) { (selfieErrorCallback) in
            //selfieController
            self.showError("Ocurrió un error de comunicación al intentar capturar la selfie");
            print("Error selfieController" + selfieErrorCallback.errorMessage)
        }
        
        
    }
    
    func loginFace(){
        if((usernameTextFiedl.text?.isEmpty)!){
            self.showError(title : "Campo Obligatorio", error : "Debe completar el campo Usuario para poder continuar.");
            return
        }
        self.initializeOnboarding();
        
        let userIdentifier : String = self.usernameTextFiedl.text!
        
        let selfieController = SelfieController(controller: self)
        
        selfieController.showController(smileText : "", closeEyesText : "", winkEyeText : "", moveFaceToLeftText : "", moveFaceToRightText : "", showTutorial: 1, tutorialTitle: "", tutorialDescription: "", color: "", winkMinSeconds: 3, winkMaxSeconds: 5, eyesClosedMinSeconds: 3, eyesClosedMaxSeconds: 5, smileMinSeconds: 3, smileMaxSeconds: 5, minimumAngle: 30, maxAngleJumpAllowed: 30, smileMinimumScore: 10, winkMinimumScore: 10, eyesClosedMinimumScore: 10, minimumValidGestures: 1, maxResetsBeforeBlock: 5, maxInactivitySeconds: 5, disableFaceMoveGesture : true, gesturesAmount: 3, buttonTutorialCloseEnabled: true, buttonCloseEnabled: true, tutorialNextButtonText: "Continuar", faceCenterText: "", hideCircleProgressBar : false, hideGestureInstructionAnimation: false, backgroundColor: "", textColor: "", closeText: "", progressBarColor: "", progressCirclesColor: "", clearBackgroundRecommendation: "", lightEnvironmentRecommendation: "", clearFaceRecommendation: "", centerMobileRecommendation: "", resultsTitle: "", resultsSubtitle: "", resultsContinueButtonText: "", watchRecommendationsAgain: "", smileHelpText: "", winkHelpText: "", closeEyesHelpText: "", moveFaceHelpText: "", placeFaceInSilhouette: "", keepMobileFirm: "", avoidMobileMoves: "", clearBackgroundProcessRecommendation: "", cameraNotAvailableTitle: "", cameraNotAvailableDescription: "", understoodText: "", processingText: "", showRoundedTopBar: false, topBarTitle: "", hideInstructionsText: false, hideSoundButton: false, showCloseButtonBorders: false, showStageIndicator: false, stageIndicatorColor: "", beginWithoutPreview: false, centerInstructionGif: false,  showLargeSoundIndicator: false, soundIndicatorInstructions: "", disableWinkGesture : false, disableEyesClosedGesture : false, disableSmileGesture : false, showResultInFailure: true, showFullScreenLoader: false, validatingText: "", middleInstructionGif: false, welcomeText: "", showFinalMessage: false, finalSuccessMessage: "", finalFailMessage: "", resultsCompactVersion: false, showCenterProgressCircle: false, centerProgressCircleColor: "", disableWelcomeAudio: false, disableInstructionsAudios: false, showLeftInstructionGif: false, showHorizontalProgress: false, showBottomTip: false, bottomTipText: "", showBottomCloseText: false, bottomCloseTextColor: "", bottomCloseText: "", enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "", onSuccess: { (resultSelfie) in
            
            let selfieBodyList : [SelfieBody] = resultSelfie.selfieBodyList!
            let analysisSelfieBodyList : [SelfieBody] = resultSelfie.analysisSelfieBodyList!
            
            let applicationVersion : String = "1.3.2"
            let operativeSystem : String = "iOS"
            let operativeSystemVersion : String = "11"
            let deviceManufacture : String = "Apple"
            let deviceName : String = "Iphone"
            
            DispatchQueue.main.async {
                JustHUD.shared.showInView(view: self.view, withHeader: "Ingresando", andFooter: "Espere un momento...")
            }
            
            self.initializeOnboarding();
            VUOnboardingSDK.sharedInstance.loginFaceService(selfieBodyList: selfieBodyList, analysisSelfieBodyList: analysisSelfieBodyList, userIdentifier: userIdentifier,applicationVersion : applicationVersion, operativeSystem : operativeSystem, operativeSystemVersion : operativeSystemVersion, deviceManufacture : deviceManufacture, deviceName : deviceName, onSuccess: { (result) in
                
                DispatchQueue.main.async {
                    JustHUD.shared.hide()
                }
                
                print("Example App - Login Success. Response received...: " + String(describing: result))
                
                let response = OnboardingResponse(String(result));
                if(response.code == 2003 || response.code == 1002)
                {
                    self.showError(title: "Login Exitoso", error: "El ingreso se realizó correctamente");
                }
                else
                {
                    self.showError(response.message);
                }
            }) { (error) in
                
                DispatchQueue.main.async {
                    JustHUD.shared.hide()
                }
                self.showError(title: "Login Fallido", error: error);
                print("Example App - Login Fail. Response received...: " + String(describing:error))
            }
            
        }) { (selfieErrorCallback) in
            //selfieController
            self.showError("Ocurrió un error de comunicación al intentar capturar la selfie");
            print("Error selfieController" + selfieErrorCallback.errorMessage)
        }
        
    }
    
    func showDocumentInformation(document : Document?)
    {
        if(document != nil && document!.number != nil && document!.number != "")
        {
            var message = "Documento = " + document!.number!
            
            if(document!.names != "")
            {
                message = message + " | Nombres: " + document!.names
            }
            
            if(document!.lastNames != "")
            {
                message = message + " | Apellidos: " + document!.lastNames
            }
            
            if(document!.gender != "")
            {
                message = message + " | Genero: " + document!.gender
            }
            
            if(document!.birthdate != "")
            {
                message = message + " | Nacimiento: " + document!.birthdate
            }
            
            self.pendingMessage = message
        }
    }
    
    func startFront(){
        //Capturamos el frente
        let frontController = FrontController(controller: self)
        
        frontController.showController(scanCountry : SdkConfig.scanCountry, title: "FRENTE DE DOCUMENTO", instructions: "Centre el documento ocupando toda la pantalla", showTutorial: 1, tutorialTitle: "Frente del Documento", tutorialDescription: "Siga la animacion", tutorialNextButtonText: "Entendido", color : "", showPreview : 1, previewConfirmationText: "", buttonTutorialCloseEnabled: true, faceDetectionMaximumWait: 10000, focusOnTouch: false, noDocumentFound: "", faceNotFound: "", previewConfirmationTitle: "", yesPreviewText: "", noPreviewText: "", noDocumentFoundTitle: "", faceNotFoundTitle: "", okText: "", enableAudio: false, showCustomBackground: true, enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "", onSuccess: { (result) in
            
            if(result.videoPath != nil)
            {
                print("Video Saved at : " + result.videoPath!)
            }
            
            if(result.document != nil)
            {
                self.showDocumentInformation(document: result.document!)
            }
        }) { (error) in
            if(error.videoPath != nil)
            {
                print("Video Saved at : " + error.videoPath!)
            }
            print("Example App - Front Fail. Response received...: " + error.errorMessage!)
        }
        
    }
    
    func startBack(){
        //Capturamos el dorso
        let backController = BackController(controller: self)
        backController.showController(scanCountry : SdkConfig.scanCountry, title: "DORSO DEL DOCUMENTO", instructions: "Centre el documento ocupando toda la pantalla", showTutorial: 1, tutorialTitle: "", tutorialDescription: "", tutorialNextButtonText: "Entendido", color : "", showPreview: 1, previewConfirmationText: "", barcodeDetectionMaximumWait: 10000, buttonTutorialCloseEnabled: true, focusOnTouch: false, documentNotDetected: "", codeNotRead: "", yesText: "", noText: "", documentPictureNotDetected: "", previewConfirmationTitle: "", yesPreviewText: "", noPreviewText: "", enableAudio: false, showCustomBackground: true, enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, permissionDeniedTitle: "", cameraAccessText: "", enableText: "", exitText: "", onSuccess: { (result) in
            
            if(result.videoPath != nil)
            {
                print("Video Saved at : " + result.videoPath!)
            }
            
            if(result.document != nil)
            {
                self.showDocumentInformation(document: result.document!)
            }
            
        }) { (error) in
            if(error.videoPath != nil)
            {
                print("Video Saved at : " + error.videoPath!)
            }
            
            print("Example App - Back Fail. Response received...: " + error.errorMessage!)
        }
        
    }
    
    func startSelfie(){
        
        //Capturamos la selfie
        let selfieController = SelfieController(controller: self)
        let parameters = SelfieParameters();
        
        parameters.gesturesAmount = SdkConfig.gesturesAmount
        parameters.disableWinkGesture = !SdkConfig.enableWink
        parameters.disableSmileGesture = !SdkConfig.enableSmile
        parameters.disableEyesClosedGesture = !SdkConfig.enableEyesClosed
        parameters.disableFaceMoveGesture = !SdkConfig.enableMoveFace
        parameters.enableScreenRecording = SdkConfig.enableScreenRecording;

        selfieController.showController(selfieParameters: parameters, onSuccess: { (result) in
            
            if(result.videoPath != nil)
            {
                print("Video Saved at : " + result.videoPath!)
            }
            
            print("Example App - Selfie Success. Response received...: ")
        }) { (selfieErrorCallback) in
            if(selfieErrorCallback.videoPath != nil)
            {
                print("Video Saved at : " + selfieErrorCallback.videoPath!)
            }
            
            if(selfieErrorCallback.helpMessages != nil)
            {
                var errorMessages = "";
                for errorMessage in selfieErrorCallback.helpMessages! {
                    errorMessages = errorMessages + errorMessage + "\r\n";
                }
                self.showError(errorMessages);
            }
        }
    }
    
    func startBarcode(){
        //Capturamos el barcode
        let barcodeController = BarcodeController(controller: self)
        
        
        barcodeController.showController(scanCountry : SdkConfig.scanCountry, title: "QR del Documento", instructions: "Ubique el QR dentro de la pantalla", showTutorial: 1, tutorialTitle: "Titulo del tutorial", tutorialDescription: "Descripcion del Tutorial", tutorialNextButtonText: "", color : "", showPreview : 1, previewConfirmationText : "", buttonTutorialCloseEnabled: true, previewConfirmationTitle: "", yesPreviewText: "", noPreviewText: "", enableScreenRecording: SdkConfig.enableScreenRecording, videoQualityLevel: 3, onSuccess: { (result) in
            
            if(result.videoPath != nil)
            {
                print("Video Saved at : " + result.videoPath!)
            }
            print("Example App - Back Success. Response received...: " + String(describing: result))
        }) { (error) in
            
            if(error.videoPath != nil)
            {
                print("Video Saved at : " + error.videoPath!)
            }
            print("Example App - Back Fail. Response received...: " + error.errorMessage!)
        }
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
        
    }
    
    func showError(title : String, error : String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: error, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
                self.dismiss(animated: false, completion: nil)
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showError(_ error : String){
        showError(title : "Error", error : error)
    }
    
    func parseDocument(detectedCountry: String, rawValue : String) -> Document
    {
        var document = Document();
        
        
        switch (detectedCountry)
        {
        case "argentinaantiguo", "argentina":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Argentina);
            break;
        case "colombia":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Colombia);
            break;
        case "ecuador":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Ecuador);
            break;
        case "uruguay":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Uruguay);
            break;
        case "peru":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Peru);
            break;
        case "perunuevo":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.PeruNuevo);
        break;
        case "pasaporteespaniol":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.PasaporteEspanol);
            break;
        case "realmadrid":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.RealMadrid);
            break;
        case "panama":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.Panama);
            break;
        case "republicadominicana":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.RepublicaDominicana);
            break;
        case "elsalvador":
            document = DocumentParser.Parse(rawValue: rawValue, country: Countries.ElSalvador);
            break;
        default:
            break;
        }
        
        document.rawValue = rawValue;
        
        return document;
    }
    
    func detectedToScanCountry(detectedCountry: String) -> Countries
    {
        var country = Countries.Desconocido;
        
        
        switch (detectedCountry)
        {
        case "argentinaantiguo", "argentina":
            country = Countries.Argentina;
            break;
        case "colombia":
            country = Countries.Colombia;
            break;
        case "ecuador":
            country = Countries.Ecuador;
            break;
        case "uruguay":
            country = Countries.Uruguay;
            break;
        case "peru":
            country = Countries.Peru;
            break;
        case "pasaporteespaniol":
            country = Countries.PasaporteEspanol;
            break;
        case "realmadrid":
            country = Countries.RealMadrid;
            break;
        case "panama":
            country = Countries.Panama;
            break;
        case "republicadominicana":
            country = Countries.RepublicaDominicana;
            break;
        case "elsalvador":
            country = Countries.ElSalvador;
            break;
        case "perunuevo":
            country = Countries.PeruNuevo;
            break;
        default:
            break;
        }
        
        return country;
    }
}

