import Foundation
import UIKit

enum NetworkError: Error {
    case badURL
    case failedToLoad
    case jsonParsing
    case image
}

let cache = NSCache<NSString, UIImage>()

struct Network {
    let jsonDecoder = JSONDecoder()

    func fetch<T: Decodable>(url: String, typeOf _: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: url) else { completion(.failure(.badURL)); return }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Failed to fetch \(url)")
                completion(.failure(.failedToLoad))
                return
            }
            do {
                let object = try self.jsonDecoder.decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(object)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.jsonParsing)) }
            }
        }
        task.resume()
    }

    func fetch<T: Decodable>(url: String, typeOf _: T.Type) async throws -> T {
        guard let url = URL(string: url) else { throw NetworkError.badURL }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        return try jsonDecoder.decode(T.self, from: data)
    }
}
