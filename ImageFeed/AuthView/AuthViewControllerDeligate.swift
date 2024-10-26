//
//  AuthViewControllerDeligate.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/12/24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
} 
