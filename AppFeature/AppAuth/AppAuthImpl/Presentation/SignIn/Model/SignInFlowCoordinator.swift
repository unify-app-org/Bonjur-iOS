//
//  SignInFlowCoordinator.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 09.05.26.
//

import UIKit
import AppUIKit

final class SignInFlowCoordinator {
    
    private let msalCommunityIds: Set<Int> = [1]
    private var inputData: SignInInputData? = nil
    private let msalManager = MicrosoftAuthManager()
    private weak var presentingViewController: UIViewController?
    private let useCase: AuthUsecases = resolve()
    private var authDelegate: AuthDelegate = resolve()
    /// Covers the gap between tapping sign-in and MSAL's web sheet actually appearing.
    private var authUIWaitTask: Task<Void, Never>?

    @MainActor
    func start(from viewController: UIViewController, with inputData: SignInInputData) {
        presentingViewController = viewController
        self.inputData = inputData
        if msalCommunityIds.contains(inputData.communityId) {
            startMSALFlow()
        } else {
            startCredentialsFlow(inputData: inputData)
        }
    }
    
    @MainActor
    private func startCredentialsFlow(inputData: SignInInputData) {
        let vc = SignInBuilder(inputData: inputData).build()
        presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @MainActor
    private func startMSALFlow() {
        guard let vc = presentingViewController else { return }
        showLoadingUntilAuthPresented()
        msalManager.buildMsalWeb(vc: vc) { [weak self] result in
            Task { @MainActor in
                self?.handleMSALResult(result)
            }
        }
    }

    /// MSAL exposes no "web presented" callback, so poll for the auth sheet and drop the
    /// overlay once it's up (web has its own UI). Safety: ~10s timeout; completion also clears it.
    @MainActor
    private func showLoadingUntilAuthPresented() {
        AppLoadingUI.show()
        authUIWaitTask?.cancel()
        authUIWaitTask = Task { @MainActor in
            let start = Date()
            while !Task.isCancelled {
                if isAuthUIPresented() || Date().timeIntervalSince(start) > 10 {
                    AppLoadingUI.dismiss()
                    return
                }
                try? await Task.sleep(nanoseconds: 100_000_000)
            }
        }
    }

    @MainActor
    private func isAuthUIPresented() -> Bool {
        if presentingViewController?.presentedViewController != nil { return true }
        return presentingViewController?.view.window?.rootViewController?.presentedViewController != nil
    }

    @MainActor
    private func handleMSALResult(_ result: MSALSignInResult) {
        // Web flow is over (or never opened) — drop the open-delay overlay.
        authUIWaitTask?.cancel()
        AppLoadingUI.dismiss()

        if result.isCancelled { return } // user dismissed the sheet — not an error

        guard result.error == nil else {
            errorAlert(title: "Microsoft Sign In Failed")
            return
        }
        guard let email = result.email,
                let communityId = inputData?.communityId else {
            errorAlert(title: "Microsoft Sign In Failed")
            return
        }
        Task {
            await login(
                email,
                communityId
            )
        }
    }
    
    private func login(
        _ email: String,
        _ communityId: Int
    ) async {
        AppLoadingUI.show()
        defer {
            AppLoadingUI.dismiss()
        }
        do {
            let isFirstLogin = try await useCase.login(
                communityId: communityId,
                email: email,
                password: nil
            )
            await handleLogin( isFirstLogin)
        } catch {
            await errorAlert(title: error.localizedDescription)
        }
    }
    
    @MainActor
    private func handleLogin(
        _ isFirstLogin: Bool
    ) {
        if isFirstLogin {
            routeToWelcome()
        } else {
            authDelegate.finishAuthentication()
        }
    }
    
    @MainActor
    private func routeToWelcome() {
        let vc = AuthWelcomeBuilder(
            inputData: .init()
        ).build()
        vc.modalPresentationStyle = .fullScreen
        presentingViewController?.present(vc, animated: true)
    }
    
    @MainActor
    private func errorAlert(title: String) {
        let alert = AppAlert(
            config: .init(title: title),
            actions: {
                AppAlert.Action(
                    title: "Okay",
                    style: .primary
                )
            }
        )
        AppAlertPresenter.present(alert)
    }
}
