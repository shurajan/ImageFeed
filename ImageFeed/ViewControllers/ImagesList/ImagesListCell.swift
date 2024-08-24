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
    private let likeOn: UIImage? = UIImage(named: "like_button_on")
    private let likeOff: UIImage? = UIImage(named: "like_button_off")
        
    func configure(image: UIImage, date: Date, isLikeOn: Bool) {
        dateLabel.text = date.dateString
        dateLabel.addCharacterSpacing(kernValue: -0.08)
        cellImage.image = image
        let likeButtonImage = isLikeOn ? likeOn : likeOff
        
        likeButton.setImage(likeButtonImage, for: UIControl.State.normal)
    }
}
