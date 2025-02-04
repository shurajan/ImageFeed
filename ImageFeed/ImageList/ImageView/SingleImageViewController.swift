//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 17.07.2024.
//

import UIKit

final class SingleImageViewController: LightStatusBarViewController {
    var photo: Photo? {
        didSet {
            guard isViewLoaded, let photo else { return }
            loadPhoto(photo: photo)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var backButton: UIButton!
    
    // MARK: - Private Variables
    private var alertPresenter: AlertPresenter?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccessibilityIdentifiers()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
        
        setStubPicture()
        
        if let photo  {
            loadPhoto(photo: photo)
        }
    }
    
    // MARK: - Private functions
    private func setAccessibilityIdentifiers() {
        backButton.accessibilityIdentifier = "backButton"
    }
    
    private func loadPhoto(photo: Photo){
        guard let photoURL = URL(string: photo.largeImageURL)
        else {return}
        
        UIBlockingProgressHUD.show()
        
        imageView.kf.setImage(with: photoURL, options: [.keepCurrentImageWhileLoading]) {[weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else {return}
            switch result {
            case .success(let imageResult):
                let image = imageResult.image
                imageView.frame.size = image.size
                rescaleAndCenterImageInScrollView(image: image)
            case .failure(let error):
                Log.error(error: error, message: "Failed to load image")
                setStubPicture()
                showError()
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
    
    private func setStubPicture(){
        if let stubImage = UIImage(named: "pic_stub") {
            imageView.image = stubImage
            imageView.frame.size = stubImage.size
            rescaleAndCenterImageInScrollView(image: stubImage)
        }
    }
    
    private func showError(){
        let buttonRepeat = AlertButton(buttonText: "Повторить", style: .default) { [weak self] in
            Log.info(message: "Trying to re-load full image")
            guard let self, let photo = self.photo else {return}
            
            self.loadPhoto(photo: photo)
        }
        let buttonDecline = AlertButton(buttonText: "Не надо", style: .cancel) {[weak self] in
            Log.info(message: "Canceling full picture re-loading")
            guard let self else {return}
            self.dismiss(animated: true, completion: nil)
        }
        
        let alertModel = AlertModel(id: "AuthErrorAlert",
                                    title: "Что-то пошло не так(",
                                    message: "Попробовать ещё раз?",
                                    buttons: [buttonRepeat, buttonDecline])
        
        self.alertPresenter?.showAlert(alertModel)
        
    }
    
    // MARK: - Actions
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        guard let image = imageView.image else {return}
        
        let items = [image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
}

// MARK: - UIScrollViewDelegate Implementation
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView){
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

