//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 25.07.2024.
//

import UIKit
import ProgressHUD

//MARK: - Protocols
protocol WebViewViewControllerDelegate: AnyObject  {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

//MARK: - AuthViewController
final class AuthViewController: LightStatusBarViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == ShowWebViewSegueIdentifier,
            let viewController = segue.destination as? WebViewViewController
        else {
            super.prepare(for: segue, sender: sender)
            return
        }
        viewController.delegate = self
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(for: code) {[weak self] result in
            guard let self = self else {return}
                    
            switch result{
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Can not receive token for code : \(error.localizedDescription)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}
