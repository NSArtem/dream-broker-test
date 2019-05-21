import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.delegate.appController.buildImageList { (result) in
            switch result {
            case .success(let urls): urls.forEach() { print ($0.absoluteString) }
            default: return
            }
        }
    }
}

