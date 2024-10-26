//
//  WebViewPresenterProtocol.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/20/24.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var webView: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func code(from url: URL) -> String?
    func didUpdateProgressValue(_ newValue: Double)
}
