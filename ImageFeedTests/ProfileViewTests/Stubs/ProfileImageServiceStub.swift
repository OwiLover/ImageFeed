//
//  ProfileImageServiceStub.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/27/24.
//
@testable import ImageFeed
import Foundation

class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURLString: String? = "SomeStringUrl"
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, any Error>) -> Void) {
        
    }
    
    func resetProfileImage() {
        
    }
    
    
}
