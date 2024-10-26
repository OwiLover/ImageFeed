//
//  ProfileViewControllerProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/23/24.
//

import Foundation

protocol ProfileViewControllerProtocol: AnyObject {
    func setPresenter(presenter: ProfileViewPresenterProtocol)
    
    func updateProfileDetails(profile: Profile)
    func setAvatarImage(url: URL)
}
