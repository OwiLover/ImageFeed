//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/23/24.
//

import Foundation

final class ProfileViewPresenter: ProfileViewPresenterProtocol {    
    
    weak var controller: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    
    private let profileImageService: ProfileImageServiceProtocol
    
    private let profileLogoutService: ProfileLogoutServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared) {

        self.profileService = profileService
        self.profileImageService = profileImageService
        self.profileLogoutService = profileLogoutService
        print("presenter was initialised!")
    }
    
    func viewDidLoad() {
        updateProfile()
        updateAvatar()
    }
    
    func updateAvatar() {
        guard
            let imageURLString = profileImageService.avatarURLString,
            let url = URL(string: imageURLString)
        else {
            return
        }
        controller?.setAvatarImage(url: url)
        print("The picture is loaded, link: ", imageURLString)
    }
    
    func updateProfile() {
        guard let profile = profileService.profile else { return }
        controller?.updateProfileDetails(profile: profile)
    }
    
    func logout() {
        profileLogoutService.logoutToSplashScreen()
    }
}
