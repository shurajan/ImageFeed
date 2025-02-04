//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 04.07.2024.
//

import UIKit

public protocol ImageListViewControllerProtocol: AnyObject {
    func configure(_ presenter: ImageListPresenterProtocol)
    func updateTableViewAnimated(oldNumberOfRows: Int, newNumberOfRows: Int)
}

final class ImageListViewController: LightStatusBarViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var presenter: ImageListPresenterProtocol?
    
    // MARK: - IB Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccessibilityIdentifiers()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
        
        UIBlockingProgressHUD.show()
        presenter?.loadPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showSingleImageSegueIdentifier,
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath,
            let presenter,
            let photo = presenter.photos[safe: indexPath.row]
        else {
            super.prepare(for: segue, sender: sender)
            return
        }
        viewController.photo = photo
    }
    
    // MARK: - Public Functions
    func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        guard let presenter,
              let photo = presenter.photos[safe: indexPath.row]
        else {return}
        cell.configure(photo: photo)
    }
    
    // MARK: - Private Functions
    private func setAccessibilityIdentifiers() {
        tableView.accessibilityIdentifier = "imageListTable"
    }
}

// MARK: - UITableViewDelegate Implementation
extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter,
              let photo = presenter.photos[safe: indexPath.row]
        else {return 0}
        
        let imageViewWidth = tableView.bounds.width - 32
        let imageWidth =  photo.size.width
        let factor = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * factor + 8
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else {return}
        
        if indexPath.row == presenter.photos.count - 1 {
            UIBlockingProgressHUD.show()
            presenter.loadPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource Implementation
extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else {return 0}
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier)
        
        guard let imageListCell = cell as? ImageListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
}

// MARK: - ImagesListCellDelegate Implementation
extension ImageListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImageListCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let presenter
        else { return }
        
        UIBlockingProgressHUD.show()
        presenter.didTapLike(index: indexPath.row){result in
            switch result {
            case .success(let photo):
                cell.update(photo: photo)
            case .failure(let error):
                Log.error(error: error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

// MARK: - ImagesListViewControllerProtocol Implementation
extension ImageListViewController: ImageListViewControllerProtocol {
    
    func configure(_ presenter: any ImageListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateTableViewAnimated(oldNumberOfRows: Int, newNumberOfRows: Int) {
        if newNumberOfRows > oldNumberOfRows {
            var indexPathArray: [IndexPath] = []
            
            for i in oldNumberOfRows..<newNumberOfRows {
                indexPathArray.append(IndexPath(row: i, section: 0))
            }
            
            tableView.performBatchUpdates {
                self.tableView.insertRows(at: indexPathArray, with: .automatic)
            } completion: { _ in
            }
        }
        UIBlockingProgressHUD.dismiss()
    }
}
