//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Owi Lover on 10/20/24.
//

import Foundation
import UIKit

final class WebViewPresenter: WebViewPresenterProtocol {

    weak var webView: WebViewViewControllerProtocol?
    
    private var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let webView, let request = authHelper.authRequest() else { return }

        didUpdateProgressValue(0)
        
        webView.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
            guard let webView else { return }
            let newProgressValue = Float(newValue)
            webView.setProgressValue(newProgressValue)
            
            let shouldHideProgress = self.shouldHideProgress(for: newProgressValue)
            webView.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
