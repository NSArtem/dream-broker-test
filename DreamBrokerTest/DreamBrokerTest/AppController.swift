import Foundation


enum AppControllerError: Error {
    case imageList
}

struct AppController {
    let network = Network()
    let baseURL = "http://my-json-server.typicode.com/mdislam/rest_service/data"

    func buildImageList(completion: @escaping (Result<[URL], AppControllerError>) -> Void) {
        network.fetch(url: baseURL, typeOf: RawImageData.self) { (result) in
            switch result {
            case .success(let dataResponse):
                var urls = [String]()
                for ext in dataResponse.extensions {
                    for fileSize in dataResponse.fileSizes {
                        urls.append("/Sample-\(ext)-image-\(fileSize).\(ext)")
                    }
                }
                guard let baseURL = URL(string: dataResponse.baseURL) else { return } //TODO error
                guard let apiPath = URL(string: dataResponse.apiPath, relativeTo: baseURL) else { return } //TODO error
                let imageURLs = urls.compactMap() { apiPath.appendingPathComponent($0) }
                completion(.success(imageURLs))
                
            case .failure(_): completion(.failure(.imageList))
            }
        }
    }
}
