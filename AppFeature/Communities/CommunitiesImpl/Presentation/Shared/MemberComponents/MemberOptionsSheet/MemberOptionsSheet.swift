//
//  MemberOptionsSheet.swift
//  AppFeature
//
//  Shared member 3-dot options sheet: Change role / Report user / Share.
//  Pure UI — visibility flags and the role-assignment matrix are computed by the
//  caller via `AppPresentationModel.MemberOptionsPolicy`; this view only renders
//  and delegates the network work through the input's async callbacks.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities
import AppPresentationModel

struct MemberOptionsSheet: View {

    let input: CommunitiesMemberModuleModel.MemberOptionsInput

    private enum Screen {
        case menu
        case assignRole
        case report
    }

    @Environment(\.dismiss) private var dismiss
    @State private var screen: Screen = .menu
    /// Intrinsic content height for the fit-to-content screens (menu / assign).
    @State private var contentHeight: CGFloat = 240

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.Palette.white)
            .presentationDetents(detents)
            .presentationDragIndicator(.visible)
            .sheetWhiteBackground()
            .animation(.easeInOut(duration: 0.22), value: contentHeight)
            .animation(.easeInOut(duration: 0.22), value: screen)
    }

    private var detents: Set<PresentationDetent> {
        switch screen {
        case .report:
            return [.large]
        case .menu, .assignRole:
            return [.height(contentHeight)]
        }
    }

    @ViewBuilder
    private var content: some View {
        switch screen {
        case .menu:
            menu.measureHeight { contentHeight = $0 }
        case .assignRole:
            AssignRoleScreen(
                input: input,
                onBack: { screen = .menu },
                onDone: { dismiss() }
            )
            .measureHeight { contentHeight = $0 }
        case .report:
            ReportUserScreen(
                input: input,
                onBack: { screen = .menu },
                onDone: { dismiss() }
            )
        }
    }

    // MARK: - Menu root

    private var menu: some View {
        VStack(spacing: 0) {
            if input.showChangeRole {
                MemberOptionRow(
                    systemIcon: "person.badge.minus",
                    title: "comm_change_role".localized,
                    tint: Color.Palette.black
                ) { screen = .assignRole }
                rowDivider
            }

            if input.showReport {
                MemberOptionRow(
                    systemIcon: "exclamationmark.circle",
                    title: "comm_report_user".localized,
                    tint: Color.Palette.destructiveRed
                ) { screen = .report }
                rowDivider
            }

            MemberOptionRow(
                systemIcon: "square.and.arrow.up",
                title: "common_share".localized,
                tint: Color.Palette.graySecondary,
                trailing: "Coming soon",
                isDisabled: true
            ) {}
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
    }

    private var rowDivider: some View {
        Divider()
            .overlay(Color.Palette.grayTeritary.opacity(0.6))
            .padding(.leading, 60)
    }
}

// MARK: - White, opaque sheet background (gated for < iOS 16.4)

private extension View {
    @ViewBuilder
    func sheetWhiteBackground() -> some View {
        if #available(iOS 16.4, *) {
            presentationBackground(Color.Palette.white)
        } else {
            self
        }
    }
}

// MARK: - Height measurement

private struct SheetHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

private extension View {
    /// Reports the view's measured height once it lays out.
    func measureHeight(_ onChange: @escaping (CGFloat) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear.preference(key: SheetHeightKey.self, value: proxy.size.height)
            }
        )
        .onPreferenceChange(SheetHeightKey.self) { height in
            if height > 0 { onChange(height) }
        }
    }
}

// MARK: - Menu row

private struct MemberOptionRow: View {
    let systemIcon: String
    let title: String
    let tint: Color
    var trailing: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(tint.opacity(0.10))
                        .frame(width: 40, height: 40)
                    Image(systemName: systemIcon)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(tint)
                }

                Text(title)
                    .font(Font.Typography.BodyTextMd.medium)
                    .foregroundStyle(tint)

                Spacer(minLength: 0)

                if let trailing {
                    Text(trailing)
                        .font(Font.Typography.TextMd.regular)
                        .foregroundStyle(Color.Palette.graySecondary)
                }
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}

// MARK: - Assign role screen

private struct AssignRoleScreen: View {
    let input: CommunitiesMemberModuleModel.MemberOptionsInput
    let onBack: () -> Void
    let onDone: () -> Void

    @State private var selected: AppPresentationModel.UserActivityRole
    @State private var isSubmitting = false

    init(
        input: CommunitiesMemberModuleModel.MemberOptionsInput,
        onBack: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        self.input = input
        self.onBack = onBack
        self.onDone = onDone
        _selected = State(initialValue: input.currentRole)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SheetHeader(title: "comm_assign_role".localized, onBack: onBack)

            Text("comm_choose_role".localized)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.graySecondary)

            VStack(spacing: 12) {
                ForEach(input.assignableRoles, id: \.self) { role in
                    RoleCard(
                        title: role.assignTitle,
                        subtitle: role.assignSubtitle,
                        isSelected: role == selected
                    ) { selected = role }
                }
            }

            HStack(spacing: 12) {
                AppButton(
                    title: "common_cancel".localized,
                    model: .init(type: .secondary, contentSize: .fill)
                ) { onBack() }

                AppButton(
                    title: "comm_confirm".localized,
                    model: .init(type: .primary, contentSize: .fill)
                ) { submit() }
                .disabled(selected == input.currentRole || isSubmitting)
            }
            .padding(.top, 24)
        }
        .padding(20)
    }

    private func submit() {
        isSubmitting = true
        Task {
            let ok = await input.onAssignRole(selected)
            await MainActor.run {
                isSubmitting = false
                if ok { onDone() }
            }
        }
    }
}

// MARK: - Role card (title + subtitle + radio)

private struct RoleCard: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                RadioCircle(isSelected: isSelected)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.Typography.BodyTextMd.bold)
                        .foregroundStyle(Color.Palette.black)
                    if !subtitle.isEmpty {
                        Text(subtitle)
                            .font(Font.Typography.TextMd.regular)
                            .foregroundStyle(Color.Palette.graySecondary)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(16)
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color.Palette.black : Color.Palette.grayTeritary.opacity(0.7),
                        lineWidth: isSelected ? 1 : 0.5
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Report user screen

private struct ReportUserScreen: View {
    let input: CommunitiesMemberModuleModel.MemberOptionsInput
    let onBack: () -> Void
    let onDone: () -> Void

    @State private var selected: AppPresentationModel.ReportReason = .fakeProfile
    @State private var isSubmitting = false

    private let reasons = AppPresentationModel.ReportReason.allCases

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SheetHeader(title: "comm_report_user".localized, onBack: onBack)
                .padding(.horizontal, 20)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(reasons.enumerated()), id: \.element) { index, reason in
                        ReportReasonRow(
                            title: reason.displayTitle,
                            isSelected: reason == selected,
                            showsDivider: index != reasons.count - 1
                        ) { selected = reason }
                    }
                }
                .padding(.horizontal, 20)
            }

            AppButton(
                title: "comm_report".localized,
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
            let ok = await input.onReport(selected)
            await MainActor.run {
                isSubmitting = false
                if ok { onDone() }
            }
        }
    }
}

// MARK: - Report reason row (radio + title + divider)

private struct ReportReasonRow: View {
    let title: String
    let isSelected: Bool
    let showsDivider: Bool
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Button(action: action) {
                HStack(spacing: 16) {
                    RadioCircle(isSelected: isSelected)
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

// MARK: - Shared radio circle

private struct RadioCircle: View {
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

// MARK: - Sheet header (back + title)

private struct SheetHeader: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
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
