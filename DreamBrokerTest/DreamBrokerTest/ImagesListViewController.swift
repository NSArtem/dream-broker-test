import UIKit

class ImagesListViewController: UIViewController {
    
    var viewModel = ImagesListViewModel()
    var updatingData = false
    var refreshButton: UIBarButtonItem!
    
    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: self,
                                        action: #selector(refreshButtonPressed(sender:)))
        refreshButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = refreshButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    private func updateData() {
        if updatingData { return }
        tableView.isHidden = true
        updatingData = true
        notificationLabel.text = "Loading images..."
        refreshButton.isEnabled = false
        viewModel.updateData { [weak self] (result) in
            switch result {
            case .success(let urls):
                urls.forEach() { print ($0.image.absoluteString) }
                self?.tableView.isHidden = false
            case .failure(_):
                self?.notificationLabel.text = "Failed to load images"
            }
            self?.refreshButton.isEnabled = true
            self?.updatingData = false
        }
    }
    
    @objc func refreshButtonPressed(sender: UIBarButtonItem) {
        updateData()
    }
    
    @IBAction func NumberOfItemsStepperPressed(_ sender: UIStepper, forEvent event: UIEvent) {
    }
}
