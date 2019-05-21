import UIKit

class ImagesListViewController: UIViewController {
    
    var viewModel = ImagesListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.updateData { (result) in
            switch result {
            case .success(let urls): urls.forEach() { print ($0.image.absoluteString) }
            default: return
            }
        }
    }
}

