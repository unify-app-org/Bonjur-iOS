//
//  AppDelegate+Firebase.swift
//  App
//
//  Created by Huseyn Hasanov on 23.06.26.
//

import UIKit
import FirebaseCore
import UserNotifications
import FirebaseMessaging

extension AppDelegate {

    func setUpFirebase(_ application: UIApplication) {
        configureFirebase()
        registerForPushNotifications(application)
    }

    // MARK: - Configure

    private func configureFirebase() {
        guard FirebaseApp.app() == nil else { return }

        let environment = (Bundle.main.object(forInfoDictionaryKey: "Environment") as? String) ?? "prod"
        let resourceName = "GoogleService-Info-\(environment.capitalized)"

        if let path = Bundle.main.path(forResource: resourceName, ofType: "plist"),
           let options = FirebaseOptions(contentsOfFile: path) {
            FirebaseApp.configure(options: options)
        } else if let options = FirebaseOptions(contentsOfFile: Bundle.main.path(
            forResource: "GoogleService-Info",
            ofType: "plist"
        ) ?? "") {
            FirebaseApp.configure(options: options)
        } else {
            assertionFailure("Firebase: missing \(resourceName).plist for environment \(environment)")
        }
    }

    // MARK: - Push Notifications

    private func registerForPushNotifications(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            print("🔔 [Push] authorization granted=\(granted) error=\(String(describing: error))")
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                print("🔔 [Push] settings auth=\(settings.authorizationStatus.rawValue) alert=\(settings.alertSetting.rawValue)")
            }
            guard granted else { return }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

    // MARK: - APNs Registration (diagnostics)

    public func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("🔔 [Push] APNs device token: \(hex)")
        Messaging.messaging().apnsToken = deviceToken
    }

    public func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("🔔 [Push] APNs registration FAILED: \(error)")
    }
}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        // TODO: forward `fcmToken` to backend so the device can receive pushes.
        print("FCM registration token:", fcmToken ?? "nil")
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .badge, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // TODO: handle notification tap / deep link from `response`.
        completionHandler()
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any]
    ) async -> UIBackgroundFetchResult {
        .newData
    }
}
