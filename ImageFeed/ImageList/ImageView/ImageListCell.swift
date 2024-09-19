//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 10.07.2024.
//


import UIKit
import Kingfisher


final class ImageListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Static variables
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IB Outlets
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    // MARK: - Private variables
    private let likeOn: UIImage? = UIImage(named: "like_button_on")
    private let likeOff: UIImage? = UIImage(named: "like_button_off")
    
    private var currentPhoto: Photo?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func configure(photo: Photo) {
        likeButton.accessibilityIdentifier = "likeButton"
        
        guard
            let url = URL(string: photo.thumbImageURL)
        else {
            Log.warn(message: "Can not load image")
            return
        }
        
        currentPhoto = photo
        
        if let createdAt = photo.createdAt {
            dateLabel.text = createdAt.dateString
        } else {
            dateLabel.text = ""
            Log.warn(message: "Photo with id \(photo.id) has empty createdAt field")
        }
        
        dateLabel.addCharacterSpacing(kernValue: -0.08)
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "card_stub"))
        
        let likeButtonImage = photo.isLiked ? likeOn : likeOff
        likeButton.setImage(likeButtonImage, for: UIControl.State.normal)
    }
    
    func update(photo: Photo) {
        guard let currentPhoto else {return}
        
        if currentPhoto.thumbImageURL != photo.thumbImageURL, 
           let url = URL(string: photo.thumbImageURL) {
            cellImage.kf.setImage(with: url, options: [.keepCurrentImageWhileLoading])
        } else {
            Log.warn(message: "Can not load image")
            return
        }
    
        if let createdAt = photo.createdAt {
            dateLabel.text = createdAt.dateString
        } else {
            dateLabel.text = ""
            Log.warn(message: "Photo with id \(photo.id) has empty createdAt field")
        }
        
        dateLabel.addCharacterSpacing(kernValue: -0.08)
        
        let likeButtonImage = photo.isLiked ? likeOn : likeOff
        
        likeButton.setImage(likeButtonImage, for: UIControl.State.normal)
    }
    
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
}
