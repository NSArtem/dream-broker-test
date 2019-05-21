import Foundation

enum NetworkError: Error {
    case badURL
    case failedToLoad
    case jsonParsing
    case image
}

struct Network {
    let jsonDecoder = JSONDecoder()
    
    func fetch<T: Decodable>(url: String, typeOf: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { (completion(.failure(.badURL))); return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Failed to fetch \(url)")
                completion(.failure(.failedToLoad))
                return
            }
            do {
                let object = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(.jsonParsing))
            }
        }
        task.resume()
    }
    
    func fetch(url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { (completion(.failure(.badURL))); return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Failed to fetch \(url)")
                completion(.failure(.failedToLoad))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
