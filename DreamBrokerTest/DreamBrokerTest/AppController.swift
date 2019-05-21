import Foundation


enum AppControllerError: Error {
    case imageList
}

struct AppController {
    let network = Network()
    let baseURL = "http://my-json-server.typicode.com/mdislam/rest_service/data"


    func buildImageList(completion: @escaping (Result<[URL], AppControllerError>) -> Void) {
        network.fetch(url: baseURL, typeOf: ImageList.self) { (result) in
            switch result {
            case .success(let dataResponse): print(dataResponse) //TODO
            case .failure(_): completion(.failure(.imageList))
            }
        }
    }
}
