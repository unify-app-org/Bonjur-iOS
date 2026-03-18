//
//  AppAlertView.swift
//  AppCore
//
//  Created by aplle on 3/18/26.
//


import SwiftUI

 struct AppAlertView: View {
    private let alert: AppAlert
    private let dismiss: () -> Void

     init(
        alert: AppAlert,
        dismiss: @escaping () -> Void
    ) {
        self.alert = alert
        self.dismiss = dismiss
    }

     var body: some View {
        VStack(spacing: 20) {
            textSection
            actionsSection
        }
        .padding(24)
        .frame(maxWidth: 360)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.Palette.grayTeritary.opacity(0.4), lineWidth: 0.5)
        )
        .padding(.horizontal, 24)
       
    }

    
    private var textSection: some View {
        VStack(alignment:.leading, spacing: 12) {
            Text(alert.config.title)
                .font(Font.Typography.TitleSm.bold)
                .foregroundStyle(Color.Palette.black)
                .multilineTextAlignment(.leading)

            if let subtitle = alert.config.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
    }

    private var actionsSection: some View {
           HStack(spacing: 12) {
               ForEach(alert.actions) { action in
                   AppButton(
                       title: action.title,
                       model: buttonModel(for: action.style)
                   ) {
                       action.handler(dismiss)
                   }
               }
           }
       }

       private func buttonModel(for style: AppAlert.Action.Style) -> AppButton.Model {
           switch style {
           case .primary:
               return .init(
                   type: .primary,
                   style: .hover,
                   contentSize: .fill,
                   size: .large
               )
           case .secondary:
               return .init(
                   type: .tertiary,
                   contentSize: .fill,
                   size: .large
               )
           case .destructive:
               return .init(
                type: .destructive,
                contentSize: .fill,
                size: .large
            )
           }
       }

}
