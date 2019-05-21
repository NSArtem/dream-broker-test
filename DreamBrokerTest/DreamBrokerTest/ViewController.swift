import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.delegate.appController.buildImageList { (result) in
            print (result)
        }
        
    }


}

