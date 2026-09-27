//
//  AppWebViewController.swift
//  AppUIKit
//
//  Read-only in-app page for legal documents (Terms, Privacy Policy). Shown from
//  Settings and from the sign-in terms checkbox.
//

import UIKit
import WebKit
import AppLocalization

/// Public legal documents. Keep in sync with Android `LegalLinks.kt`.
public enum LegalLinks {
    public static let termsURL = URL(
        string: "https://sites.google.com/view/myunify-app-terms-conditions/home"
    )!
    public static let privacyURL = URL(
        string: "https://sites.google.com/view/myunify-app-privacy-policy/home"
    )!
}

public final class AppWebViewController: UIViewController {

    /// Google Docs' reader view ships its own title bar and an "open in the Docs
    /// app" banner; this hides them. A no-op on the Google Sites pages in use now,
    /// kept so a Docs link still renders cleanly.
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

    public init(url: URL, title: String) {
        self.url = url
        self.pageTitle = title
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
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

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - WKNavigationDelegate

extension AppWebViewController: WKNavigationDelegate {

    public func webView(
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

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showLoadError()
    }

    public func webView(
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
            subtitle: "web_load_error".localized,
            style: .error
        )
    }
}
