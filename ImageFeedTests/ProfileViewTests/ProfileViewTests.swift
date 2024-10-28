//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/26/24.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testDemo() { }
    
    func testControllerViewDidLoad() {
//        given
        let controller = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        controller.setPresenter(presenter: presenter)
        
//        when
        _ = controller.view
        
//        then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterUpdateProfileCalled() {
//        given
        let controller = ProfileViewControllerSpy()
        let profileServiceStub = ProfileServiceStub()
        
        let presenter = ProfileViewPresenter(profileService: profileServiceStub)
        
        controller.setPresenter(presenter: presenter)
//        when
        presenter.updateProfile()
//        then
        XCTAssertTrue(controller.presenterDidCalledUpdateProfile)
    }
    
    func testPresenterUpdateAvatarCalled() {
//        given
        let controller = ProfileViewControllerSpy()
        let profileImageServiceStub = ProfileImageServiceStub()
        
        let presenter = ProfileViewPresenter(profileImageService: profileImageServiceStub)
        
        controller.setPresenter(presenter: presenter)
//        when
        presenter.updateAvatar()
//        then
        XCTAssertTrue(controller.presenterDidCalledSetAvatarImage)
    }
    
    func testPresenterViewDidLoadCalled() {
//        given
        let controller = ProfileViewControllerSpy()
        let profileImageServiceStub = ProfileImageServiceStub()
        let profileServiceStub = ProfileServiceStub()
        
        let presenter = ProfileViewPresenter(profileService: profileServiceStub, profileImageService: profileImageServiceStub)
        
        controller.setPresenter(presenter: presenter)
//        when
        presenter.viewDidLoad()
//        then
        XCTAssertTrue(controller.presenterDidCalledUpdateProfile)
        XCTAssertTrue(controller.presenterDidCalledSetAvatarImage)
    }
    
    func testPresenterLogoutCalled() {
//        given
        let profileLogoutSpy = ProfileLogoutServiceSpy()
        
        let presenter = ProfileViewPresenter(profileLogoutService: profileLogoutSpy)
//        when
        presenter.logout()
//        then
        XCTAssertTrue(profileLogoutSpy.logoutDidCalled)
    }
}
