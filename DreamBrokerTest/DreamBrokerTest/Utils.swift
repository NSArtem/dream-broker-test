import UIKit

extension UIImage {
    func resizedImage(forSize size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit, resizeImage: Bool = true) {
        contentMode = mode
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            print("Cached image: \(url.absoluteString)")
            let resizedImage = cachedImage.resizedImage(forSize: self.frame.size)
            self.image = resizedImage
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse,
                200 ... 299 ~= httpURLResponse.statusCode,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data) else { return }
                cache.setObject(image, forKey: url.absoluteString as NSString)
                DispatchQueue.main.async() { self.image = image.resizedImage(forSize: self.frame.size) }
            }.resume()
    }
}
