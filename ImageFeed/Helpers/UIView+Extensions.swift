//
//  UIView+Extensions.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 04.09.2024.
//

import UIKit

extension UIView {
    private static let loadingGradientName = "loadingGradient"
    
    private var loadingGradient: CAGradientLayer? {
        layer.sublayers?.firstIndex(where: {$0.name == UIView.loadingGradientName}) as? CAGradientLayer
    }
    
    func addLoadingGradients(){
        let gradient = CAGradientLayer()
        gradient.name = UIView.loadingGradientName
        
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: frame.width, height: frame.height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = layer.cornerRadius
        gradient.masksToBounds = true
        layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
        
    }
    
    func removeLoadingGradient() {
        loadingGradient?.removeFromSuperlayer()
    }
    
}
