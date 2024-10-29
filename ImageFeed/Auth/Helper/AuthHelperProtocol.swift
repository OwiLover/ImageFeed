//
//  AuthHelperProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/21/24.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}
