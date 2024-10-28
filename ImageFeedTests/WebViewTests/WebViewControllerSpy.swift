//
//  WebViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Owi Lover on 10/23/24.
//
@testable import ImageFeed
import Foundation

class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: WebViewPresenterProtocol?
    
    var didLoadCalled: Bool = false
    
    func load(request: URLRequest) {
        didLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) { }
    
    func setProgressHidden(_ isHidden: Bool) { }
}
