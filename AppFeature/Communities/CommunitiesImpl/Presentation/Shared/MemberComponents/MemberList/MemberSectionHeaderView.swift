//
//  MemberSectionHeaderView.swift
//  AppFeature
//
//  Created by aplle on 3/21/26.
//


import SwiftUI
import AppUIKit

struct MemberSectionHeaderView: View {
    let title: String
    let memberCountText: String?
    let showsSelectGroup: Bool
    let isGroupSelected: Bool
    let onSelectGroupTap: (() -> Void)?

    var body: some View {
        HStack(spacing: 8) {
            Text(title)
                .font(Font.Typography.HeadingMd.bold)
                .foregroundStyle(Color.Palette.black)

            Spacer()

            if let memberCountText {
                Text(memberCountText)
                    .font(Font.Typography.TextL.bold)
                    .foregroundStyle(Color.Palette.grayPrimary)
            }

            if showsSelectGroup {
                Button(action: { onSelectGroupTap?() }) {
                    HStack(spacing: 6) {
                        Image(uiImage: isGroupSelected ? .Icons.selectedCheckBox :.Icons.notSelectedCheckBox)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18,height: 18)
                           
                        Text("select group")
                    }
                    .font(Font.Typography.TextL.bold)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    MemberSectionHeaderView(title: "Computer Engineering", memberCountText:"28 student", showsSelectGroup: false, isGroupSelected: true) {
        
    }
}
