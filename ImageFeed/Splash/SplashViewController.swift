//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/12/24.
//

import UIKit

class SplashViewController: UIViewController {
    private let storage = OAuthTokenStorage.shared
    
    private let authSegueIdentifier = "AuthenticationScreenSegueIdentifier"
    
    private let imageListSegueIdentifier = "ImageListScreenSegueIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token != nil {
            switchToTabBarController()
//            performSegue(withIdentifier: imageListSegueIdentifier, sender: nil)
        }
        else {
            performSegue(withIdentifier: authSegueIdentifier, sender: nil)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
 
        window.rootViewController = tabBarController
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    
    /*
     Вопрос: Можно ли использовать в качестве перехода на ImageListViewController использовать segue, протестировав пришёл к выводу, что функциональность и внешний вид не меняются
     */
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
//        performSegue(withIdentifier: imageListSegueIdentifier, sender: nil)
        switchToTabBarController()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == authSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(authSegueIdentifier)")
                return
            }
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
