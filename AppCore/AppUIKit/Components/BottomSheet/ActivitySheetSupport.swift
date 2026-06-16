//
//  ActivitySheetSupport.swift
//  AppUIKit
//
//  Shared leaf UI used by each activity's (per-module) options sheet:
//  the opaque white sheet background, content-height measurement, and the
//  generic "Report" reason screen. The sheets themselves live per-module;
//  only this presentation-agnostic infra is shared.
//

import SwiftUI
import AppPresentationModel

// MARK: - White, opaque sheet background (gated for < iOS 16.4)

public extension View {
    @ViewBuilder
    func activitySheetWhiteBackground() -> some View {
        if #available(iOS 16.4, *) {
            presentationBackground(Color.Palette.white)
        } else {
            self
        }
    }
}

// MARK: - Height measurement

private struct ActivitySheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

public extension View {
    /// Reports the view's measured height once it lays out, for fit-to-content
    /// sheet detents.
    func measureSheetHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: ActivitySheetHeightKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(ActivitySheetHeightKey.self) { height in
            if height > 0 { onChange(height) }
        }
    }
}

// MARK: - Sheet header (close + title)

public struct ActivitySheetHeader: View {
    private let title: String
    private let onBack: () -> Void

    public init(title: String, onBack: @escaping () -> Void) {
        self.title = title
        self.onBack = onBack
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Button(action: onBack) {
                Image(uiImage: UIImage.Icons.xmark)
                    .font(Font.Typography.HeadingXl.semiBold)
                    .foregroundStyle(Color.Palette.black)
            }
            .buttonStyle(.plain)

            Text(title)
                .font(Font.Typography.HeadingMd.bold)
                .foregroundStyle(Color.Palette.black)
        }
        .padding(.top)
    }
}

// MARK: - Activity report screen (radio reasons + Report)

public struct ActivityReportScreen: View {
    private let onBack: () -> Void
    private let onReport: (AppPresentationModel.ActivityReportReason) async -> Bool
    private let onDone: () -> Void

    @State private var selected: AppPresentationModel.ActivityReportReason = .inappropriateContent
    @State private var isSubmitting = false

    private let reasons = AppPresentationModel.ActivityReportReason.allCases

    public init(
        onBack: @escaping () -> Void,
        onReport: @escaping (AppPresentationModel.ActivityReportReason) async -> Bool,
        onDone: @escaping () -> Void
    ) {
        self.onBack = onBack
        self.onReport = onReport
        self.onDone = onDone
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ActivitySheetHeader(title: "Report", onBack: onBack)
                .padding(.horizontal, 20)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(reasons.enumerated()), id: \.element) { index, reason in
                        ActivityReportReasonRow(
                            title: reason.displayTitle,
                            isSelected: reason == selected,
                            showsDivider: index != reasons.count - 1
                        ) { selected = reason }
                    }
                }
                .padding(.horizontal, 20)
            }

            AppButton(
                title: "Report",
                model: .init(type: .destructive, style: .hover, contentSize: .fill)
            ) { submit() }
            .disabled(isSubmitting)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
    }

    private func submit() {
        isSubmitting = true
        Task {
            let ok = await onReport(selected)
            await MainActor.run {
                isSubmitting = false
                if ok { onDone() }
            }
        }
    }
}

// MARK: - Report reason row (radio + title + divider)

private struct ActivityReportReasonRow: View {
    let title: String
    let isSelected: Bool
    let showsDivider: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 16) {
                    ActivitySheetRadioCircle(isSelected: isSelected)
                    Text(title)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(Color.Palette.black)
                    Spacer(minLength: 0)
                }
                .padding(.vertical, 18)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if showsDivider {
                Divider()
                    .overlay(Color.Palette.grayTeritary.opacity(0.5))
            }
        }
    }
}

// MARK: - Radio circle

private struct ActivitySheetRadioCircle: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? Color.Palette.black : Color.Palette.graySecondary,
                    lineWidth: 1.5
                )
                .frame(width: 24, height: 24)
            if isSelected {
                Circle()
                    .fill(Color.Palette.black)
                    .frame(width: 12, height: 12)
            }
        }
    }
}
