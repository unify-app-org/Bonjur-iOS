//
//  MemberListView.swift
//  AppFeature
//
//  Created by aplle on 3/21/26.
//


import SwiftUI
import Communities
import Foundation

struct MemberListView: View {
    let sections: [MemberListSectionViewData]
    let onRowTap: (MemberCellViewData) -> Void
    let onAccessoryTap: (MemberCellViewData) -> Void
    let onSelectGroupTap: (MemberListSectionViewData) -> Void
    let showsScrollView: Bool
    let horizontalPadding: Bool
    
    init(
        sections: [MemberListSectionViewData],
        onRowTap: @escaping (MemberCellViewData) -> Void,
        onAccessoryTap: @escaping (MemberCellViewData) -> Void,
        onSelectGroupTap: @escaping (MemberListSectionViewData) -> Void,
        showsScrollView: Bool = true,
        horizontalPadding: Bool = true
    ) {
        self.sections = sections
        self.onRowTap = onRowTap
        self.onAccessoryTap = onAccessoryTap
        self.onSelectGroupTap = onSelectGroupTap
        self.showsScrollView = showsScrollView
        self.horizontalPadding = horizontalPadding
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
    }
    
    private var content: some View {
        LazyVStack(spacing: 20) {
            ForEach(sections) { section in
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
        }
        .padding(.vertical,16)
        .padding(.horizontal,horizontalPadding ? 16:0)
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
        title: "Owner",
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[0], accessory: .none)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "president",
        title: "President",
        memberCountText: nil,
        rows: [
            .init(member: previewMembers[1], accessory: .optionsMenu)
        ],
        showsSelectGroup: false,
        isGroupSelected: false
    ),
    .init(
        id: "members",
        title: "Members",
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
