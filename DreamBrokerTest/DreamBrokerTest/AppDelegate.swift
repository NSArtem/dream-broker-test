import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    class var delegate: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

    var window: UIWindow?
}

