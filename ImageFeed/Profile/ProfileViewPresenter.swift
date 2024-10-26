//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/23/24.
//

import Foundation

class ProfileViewPresenter: ProfileViewPresenterProtocol {    
    
    weak var controller: ProfileViewControllerProtocol?
    
    private let profileService: ProfileServiceProtocol
    
    private let profileImageService: ProfileImageServiceProtocol
    
    private let tokenStorage: OAuthTokenStorageProtocol
    
    private let profileLogoutService: ProfileLogoutServiceProtocol
    
    init(profileService: ProfileServiceProtocol = ProfileService.shared,
         profileImageService: ProfileImageServiceProtocol = ProfileImageService.shared,
         tokenStorage: OAuthTokenStorageProtocol = OAuthTokenStorage.shared,
         profileLogoutService: ProfileLogoutServiceProtocol = ProfileLogoutService.shared) {

        self.profileService = profileService
        self.profileImageService = profileImageService
        self.tokenStorage = tokenStorage
        self.profileLogoutService = profileLogoutService
        print("presenter was initialised!")
    }
    
    func viewDidLoad() {
        
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
    
    func getAvatarUrl() -> URL? {
        return nil
    }
    
    func updateProfile() {
        guard let profile = profileService.profile else { return }
        controller?.updateProfileDetails(profile: profile)
    }
    
    func logout() {
        profileLogoutService.logoutToSplashScreen()
    }
}
