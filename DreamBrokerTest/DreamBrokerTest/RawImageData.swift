import Foundation

struct RawImageData: Decodable {
    let baseURL: String
    let apiPath: String
    let extensions: [String]
    let fileSizes: [String]
    let imageTexts: [String]?
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case apiPath = "api_path"
        case extensions
        case fileSizes = "file_sizes"
        case imageTexts = "images_texts"
    }
}
