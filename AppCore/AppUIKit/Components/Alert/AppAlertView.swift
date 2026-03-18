//
//  AppAlertView.swift
//  AppCore
//
//  Created by aplle on 3/18/26.
//


import SwiftUI

public struct AppAlertView: View {
    private let alert: AppAlert
    private let dismiss: () -> Void

    public init(
        alert: AppAlert,
        dismiss: @escaping () -> Void
    ) {
        self.alert = alert
        self.dismiss = dismiss
    }

    public var body: some View {
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

    @ViewBuilder
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
                actionView(for:action)
            }
        }
    }

    @ViewBuilder
    private func actionView(for action: AppAlert.Action) -> some View {
        switch action.style {
        case .primary:
            AppButton(
                title: action.title,
                model: .init(
                    type: .primary,
                    style: .hover,
                    contentSize: .fill,
                    size: .large
                )
            ) {
                action.handler(dismiss)
            }

        case .secondary:
            AppButton(
                title: action.title,
                model: .init(
                    type: .tertiary,
                    style: .default,
                    contentSize: .fill,
                    size: .large
                )
            ) {
                action.handler(dismiss)
            }

        case .destructive:
            Button {
                action.handler(dismiss)
            } label: {
                Text(action.title)
                    .font(Font.Typography.BodyTextMd.medium)
                    .foregroundStyle(Color.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.plain)
        }
    }

}
