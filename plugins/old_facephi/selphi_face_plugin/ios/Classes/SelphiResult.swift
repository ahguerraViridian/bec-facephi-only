import Foundation

struct SelphiResult: Codable { // Conform to Codable
    var finishStatus: Int
    var finishStatusDescription: String?
    var errorType: Int
    var errorMessage: String?
    var template: String?
    var templateRaw: String?
    var eyeGlassesScore: Float?
    var templateScore: Float?
    var qrData: String?
    var images: [String]?
    var bestImage: String?
    var bestImageCropped: String?
    
    enum CodingKeys: String, CodingKey {
        case finishStatus
        case finishStatusDescription
        case errorType
        case errorMessage
        case template
        case templateRaw
        case eyeGlassesScore
        case templateScore
        case qrData
        case images
        case bestImage
        case bestImageCropped
    }
    
    // The Initializer function from Decodable
    init(from decoder: Decoder) throws {
        // 1 - Container
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        finishStatus = try values.decode(Int.self, forKey: .finishStatus)
        finishStatusDescription = try? values.decodeIfPresent(String.self, forKey: .finishStatusDescription)
        errorType = try values.decode(Int.self, forKey: .errorType)
        errorMessage = try values.decode(String.self, forKey: .errorType)
        template = try? values.decodeIfPresent(String.self, forKey: .template)
        templateRaw = try? values.decodeIfPresent(String.self, forKey: .templateRaw)
        eyeGlassesScore = try? values.decodeIfPresent(Float.self, forKey: .eyeGlassesScore)
        templateScore = try? values.decodeIfPresent(Float.self, forKey: .templateScore)
        qrData = try? values.decodeIfPresent(String.self, forKey: .qrData)
        images = try? values.decodeIfPresent([String].self, forKey: .images)
        bestImage = try? values.decodeIfPresent(String.self, forKey: .bestImage)
        bestImageCropped = try? values.decodeIfPresent(String.self, forKey: .bestImageCropped)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(finishStatus, forKey: .finishStatus)
        try container.encode(finishStatusDescription, forKey: .finishStatusDescription)
        try container.encode(errorType, forKey: .errorType)
        try container.encode(errorMessage, forKey: .errorMessage)
        try container.encode(template, forKey: .template)
        try container.encode(templateRaw, forKey: .templateRaw)
        try container.encode(eyeGlassesScore, forKey: .eyeGlassesScore)
        try container.encode(templateScore, forKey: .templateScore)
        try container.encode(qrData, forKey: .qrData)
        try container.encode(images, forKey: .images)
        try container.encode(bestImage, forKey: .bestImage)
        try container.encode(bestImageCropped, forKey: .bestImageCropped)
    }

}

/* USE
let decoder = JSONDecoder()
let result = try decoder.decode(SelphiResult.self, from: data)
print(result.finishStatus)
print(result.templateRaw)
print(result.bestImage)
 
let encoder = JSONEncoder()
data = try encoder.encode(result)
print(String(data: data, encoding: .utf8)!)
*/
