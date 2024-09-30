//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/12/24.
//

import UIKit

enum SplashViewErrors: Error {
    case badTransition
    case invalidWindowConfiguration
    case tokenIsNil
    case selfIsNil
    case profileImageFetchError(Error)
    case profileFetchError(Error)
}

final class SplashViewController: UIViewController {
    private let storage = OAuthTokenStorage.shared
    
    private let navigationControllerIdentifier = "NavigationController"
    
    private let profileService = ProfileService.shared
    
    private let profileImageService = ProfileImageService.shared
    
    deinit {
        print("SplashView was deleted!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplashView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        }
        else {
            let storyBoard = UIStoryboard(name: "Main", bundle: .main)
            guard let navigationController = storyBoard.instantiateViewController(withIdentifier: navigationControllerIdentifier) as? UINavigationController,
            let authViewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                print(SplashViewErrors.badTransition)
                return
            }
            authViewController.delegate = self
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .crossDissolve
            present(navigationController, animated: true)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print(SplashViewErrors.invalidWindowConfiguration)
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
 
        window.rootViewController = tabBarController
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token else {
            print(SplashViewErrors.tokenIsNil)
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else {
                print(SplashViewErrors.selfIsNil)
                return
            }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                print(profile.username)
                self.profileImageService.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case.success(let result):
                        print("We did it! ", result)
                    case.failure(let error):
                        print(SplashViewErrors.profileImageFetchError(error))
                    }
                }
                self.switchToTabBarController()

            case .failure(let error):
                print(SplashViewErrors.profileFetchError(error))
                break
            }
        }
    }
    
    private func configureSplashView() {
        view.backgroundColor = .ypBlack
        
        let logoImageView: UIImageView = {
            let image = UIImage(named: "YPLogo")
            let imageView = UIImageView(image: image)
            return imageView
        }()
        
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
