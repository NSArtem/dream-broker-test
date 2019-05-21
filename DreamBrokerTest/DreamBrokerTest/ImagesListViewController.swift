import UIKit
import Kingfisher

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
        tableView.estimatedRowHeight = 292
        tableView.rowHeight = UITableView.automaticDimension
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
                urls.forEach() { print ($0.url.absoluteString) }
                self?.tableView.isHidden = false
                self?.tableView.reloadData()
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

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.identifier, for: indexPath) as? ImagesListCell,
            let displayedImage = viewModel.displayedImages?[indexPath.row] else { fatalError() }
        cell.displayedImage.kf.indicatorType = .activity
        cell.displayedImage.contentMode = .scaleAspectFill
        let processor = DownsamplingImageProcessor(size: cell.displayedImage.frame.size)
        cell.displayedImage.kf.setImage(
            with: displayedImage.url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        )
        cell.imageTextLabel.text = displayedImage.text
        return cell
    }
    
}
