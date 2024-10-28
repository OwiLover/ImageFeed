//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/23/24.
//

@testable import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var webView: WebViewViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) { }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
