//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 10.07.2024.
//


import UIKit


final class ImagesListCell: UITableViewCell {
    // MARK: - Static variables
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IB Outlets
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - Private variables
    private let activeImage: UIImage? = UIImage(named: "LikeOn")
    private let noActiveImage: UIImage? = UIImage(named: "LikeOff")
        
    
    func configure(image: UIImage, date: Date, isLikeOn: Bool) {
        dateLabel.text = date.dateString
        cellImage.image = image
        let likeButtonImage = isLikeOn ? activeImage : noActiveImage
        
        likeButton.setImage(likeButtonImage, for: UIControl.State.normal)
    }
}
