//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 13.08.2024.
//

import UIKit

final class AlertPresenter {
    // MARK: - Instance Variables
    weak var delegate: UIViewController?
    
    // MARK: - Public methods
    func showAlert(_ alertData: AlertModel){
        guard let delegate = self.delegate else {
            return
        }
        
        let alert = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = alertData.id
        
        for button in alertData.buttons {
            let action = UIAlertAction(title: button.buttonText, style: button.style) {_ in
                button.completion()
            }
            alert.addAction(action)
        }
    
        delegate.present(alert, animated: true, completion: nil)
    }
}
