//
//  AppDropdownField.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import SwiftUI

public struct AppDropdownField: View {
    @Binding private var selection: AppDropdownOption?
    @State private var isSheetPresented = false
    
    private let title: String?
    private let placeholder: String
    private let sheetTitle: String
    private let options: [AppDropdownOption]
    
    public init(
        selection: Binding<AppDropdownOption?>,
        title: String? = nil,
        placeholder: String,
        sheetTitle: String,
        options: [AppDropdownOption]
    ) {
        self._selection = selection
        self.title = title
        self.placeholder = placeholder
        self.sheetTitle = sheetTitle
        self.options = options
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title {
                Text(title)
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
            }
            
            Button {
                isSheetPresented = true
            } label: {
                HStack {
                    Text(selection?.title ?? placeholder)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(selection == nil ? Color.Palette.grayPrimary : Color.Palette.blackHigh)
                    
                    Spacer()
                    
                    Image(uiImage: UIImage.Icons.chevronDown02)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackMedium)
                }
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
        .appSheet(
            isPresented: $isSheetPresented,
            detents: [.height(sheetHeight)],
            dragIndicator: .hidden
        ) {
            AppDropdownSheetView(
                title: sheetTitle,
                options: options,
                selection: $selection,
                onSelect: {
                    isSheetPresented = false
                },
                onClose: {
                    isSheetPresented = false
                }
            )
        }
    }
    
    private var sheetHeight: CGFloat {
        max(220, CGFloat(options.count) * 58 + 118)
    }
}

private struct AppDropdownSheetView: View {
    let title: String
    let options: [AppDropdownOption]
    @Binding var selection: AppDropdownOption?
    let onSelect: () -> Void
    let onClose: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            
            VStack(spacing: 8) {
                ForEach(options) { option in
                    Button {
                        selection = option
                        onSelect()
                    } label: {
                        HStack {
                            Text(option.title)
                                .font(Font.Typography.BodyTextMd.regular)
                                .foregroundStyle(Color.Palette.blackHigh)
                            
                            Spacer()
                            
                            if selection?.id == option.id {
                                Circle()
                                    .fill(Color.Palette.blackHigh)
                                    .frame(width: 7, height: 7)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.Palette.grayQuaternary.opacity(selection?.id == option.id ? 1 : 0))
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Palette.white)
    }
    
    private var header: some View {
        HStack {
            Text(title)
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.blackHigh)
            
            Spacer()
            
            Button(action: onClose) {
                Image(uiImage: UIImage.Icons.xmark)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.black)
                    .padding(8)
                    .applyGlassIfAvailable()
            }
            .buttonStyle(ScaleOpacityButtonStyle())
        }
    }
}
