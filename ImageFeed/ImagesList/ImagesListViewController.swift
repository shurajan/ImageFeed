//
//  ViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 04.07.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private variables
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private let activeImage: UIImage = UIImage(named: "Active") ?? UIImage()
    private let noActiveImage: UIImage = UIImage(named: "No Active") ?? UIImage()
    
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Private Functions
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.dateLabel.text = Date().dateString
        cell.cellImage.image = image
        
        if indexPath.item % 2 == 0 {
            cell.likeButton.setImage(activeImage, for: UIControl.State.normal)
        } else {
            cell.likeButton.setImage(noActiveImage, for: UIControl.State.normal)
        }
    }
    
}


// MARK: - UITableViewDelegate Implementation
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        return image.size.height * ((tableView.bounds.width-32) / image.size.width) + 8
    }
    
}

// MARK: - UITableViewDataSource Implementation
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    
}

