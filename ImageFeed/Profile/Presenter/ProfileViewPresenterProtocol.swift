//
//  ProfileViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/23/24.
//

import Foundation

protocol ProfileViewPresenterProtocol: AnyObject {
    var controller: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    
    func updateAvatar()
    func updateProfile()
    
    func logout()
}
