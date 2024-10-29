//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/26/24.
//

@testable import ImageFeed
import Foundation

class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    
    var presenter: ProfileViewPresenterProtocol?
    
    var presenterDidCalledUpdateProfile: Bool = false
    
    var presenterDidCalledSetAvatarImage: Bool = false
    
    func setPresenter(presenter: ProfileViewPresenterProtocol) {
        self.presenter = presenter
        presenter.controller = self
    }
    
    func updateProfileDetails(profile: ImageFeed.Profile) {
        presenterDidCalledUpdateProfile = true
    }
    
    func setAvatarImage(url: URL) {
        presenterDidCalledSetAvatarImage = true
    }
}
