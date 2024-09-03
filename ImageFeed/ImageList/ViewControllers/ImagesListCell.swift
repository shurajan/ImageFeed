//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 10.07.2024.
//


import UIKit
import Kingfisher


final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate? 
    
    // MARK: - Static variables
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IB Outlets
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Private variables
    private let likeOn: UIImage? = UIImage(named: "like_button_on")
    private let likeOff: UIImage? = UIImage(named: "like_button_off")
        
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    func configure(photo: Photo) {
        guard
            let url = URL(string: photo.thumbImageURL)
        else {
            Log.warn(message: "Can not load image")
            return
        }
        
        dateLabel.text = photo.createdAt?.dateString ?? Date().dateString
        dateLabel.addCharacterSpacing(kernValue: -0.08)
        
        cellImage.kf.setImage(with: url, placeholder: UIImage(named: "card_stub"))
        
        let likeButtonImage = photo.isLiked ? likeOn : likeOff
        
        likeButton.setImage(likeButtonImage, for: UIControl.State.normal)
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
}
