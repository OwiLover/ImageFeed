//
//  WebViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/3/24.
//

import UIKit

protocol WebViewControllerDelegate: AnyObject {
    func webViewController(_ vc: WebViewController, didAuthenticateWithCode code: String)
    func webViewControllerDidCancel(_ vc: WebViewController)
}
