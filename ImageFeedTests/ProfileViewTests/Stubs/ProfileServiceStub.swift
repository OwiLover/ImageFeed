//
//  ProfileServiceStub.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/27/24.
//
@testable import ImageFeed
import Foundation

class ProfileServiceStub: ProfileServiceProtocol {
    
    var profile: Profile? = Profile(profileResult: ProfileResult(
        username: "Test",
        firstName: "User",
        lastName: nil,
        email: "example@mail.com",
        portfolioUrl: nil,
        location: nil,
        bio: nil
    ))
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ImageFeed.Profile, any Error>) -> Void) { }
    
    func resetProfile() { }
}
