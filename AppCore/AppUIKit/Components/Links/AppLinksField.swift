//
//  AppLinksField.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import SwiftUI

public struct AppLinksField: View {
    @Binding private var links: [AppLinkItem]
    @State private var isAddLinkPresented = false
    
    private let title: String
    private let addTitle: String
    /// `nil` keeps the plain title (non-schema callers). Non-nil draws the
    /// required `*` / `(optional)` marker, same as every other schema field.
    private let isRequired: Bool?
    private let maxCount: Int
    private let typeOptions: [AppDropdownOption]
    
    public init(
        title: String = "Add link",
        addTitle: String = "Add link",
        isRequired: Bool? = nil,
        links: Binding<[AppLinkItem]>,
        maxCount: Int = 4,
        typeOptions: [AppDropdownOption] = AddLinkView.defaultTypeOptions
    ) {
        self.title = title
        self.addTitle = addTitle
        self.isRequired = isRequired
        self._links = links
        self.maxCount = maxCount
        self.typeOptions = typeOptions
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let isRequired {
                AppFieldLabel(text: title, isRequired: isRequired)
            } else {
                Text(title)
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ForEach(links) { link in
                linkCell(link)
            }
            
            if links.count < maxCount {
                addButton
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .appSheet(
            isPresented: $isAddLinkPresented,
            detents: [.height(560), .large],
            dragIndicator: .hidden
        ) {
            AddLinkView(typeOptions: typeOptions) { link in
                addLink(link)
            }
        }
    }
    
    private func linkCell(_ link: AppLinkItem) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(link.name)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                
                Text(link.url)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Button {
                removeLink(link)
            } label: {
                Image(uiImage: UIImage.Icons.trash)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.Palette.cardBgRed)
                    .padding(8)
            }
            .buttonStyle(ScaleOpacityButtonStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
    
    private var addButton: some View {
        Button {
            isAddLinkPresented = true
        } label: {
            HStack {
                Text(addTitle)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(Color.Palette.blackHigh)
                
                Spacer()
                
                Image(uiImage: UIImage.Icons.plus)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.blackHigh)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(Color.Palette.white)
            .contentShape(Capsule())
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(
                    Color.Palette.graySecondary,
                    lineWidth: 0.5
                )
            )
        }
        .buttonStyle(ScaleOpacityButtonStyle())
    }
    
    private func removeLink(_ link: AppLinkItem) {
        links.removeAll { $0.id == link.id }
    }
    
    private func addLink(_ link: AppLinkItem) {
        var updatedLinks = links
        updatedLinks.append(link)
        links = updatedLinks
    }
}
