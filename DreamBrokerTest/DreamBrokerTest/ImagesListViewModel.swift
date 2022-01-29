import Foundation
import UIKit

enum ImagesListViewModelError: Error {
    case generic
}

let defaultNumberOfItems = 5

@MainActor
class ImagesListViewModel {
    private let network = Network()
    private let baseURL = "http://my-json-server.typicode.com/mdislam/rest_service/data"
    var displayedImages: [DisplayedImage]?

    struct DisplayedImage {
        let url: URL
        let text: String?
    }

    var errorText = ""
    var images = [DisplayedImage]()

    func updateData(numberOfItems: Int = defaultNumberOfItems) async throws -> [DisplayedImage] {
        let imagesMorphemes = try await network.fetch(url: baseURL, typeOf: ImagesMorphemes.self)
        guard let shuffledNames = imagesMorphemes.imageTexts?.shuffled().prefix(numberOfItems),
              let baseURL = URL(string: imagesMorphemes.baseURL),
              let apiPath = URL(string: imagesMorphemes.apiPath, relativeTo: baseURL)
        else { throw ImagesListViewModelError.generic }
        let urls = shuffledNames.compactMap { imageName -> String in
            let ext = imagesMorphemes.extensions.randomElement() ?? "jpg"
            let size = imagesMorphemes.fileSizes.randomElement() ?? "50kb"
            return "Sample-\(ext)-image-\(size).\(ext)"
        }
        let imageURLs = urls.compactMap { apiPath.appendingPathComponent($0) }
        let viewModels = imageURLs.compactMap {
            DisplayedImage(url: $0, text: $0.path)
        }
        displayedImages = viewModels
        return viewModels
    }
}
