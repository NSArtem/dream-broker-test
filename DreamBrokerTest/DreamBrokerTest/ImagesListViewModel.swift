import Foundation
import UIKit

enum ImagesListViewModelError: Error {
    case generic
}

class ImagesListViewModel {
    private let network = Network()
    private let baseURL = "http://my-json-server.typicode.com/mdislam/rest_service/data"
    private var rawImagesData: RawImageData?

    struct DisplayedImage {
        let image: URL
        let text: String?
    }
    var errorText = ""
    var images = [DisplayedImage]()
    
    func updateData(completion: @escaping (Result<[DisplayedImage], ImagesListViewModelError>) -> Void) {
        network.fetch(url: baseURL, typeOf: RawImageData.self) { (result) in
            switch result {
            case .success(let dataResponse):
                self.rawImagesData = dataResponse
                var urls = [String]()
                for ext in dataResponse.extensions {
                    for fileSize in dataResponse.fileSizes {
                        urls.append("/Sample-\(ext)-image-\(fileSize).\(ext)")
                    }
                }
                guard let baseURL = URL(string: dataResponse.baseURL) else { return } //TODO error
                guard let apiPath = URL(string: dataResponse.apiPath, relativeTo: baseURL) else { return } //TODO error
                let imageURLs = urls.compactMap() { apiPath.appendingPathComponent($0) }
                let texts = dataResponse.imageTexts?.compactMap() { $0 }
                let displayedImages = imageURLs.map() { return DisplayedImage(image: $0, text: texts?.randomElement()) }
                completion(.success(displayedImages))
            case .failure(_): completion(.failure(.generic))
            }
        }
    }
}
