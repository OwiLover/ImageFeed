//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/12/24.
//

import UIKit

final class SplashViewController: UIViewController {
    private let storage = OAuthTokenStorage.shared
    
    private let authSegueIdentifier = "AuthenticationScreenSegueIdentifier"
    
    private let profileService = ProfileService.shared
    
    private let profileImageService = ProfileImageService.shared
    
    deinit {
        print("SplashView was deleted!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        }
        else {
            performSegue(withIdentifier: authSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            print("Invalid window configuration")
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
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else {
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
                        print(error)
                    }
                }
                self.switchToTabBarController()

            case .failure(let error):
                print("Something went wrong: ", error)
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                print("Failed to prepare for \(authSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
