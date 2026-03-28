//
//  MemberCellView.swift
//  AppFeature
//
//  Created by aplle on 3/20/26.
//

import SwiftUI
import AppUIKit

struct MemberCellView: View {
    let data: MemberCellViewData
    let onTap: (() -> Void)?
    let onAccessoryTap: (() -> Void)?
    
    var body: some View {
        rowContent
            .padding(14)
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary.opacity(0.7), lineWidth: 0.4)
            )
    }
    
    @ViewBuilder
    private var rowContent: some View {
        switch data.accessory {
        case .optionsMenu:
            HStack(spacing: 12) {
                Button(action: { onTap?() }) {
                    HStack(spacing: 12) {
                        avatarView
                        textStack
                        Spacer(minLength: 0)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                optionsButton
            }
            
        default:
            Button(action: { onTap?() }) {
                HStack(spacing: 12) {
                    avatarView
                    textStack
                    Spacer()
                    accessoryView
                }
            }
            .buttonStyle(.plain)
        }
    }
    
    private var textStack:some View{
        VStack(alignment: .leading, spacing: showsSubtitle ? 4 : 0) {
            
            Text(data.member.name)
                .font(Font.Typography.BodyTextMd.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if showsSubtitle {
                Text(data.member.subtitle)
                    .font(Font.Typography.TextMd.bold)
                    .foregroundStyle(Color.Palette.graySecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
    
    private var showsSubtitle: Bool {
        if case .optionsMenu = data.accessory {
            return !data.member.subtitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }
    
    
    private var avatarView: some View {
        CachedAsyncImage(url: data.member.avatarURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(uiImage: .Icons.userIcon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding(10)
                .foregroundStyle(Color.Palette.blackMedium)
        }
        .frame(width: 40, height: 40)
        .background(Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.Palette.grayTeritary.opacity(0.7), lineWidth: 0.4)
        )
    }
    
    private var optionsButton: some View {
        Button(action: { onAccessoryTap?()}) {
            Image(uiImage: UIImage.Icons.ellipsis02)
                .renderingMode(.template)
                .foregroundStyle(Color.Palette.graySecondary)
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    private var accessoryView: some View {
        switch data.accessory {
        case .none:
            EmptyView()
            
        case .disclosure:
            Image(uiImage: UIImage.Icons.chevronRight)
                .resizable()
                .scaledToFit()
                .frame(width: 24,height: 24)
            
            
        case .checkbox(let isSelected):
            Image(uiImage: isSelected ? .Icons.selectedCheckBox :.Icons.notSelectedCheckBox)
                .resizable()
                .scaledToFit()
                .frame(width: 18,height: 18)
            
            
            
        case .optionsMenu:
            optionsButton
        }
    }
}


// MARK: - Preview
#Preview("All States") {
    previewContainer {
        VStack(spacing: 12) {
            MemberCellView(
                data: .init(
                    member: .init(
                        id: "1",
                        name: "Nihad Asgarli",
                        avatarURL: nil,
                        subtitle: "Bachelor, Computer engineering, 2017"
                    ),
                    accessory: .disclosure
                ),
                onTap: {},
                onAccessoryTap: nil
            )
            
            MemberCellView(
                data: .init(
                    member: .init(
                        id: "2",
                        name: "Huseyn Hasanov",
                        avatarURL:.init(string: "https://i.pinimg.com/736x/d7/60/93/d76093672c8baa3b56665ec29922b6c1.jpg"),
                        subtitle: "Bachelor, Computer engineering, 2017"
                    ),
                    accessory: .checkbox(isSelected: false)
                ),
                onTap: {},
                onAccessoryTap: {}
            )
            
            MemberCellView(
                data: .init(
                    member: .init(
                        id: "3",
                        name: "Durdana Hasanova",
                        avatarURL:.init(string: "https://i.pinimg.com/736x/9e/52/3d/9e523d8faf76136111fa4b6f2596db1b.jpg"),
                        subtitle: "Bachelor, Computer engineering, 2017"
                    ),
                    accessory: .checkbox(isSelected: true)
                ),
                onTap: {},
                onAccessoryTap: {}
            )
            
            MemberCellView(
                data: .init(
                    member: .init(
                        id: "4",
                        name: "Nihad Asgarli",
                        avatarURL:.init(string: "https://i.pinimg.com/736x/d7/60/93/d76093672c8baa3b56665ec29922b6c1.jpg"),
                        subtitle: "Bachelor, Computer engineering, 2017"
                    ),
                    accessory: .optionsMenu
                ),
                onTap: {},
                onAccessoryTap: {}
            )
        }
    }
}

private func previewContainer<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        content()
            .padding()
    }
}
