//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/9/24.
//

import Foundation
import WebKit
import Kingfisher

enum ProfileLogoutServiceErrors: Error {
    case invalidWindowConfiguration
}

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let profileService = ProfileService.shared
    
    private let profileImageService = ProfileImageService.shared
    
    private let imageListService = ImageListService.shared
    
    private let imageCache = ImageCache.default
    
    private let tokenStorage = OAuthTokenStorage.shared
    
    private init() { }
    
    func logoutToSplashScreen() {
        DispatchQueue.main.async {
            self.clearEverything()
            self.switchToSplashViewController()
        }
    }
    
    private func clearEverything() {
        cleanCookies()
        clearProfile()
        clearProfileImage()
        clearImageList()
        clearImageCache()
        clearToken()
    }

    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func clearProfile() {
        profileService.resetProfile()
    }
    
    private func clearProfileImage() {
        profileImageService.resetProfileImage()
    }
    
    private func clearImageList() {
        imageListService.resetImageList()
    }
    
    private func clearImageCache() {
        imageCache.clearMemoryCache()
        imageCache.clearDiskCache()
    }
    
    private func clearToken() {
        tokenStorage.deleteToken()
    }
    
    private func switchToSplashViewController() {
        guard let window = UIApplication.shared.windows.first else {
            print(ProfileLogoutServiceErrors.invalidWindowConfiguration)
            return
        }
        let splashViewController = SplashViewController()
 
        window.rootViewController = splashViewController
    }
}
