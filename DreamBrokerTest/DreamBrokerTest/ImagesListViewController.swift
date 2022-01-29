import Kingfisher
import UIKit

class ImagesListViewController: UIViewController {
    var viewModel = ImagesListViewModel()
    var updatingData = false
    var refreshButton: UIBarButtonItem!
    var numberOfItems = defaultNumberOfItems

    @IBOutlet var notificationLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var numberOfItemsLabel: UILabel!
    @IBOutlet var numberOfItemsStepper: UIStepper!

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                        target: self,
                                        action: #selector(refreshButtonPressed(sender:)))
        refreshButton.tintColor = .white
        navigationItem.rightBarButtonItem = refreshButton
        tableView.estimatedRowHeight = 292
        tableView.rowHeight = UITableView.automaticDimension

        numberOfItemsLabel.text = "\(numberOfItems) items"
        numberOfItemsStepper.value = Double(numberOfItems)
        numberOfItemsStepper.maximumValue = 15
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
        Task {
            do {
                let imageViewModels = try await viewModel.updateData()
                imageViewModels.forEach { print($0.url.absoluteString) }
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.animateTableViewCells()
            } catch {
                self.notificationLabel.text = "Failed to load images"
            }
            self.refreshButton.isEnabled = true
            self.updatingData = false
        }
    }

    @objc func refreshButtonPressed(sender _: UIBarButtonItem) {
        updateData()
    }

    @IBAction func NumberOfItemsStepperPressed(_ sender: UIStepper, forEvent _: UIEvent) {
        numberOfItems = Int(sender.value)
        numberOfItemsLabel.text = "\(numberOfItems) items"
    }

    private func animateTableViewCells() {
        guard let visibleIndexPathes = tableView.indexPathsForVisibleRows else { return }

        for indexPath in visibleIndexPathes {
            guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { continue }
            let rect = tableView.rectForRow(at: indexPath)
            let rect2 = tableView.convert(rect, to: tableView.superview)
            let relativePosition = (((tableView.bounds.height / 2) - rect2.midY - 64) / (tableView.bounds.height / 2))
            if indexPath.row == 1 {
                print(relativePosition)
            }
            let angle = relativePosition * (5 * .pi / 180.0) // convert degrees to radians
            cell.animationView.transform = CGAffineTransform.identity.rotated(by: angle)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.displayedImages?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: ImagesListCell.identifier, for: indexPath)
    }

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let cell = cell as? ImagesListCell,
            let displayedImage = viewModel.displayedImages?[indexPath.row] else { return }
        cell.displayedImage.kf.indicatorType = .activity
        cell.displayedImage.contentMode = .scaleAspectFill
        let processor = DownsamplingImageProcessor(size: cell.displayedImage.frame.size)
        cell.displayedImage.kf.setImage(
            with: displayedImage.url,
            placeholder: UIImage(named: "placeholder"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
            ]
        )
        cell.imageTextLabel.text = displayedImage.text
    }

    func scrollViewDidScroll(_: UIScrollView) {
        animateTableViewCells()
    }
}
