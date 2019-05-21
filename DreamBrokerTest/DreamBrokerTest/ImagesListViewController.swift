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
    
    private func animateTableViewCells() {
        guard let visibleIndexPathes = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPathes {
            guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { continue }
            let rect = tableView.rectForRow(at: indexPath)
            let rect2 = tableView.convert(rect, to: tableView.superview)
            let relativePosition = (((tableView.bounds.height / 2) - rect2.midY - 64) / (tableView.bounds.height / 2))
            if indexPath.row == 1 {
                print (relativePosition)
            }
            let angle = relativePosition * (10 * .pi / 180.0)  //convert degrees to radians
            cell.animationView.transform = CGAffineTransform.identity.rotated(by: angle)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.displayedImages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ImagesListCell.identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let cell = cell as? ImagesListCell,
            let displayedImage = viewModel.displayedImages?[indexPath.row] else { return }
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
        animateTableViewCells()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateTableViewCells()
    }
}
