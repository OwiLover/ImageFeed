//
//  WebViewController.swift
//  ImageFeed
//
//  Created by Owi Lover on 9/3/24.
//

import UIKit
import WebKit

enum WebViewErrors: Error {
    case urlComponentsError
    case badUrlError
    case codeItemIsNil
}

enum WebViewControllerIdentifiers: String {
    case webView = "UnsplashWebView"
}

final class WebViewController: UIViewController, WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    
    weak var delegate: WebViewControllerDelegate?
    
    private var progressView: UIProgressView?
    
    private var webView: WKWebView?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    deinit {
        print("WebView was deleted!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = createWebView()
        
        webView?.navigationDelegate = self
        
        estimatedProgressObservation = webView?.observe(\.estimatedProgress, options: .new, changeHandler: { [weak self] _, _ in
            guard let self, let webView, let presenter else { return }
            presenter.didUpdateProgressValue(webView.estimatedProgress)
        })
        
        progressView = createProgressView()
        
        createNewBackButton()
        
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        webView?.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        guard let progressView else { return }
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        guard let progressView else { return }
        progressView.isHidden = isHidden
    }
    
    private func createWebView() -> WKWebView {
        let webView = WKWebView()
        
        webView.accessibilityIdentifier = WebViewControllerIdentifiers.webView.rawValue
        
        view.addSubview(webView)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        return webView
    }
    
    private func createProgressView() -> UIProgressView {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlack
        progressView.trackTintColor = .ypBackground
        
        view.addSubview(progressView)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        return progressView
    }
    
    private func createNewBackButton() {
        let iconName = "BackwardDark"

        navigationItem.hidesBackButton = true

        let backButton = UIBarButtonItem(title: .none, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.image = UIImage(named: iconName)
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.leftBarButtonItem?.tintColor = .ypBlack
    }
    
    @objc
    private func didTapBackButton() {
        delegate?.webViewControllerDidCancel(self)
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}

