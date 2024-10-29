//
//  ProfileLogoutServiceDummy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/27/24.
//
@testable import ImageFeed
import Foundation

class ProfileLogoutServiceSpy: ProfileLogoutServiceProtocol {
    var logoutDidCalled: Bool = false
    
    func logoutToSplashScreen() {
        logoutDidCalled = true
    }
}
