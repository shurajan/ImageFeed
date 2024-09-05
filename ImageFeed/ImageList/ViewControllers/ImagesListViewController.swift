//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 04.07.2024.
//

import UIKit

final class ImagesListViewController: LightStatusBarViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private let imagesListService = ImagesListService.shared
    
    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private variables
    private var photos: [Photo] = []
    
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        UIBlockingProgressHUD.show()
        imagesListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showSingleImageSegueIdentifier,
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            super.prepare(for: segue, sender: sender)
            return
        }
        viewController.photo = photos[indexPath.row]
        
    }
    
    // MARK: - Private Functions
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.configure(photo: photos[indexPath.row])
    }
    
    func updateTableViewAnimated(){
        let oldNumberOfRows = photos.count
        let newNumberOfRows = imagesListService.photos.count
        
        if oldNumberOfRows == newNumberOfRows {
            return
        }
        
        self.photos = imagesListService.photos
        var indexPathArray: [IndexPath] = []
        
        for i in oldNumberOfRows..<newNumberOfRows {
            indexPathArray.append(IndexPath(row: i, section: 0))
        }
        
        tableView.performBatchUpdates {
            self.tableView.insertRows(at: indexPathArray, with: .automatic)
        } completion: { _ in }
        
    }
}

// MARK: - UITableViewDelegate Implementation
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageViewWidth = tableView.bounds.width - 32
        let imageWidth =  photos[indexPath.row].size.width
        let factor = imageViewWidth / imageWidth
        let cellHeight = photos[indexPath.row].size.height * factor + 8
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            UIBlockingProgressHUD.show()
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - UITableViewDataSource Implementation
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(_):
                self.photos = self.imagesListService.photos
                cell.update(photo: photos[indexPath.row])
            case .failure(let error):
                Log.error(error: error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
