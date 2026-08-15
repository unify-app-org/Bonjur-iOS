//
//  MemberListView.swift
//  AppFeature
//
//  Created by aplle on 3/21/26.
//


import SwiftUI
import AppFoundation
import Communities
import Foundation
import AppUIKit

struct MemberListView: View {
    let sections: [MemberListSectionViewData]
    let onRowTap: (MemberCellViewData) -> Void
    let onAccessoryTap: (MemberCellViewData) -> Void
    let onSelectGroupTap: (MemberListSectionViewData) -> Void
    let showsScrollView: Bool
    let horizontalPadding: Bool
    let previewLimit: Int?
    let totalCount: Int?
    let onSeeAllTapped: (() -> Void)?

    init(
        sections: [MemberListSectionViewData],
        onRowTap: @escaping (MemberCellViewData) -> Void,
        onAccessoryTap: @escaping (MemberCellViewData) -> Void,
        onSelectGroupTap: @escaping (MemberListSectionViewData) -> Void,
        showsScrollView: Bool = true,
        horizontalPadding: Bool = true,
        previewLimit: Int? = 5,
        totalCount: Int? = nil,
        onSeeAllTapped: (() -> Void)? = nil
    ) {
        self.sections = sections
        self.onRowTap = onRowTap
        self.onAccessoryTap = onAccessoryTap
        self.onSelectGroupTap = onSelectGroupTap
        self.showsScrollView = showsScrollView
        self.horizontalPadding = horizontalPadding
        self.previewLimit = previewLimit
        self.totalCount = totalCount
        self.onSeeAllTapped = onSeeAllTapped
    }

    var body: some View {
        Group {
            if showsScrollView {
                ScrollView(showsIndicators: false) {
                    content
                }
            } else {
                content
            }
        }
        .dismissKeyboardOnTap()
    }

    /// Total members across all loaded sections.
    private var loadedCount: Int {
        sections.reduce(0) { $0 + $1.rows.count }
    }

    /// Sections capped to `previewLimit` rows, taken in role/section order. Returns the full
    /// sections when no preview limit is set.
    private var visibleSections: [MemberListSectionViewData] {
        guard let previewLimit else { return sections }
        var remaining = previewLimit
        var result: [MemberListSectionViewData] = []
        for section in sections {
            guard remaining > 0 else { break }
            let rows = Array(section.rows.prefix(remaining))
            remaining -= rows.count
            result.append(
                MemberListSectionViewData(
                    id: section.id,
                    title: section.title,
                    memberCountText: section.memberCountText,
                    rows: rows,
                    showsSelectGroup: section.showsSelectGroup,
                    isGroupSelected: section.isGroupSelected
                )
            )
        }
        return result
    }

    /// True when a preview limit is set, a handler exists, and the real total exceeds the limit.
    private var showsSeeAll: Bool {
        guard let previewLimit, onSeeAllTapped != nil else { return false }
        return (totalCount ?? loadedCount) > previewLimit
    }

    private var content: some View {
        LazyVStack(spacing: 20) {
            ForEach(visibleSections) { section in
                VStack(alignment: .leading, spacing: 12) {
                    MemberSectionHeaderView(
                        title: section.title,
                        memberCountText: section.memberCountText,
                        showsSelectGroup: section.showsSelectGroup,
                        isGroupSelected: section.isGroupSelected,
                        onSelectGroupTap: { onSelectGroupTap(section) }
                    )

                    VStack(spacing: 10) {
                        ForEach(section.rows) { row in
                            MemberCellView(
                                data: row,
                                onTap: { onRowTap(row) },
                                onAccessoryTap: { onAccessoryTap(row) }
                            )
                        }
                    }
                }
            }

            if showsSeeAll {
                seeAllButton
            }
        }
        .padding(.vertical,16)
        .padding(.horizontal,horizontalPadding ? 16:0)
    }

    private var seeAllButton: some View {
        Button {
            onSeeAllTapped?()
        } label: {
            HStack(spacing: 6) {
                Text("See all \(totalCount ?? loadedCount) members")
                    .font(Font.Typography.TextL.bold)
                Image(uiImage: .Icons.chevronRight)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .foregroundStyle(Color.Palette.appBlue)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}


// MARK: - Preview


#Preview("Browse List") {
    previewContainer {
        MemberListView(
            sections: browsePreviewSections,
            onRowTap: { _ in },
            onAccessoryTap: { _ in },
            onSelectGroupTap: { _ in }
        )
    }
}

#Preview("Selectable List") {
    previewContainer {
        MemberListView(
            sections: selectablePreviewSections,
            onRowTap: { _ in },
            onAccessoryTap: { _ in },
            onSelectGroupTap: { _ in }
        )
    }
}

#Preview("Club Members") {
    previewContainer {
        MemberListView(
            sections: clubMembersPreviewSections,
            onRowTap: { _ in },
            onAccessoryTap: { _ in },
            onSelectGroupTap: { _ in }
        )
    }
}

private let avatarURL1 = URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg")
private let avatarURL2 = URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg")
private let avatarURL3 = URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg")

private let previewMembers: [CommunitiesMemberModuleModel.MemberCellModel] = [
    .init(
        id: "1",
        name: "Nihad Asgarli",
        avatarURL: avatarURL1,
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "2",
        name: "Huseyn Hasanov",
        avatarURL: avatarURL2,
        subtitle: "Bachelor, Computer engineering, 2017"
    ),
    .init(
        id: "3",
        name: "Durdana Hasanova",
        avatarURL: avatarURL3,
        subtitle: "Bachelor, Computer engineering, 2017"
    )
]

private let browsePreviewSections: [MemberListSectionViewData] = [
    .init(
        id: "browse-ce",
        title: "Computer engineering",
        memberCountText: "28 student",
        rows: [
            .init(member: previewMembers[0], accessory: .disclosure),
            .init(member: previewMembers[1], accessory: .disclosure),
            .init(member: previewMembers[2], accessory: .disclosure)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "browse-chem",
        title: "Chemistry",
        memberCountText: "20 student",
        rows: [
            .init(member: previewMembers[1], accessory: .disclosure),
            .init(member: previewMembers[2], accessory: .disclosure)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    )
]

private let selectablePreviewSections: [MemberListSectionViewData] = [
    .init(
        id: "select-ce",
        title: "Computer engineering",
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[0], accessory: .checkbox(isSelected: true)),
            .init(member: previewMembers[1], accessory: .checkbox(isSelected: false)),
            .init(member: previewMembers[2], accessory: .checkbox(isSelected: true))
        ],
        showsSelectGroup: true,
        isGroupSelected: false
    ),
    .init(
        id: "select-chem",
        title: "Chemistry",
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[0], accessory: .checkbox(isSelected: false)),
            .init(member: previewMembers[2], accessory: .checkbox(isSelected: false))
        ],
        showsSelectGroup: true,
        isGroupSelected: true
    )
]

private let clubMembersPreviewSections: [MemberListSectionViewData] = [
    .init(
        id: "owner",
        title: "comm_owner_role".localized,
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[0], accessory: .none)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "president",
        title: "comm_president".localized,
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[1], accessory: .optionsMenu)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "members",
        title: "Members".localized,
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[2], accessory: .optionsMenu),
            .init(member: previewMembers[0], accessory: .optionsMenu)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    )
]

private func previewContainer<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        content()
    }
}
