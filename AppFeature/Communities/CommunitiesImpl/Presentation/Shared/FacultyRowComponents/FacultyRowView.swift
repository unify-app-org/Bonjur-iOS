//
//  FacultyRowView.swift
//  AppFeature
//
//  Created by aplle on 3/22/26.
//


import SwiftUI
import AppUIKit

struct FacultyRowView: View {
    let data: FacultyRowViewData
    let onTap: (() -> Void)?
    let onAccessoryTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 12) {
            leadingAccessoryView
            
            Button(action: { onTap?() }) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.title)
                            .font(Font.Typography.BodyTextSm.bold)
                            .foregroundStyle(Color.Palette.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        if let subtitle = data.subtitle {
                            Text(subtitle)
                                .font(Font.Typography.TextMd.regular)
                                .foregroundStyle(Color.Palette.graySecondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Image(uiImage: UIImage.Icons.chevronRight)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.graySecondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .buttonStyle(.plain)
        .padding(20)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 0.4)
        )
    }
    
    @ViewBuilder
    private var leadingAccessoryView: some View {
        switch data.accessory {
        case .disclosure:
            EmptyView()
            
        case .selectable(let isSelected):
            if let onAccessoryTap {
                Button(action: { onAccessoryTap() }) {
                    Image(uiImage: isSelected ? .Icons.selectedCheckBox : .Icons.notSelectedCheckBox)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                }
                .buttonStyle(.plain)
            } else {
                Image(uiImage: isSelected ? .Icons.selectedCheckBox : .Icons.notSelectedCheckBox)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
        }
    }
}

#Preview("Disclosure") {
    previewContainer {
        FacultyRowView(
            data: .init(
                id: "1",
                title: "2002 - Bachelor",
                accessory: .disclosure
            ),
            onTap: {},
            onAccessoryTap: nil
        )
    }
}

#Preview("Selectable") {
    previewContainer {
        VStack(spacing: 12) {
            FacultyRowView(
                data: .init(
                    id: "1",
                    title: "2002 - Bachelor",
                    accessory: .selectable(isSelected: true)
                ),
                onTap: {},
                onAccessoryTap: {}
            )
            
            FacultyRowView(
                data: .init(
                    id: "2",
                    title: "2002 - Master",
                    subtitle: "1200 user selected",
                    accessory: .selectable(isSelected: false)
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
