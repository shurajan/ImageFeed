//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Alexander Bralnin on 25.07.2024.
//

import UIKit

//MARK: - Protocols
protocol WebViewViewControllerDelegate: AnyObject  {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

//MARK: - AuthViewController
final class AuthViewController: LightStatusBarViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
        
    weak var delegate: AuthViewControllerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var buttonAuthenticate: UIButton!
    
    // MARK: - Private variables
    private var alertPresenter: AlertPresenter?
    private var oAuth2Service: OAuth2ServiceProtocol = OAuth2Service.shared
    
    // MARK: - View Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccessibilityIdentifiers()
        
        let alertPresenter = AlertPresenter()
        alertPresenter.delegate = self
        self.alertPresenter = alertPresenter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == ShowWebViewSegueIdentifier,
            let webViewViewController = segue.destination as? WebViewViewController
        else {
            super.prepare(for: segue, sender: sender)
            return
        }
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.delegate = self
        webViewViewController.configure(webViewPresenter)
    }
        
    // MARK: - private functions
    private func setAccessibilityIdentifiers() {
        buttonAuthenticate.accessibilityIdentifier = "authenticateButton"
    }
    
    private func showAuthErrorAlert() {
        let button = AlertButton(buttonText: "OK", style: .default) {}
        
        let alertModel = AlertModel(id: "AuthErrorAlert",
                                    title: "Что-то пошло не так(",
                                    message: "Не удалось войти в систему",
                                    buttons: [button])
        
        self.alertPresenter?.showAlert(alertModel)
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        oAuth2Service.fetchOAuthToken(for: code) {[weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                Log.error(error: error, message: "Can not receive token for code")
                self.showAuthErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
