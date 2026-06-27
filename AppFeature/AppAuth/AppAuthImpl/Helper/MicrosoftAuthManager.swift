//
//  MicrosoftAuthManager.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 09.05.26.
//

import Foundation
import MSAL
import AppUtils

/// Routes the redirect from the Microsoft Authenticator broker / web back into MSAL.
/// Must be called from the scene's `openURLContexts`, otherwise the pending
/// `acquireToken` continuation never resumes and sign-in fails silently.
public enum MicrosoftAuthCallback {
    @discardableResult
    public static func handle(_ url: URL, sourceApplication: String?) -> Bool {
        MSALPublicClientApplication.handleMSALResponse(
            url,
            sourceApplication: sourceApplication
        )
    }
}

struct MSALSignInResult {
    let name: String?
    let email: String?
    let idToken: String?
    let error: Error?
    /// True when the user dismissed the Microsoft web sheet themselves — not a failure.
    var isCancelled: Bool = false
}

final class MicrosoftAuthManager {

    private let clientId = AppSecrets.msalClientId
    private let authorityUrl = AppSecrets.msalAuthorityUrl
    private let redirectUri = AppSecrets.msalRedirectURI
    
    private var applicationContext: MSALPublicClientApplication?
        
    init() {
        setupMSAL()
    }

    private func setupMSAL() {
        do {
            let authority = try MSALAADAuthority(url: URL(string: authorityUrl)!)
            let config = MSALPublicClientApplicationConfig(
                clientId: clientId,
                redirectUri: redirectUri,
                authority: authority
            )
            applicationContext = try MSALPublicClientApplication(configuration: config)
        } catch {
            print("MSAL setup error:", error, redirectUri)
        }
    }

    func buildMsalWeb(vc: UIViewController, completion: @escaping (MSALSignInResult) -> Void) {
        guard let appContext = applicationContext else {
            completion(
                .init(
                    name: nil,
                    email: nil,
                    idToken: nil,
                    error: NSError(
                        domain: "MicrosoftAuth",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Microsoft sign-in is unavailable."]
                    )
                )
            )
            return
        }
        
        let parameters = MSALInteractiveTokenParameters(
            scopes: ["User.Read"],
            webviewParameters: MSALWebviewParameters(
                authPresentationViewController: vc
            )
        )
        
        appContext.acquireToken(with: parameters) { result, error in
            if let error = error {
                let nsError = error as NSError
                let cancelled = nsError.domain == MSALErrorDomain
                    && nsError.code == MSALError.userCanceled.rawValue
                completion(
                    .init(
                        name: nil,
                        email: nil,
                        idToken: nil,
                        error: error,
                        isCancelled: cancelled
                    )
                )
                return
            }
            
            guard let result = result else {
                completion(
                    .init(
                        name: nil,
                        email: nil,
                        idToken: nil,
                        error: nil
                    )
                )
                return
            }
            let idToken = result.idToken
            let accountInfo = result.account
            let claims = accountInfo.accountClaims
            
            let name = claims?["name"] as? String
            let email =
                claims?["email"] as? String ??
                claims?["preferred_username"] as? String
            
            completion(
                .init(
                    name: name,
                    email: email,
                    idToken: idToken,
                    error: nil
                )
            )
        }
    }
}
