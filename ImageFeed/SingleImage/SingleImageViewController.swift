//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 17.07.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

