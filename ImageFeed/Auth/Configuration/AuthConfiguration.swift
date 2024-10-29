//
//  Constants.swift
//  ImageFeed
//
//  Created by Owi Lover on 8/29/24.
//

import Foundation

enum AuthConfigurationErrors: Error {
    case badApiURL
    case badBaseURL
    case badStandardConfiguration
}

enum Constants {
    static let accessKey = "3BI6Ic1XcIe5hpXXBGQ7TQSqgXkHVqtXz291A699XK8"
    static let secretKey = "p81EkFDw5d0o01GNH_wcIma8NxPLpC0f6o6qFVVKtS4"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultApiURLString = "https://api.unsplash.com/"
    static let defaultApiURL = {
        URL(string: defaultApiURLString)
    }()

    static let defaultBaseURLString = "https://unsplash.com"
    static let defaultBaseURL =  {
        URL(string: defaultBaseURLString)
    }()
    
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

struct AuthConfiguration {
    static var standard: AuthConfiguration? {
        do {
            let standard = try AuthConfiguration(accessKey: Constants.accessKey,
                                                 secretKey: Constants.secretKey,
                                                 redirectURI: Constants.redirectURI,
                                                 accessScope: Constants.accessScope,
                                                 authURLString: Constants.unsplashAuthorizeURLString,
                                                 apiURLString: Constants.defaultApiURLString,
                                                 baseURLString: Constants.defaultBaseURLString)
            return standard
        }
        catch {
            print(AuthConfigurationErrors.badStandardConfiguration)
            return nil
        }
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    
    let apiURLString: String
    let apiURL: URL
    
    let baseURLString: String
    let baseURL: URL
    
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, apiURLString: String, baseURLString: String) throws {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        
        self.apiURLString = apiURLString
        self.apiURL = try {
            guard let url = URL(string: apiURLString) else { throw AuthConfigurationErrors.badApiURL }
            return url
        }()
        
        self.baseURLString = baseURLString
        self.baseURL = try {
            guard let url = URL(string: apiURLString) else { throw AuthConfigurationErrors.badBaseURL }
            return url
        }()
        
        self.authURLString = authURLString
    }
}
