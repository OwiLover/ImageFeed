//
//  ProfileViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/26/24.
//

@testable import ImageFeed
import Foundation

class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    
    var controller: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
    }
    
    func updateProfile() {
    }
    
    func logout() {
    }
}
