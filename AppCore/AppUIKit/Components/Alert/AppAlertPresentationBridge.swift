//
//  AppAlertPresentationBridge.swift
//  AppCore
//
//  Created by aplle on 3/19/26.
//


import SwiftUI
import UIKit

struct AppAlertPresentationBridge: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let alert: AppAlert
    let sourceID: UUID

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            AppAlertPresenter.present(
                alert,
                sourceID: sourceID
            ) {
                isPresented = false
            }
        } else {
            AppAlertPresenter.dismiss(sourceID: sourceID)
        }
    }
}
