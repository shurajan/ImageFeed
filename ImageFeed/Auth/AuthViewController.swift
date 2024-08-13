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
    
    //MARK: - Private Varibales
    private var alertPresenter: AlertPresenter?
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
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
    
    //MARK: - Private Functions
    func showAuthError() {
        let alertModel = AlertModel(id: "AuthErrorAlert",
                                    title: "Что-то пошло не так(",
                                    message: "Не удалось войти в систему",
                                    buttonText: "OK") {
            print("OK")
        }
                                    
        self.alertPresenter?.showAlert(alertModel)
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
                showAuthError()
                OAuth2TokenStorage.shared.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                showAuthError()
                print("Can not receive token for code : \(error.localizedDescription)")
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
    
}
