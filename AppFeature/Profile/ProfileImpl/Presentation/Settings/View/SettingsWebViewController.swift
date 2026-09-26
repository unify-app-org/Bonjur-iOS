//
//  SettingsWebViewController.swift
//  ProfileImpl
//
//  Read-only in-app page for Settings documents (Terms and conditions).
//

import UIKit
import WebKit
import AppUIKit
import AppFoundation

final class SettingsWebViewController: UIViewController {

    /// Google's reader view ships its own title bar (with a back arrow that
    /// goes nowhere inside the app) and an "open in the Docs app" banner.
    /// Our navigation bar already covers both, so they are hidden.
    private static let hideGoogleChromeScript = """
    var style = document.createElement('style');
    style.textContent = '#docs-ml-header-id, .docs-ml-promotion { display: none !important; }';
    document.documentElement.appendChild(style);
    """

    private let url: URL
    private let pageTitle: String

    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(
            WKUserScript(
                source: Self.hideGoogleChromeScript,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    init(url: URL, title: String) {
        self.url = url
        self.pageTitle = title
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = pageTitle
        view.backgroundColor = .white

        view.addSubview(webView)
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        spinner.startAnimating()
        webView.load(URLRequest(url: url))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - WKNavigationDelegate

extension SettingsWebViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Links the user taps inside the document open in the system browser /
        // mail app instead of replacing the page they were reading.
        guard navigationAction.navigationType == .linkActivated,
              let target = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        UIApplication.shared.open(target)
        decisionHandler(.cancel)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoadError()
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        showLoadError()
    }

    private func showLoadError() {
        spinner.stopAnimating()
        AppSnackBar.show(
            title: "error_generic_title".localized,
            subtitle: "settings_web_load_error".localized,
            style: .error
        )
    }
}
