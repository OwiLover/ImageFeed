//
//  LoginViewCintroller.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/2/24.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let webViewIdentifier = "ShowWebView"
    
    private let oauthTokenStorage = OAuthTokenStorage.shared
    
    private let oauth2Service = OAuth2Service.shared
    
    deinit {
        print("AuthView was deleted!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        
        createLogo()
        configureBackButton()
        createButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewIdentifier {
            guard let webViewController = segue.destination as? WebViewController else { return }
            webViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func createButton() {
        let button:UIButton = {
            let button = UIButton()
            
            button.setTitle("Войти", for: .normal)
            button.setTitleColor(.ypBlack, for: .normal)
            
            let font = UIFont.systemFont(ofSize: 17, weight: .bold)
            button.titleLabel?.font = font
            
            button.backgroundColor = .ypWhite
            button.layer.cornerRadius = 16
            button.layer.masksToBounds = true
            
            button.addTarget(self, action: #selector(didTabButton), for: .touchUpInside)
            
            return button
        }()
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func createLogo() {
        let logoImage = UIImage(named: "Unsplash")
        
        let logoImageView = UIImageView(image: logoImage)
            
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureBackButton() {
        let iconName = "BackwardDark"
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: iconName)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: iconName)
        
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        navigationItem.backBarButtonItem = backButton
        
        navigationItem.backBarButtonItem?.tintColor = .ypBlack
    }
    
    @objc
    private func didTabButton() {
        performSegue(withIdentifier: webViewIdentifier, sender: nil)
    }
}

extension AuthViewController: WebViewControllerDelegate {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success(let token):
                self.oauthTokenStorage.token = token
                self.delegate?.didAuthenticate(self)
                
            case .failure(let error):
                print("Something went wrong: ", error)
                let alertController = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: { [weak self] _ in
                    self?.dismiss(animated: true)
                }))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func webViewControllerDidCancel(_ vc: WebViewController) {
        vc.dismiss(animated: true)
    }
}
