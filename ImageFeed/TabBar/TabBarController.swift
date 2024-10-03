//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/30/24.
//

import UIKit
 
final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
            
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImageListViewController"
        )
            
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(named: "ProfileIconActive"),
            selectedImage: nil
        )
           
       self.viewControllers = [imagesListViewController, profileViewController]
    }
}
