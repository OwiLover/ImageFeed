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
    case codeItemError
}

final class WebViewController: UIViewController {
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    weak var delegate: WebViewControllerDelegate?
    
    private var progressView: UIProgressView?
    
    private var webView: WKWebView?
    
    deinit {
        print("WebView was deleted!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = createWebView()
        
        webView?.navigationDelegate = self
        
        progressView = createProgressView()
        
        loadAuthView(webView: webView)
        
        createNewBackButton()
    }
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        webView?.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: .none)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        webView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: .none)
    }

    private func updateProgress() {
        guard let webView, let progressView else { return }
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    private func createWebView() -> WKWebView {
        let webView = WKWebView()
        
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
    
    private func loadAuthView(webView: WKWebView?) {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString), let webView else {
            print(WebViewErrors.urlComponentsError)
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print(WebViewErrors.badUrlError)
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
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
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            print(WebViewErrors.codeItemError)
            return nil
        }
    }
}
