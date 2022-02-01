//
//  SelphidEnums.swift
//  selphid_plugin
//
//  Created by lariel on 10/5/21.
//

import Foundation

class SelphidEnums {
    enum SelphIDFormatCompress: String, Codable {
        case jpeg = "jpeg"
        case png = "png"
    }
    
    enum SelphIDOperation: String, Codable {
        case Front = "CaptureFront"
        case Back = "CaptureBack"
        case Wizard = "CaptureWizard"
    }

     enum SelphIDDocumentType: String, Codable {
        case IDCard = "DT_IDCard"
        case Passport = "DT_Passport"
        case DriverLicense = "DT_DriverLicense"
        case ForeignCard = "DT_ForeignCard"
        case CreditCard = "DT_CreditCard"
        case Custom = "DT_Custom"
    }

     enum SelphIDScanMode: String, Codable {
        case Generic = "GenericMode"
        case Specific = "SpecificMode"
        case Search = "SearchMode"
    }

     enum SelphIDTimeout: String, Codable {
        case Short = "Short"
        case Medium = "Medium"
        case Long = "Long"
    }

     enum SelphIDErrorType: Int, Codable {
        case UnknownError = 1
        case NoError = 2
        case CameraPermissionError = 3
        case SettingsPermissionError = 4
        case HardwareError = 5
        case ExtractionLicenseError = 6
        case UnexpectedCaptureError = 7
        case ControlNotInitializedError = 8
        case BadExtractorConfigurationError = 9
    }

    enum SelphIDFinishStatus: Int, Codable {
        case Ok = 1
        case Error = 2
        case CancelByUser = 3
        case StatusTimeout = 4
    }
}
