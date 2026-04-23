//
//  BackButtonToolbarItem.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//


import SwiftUI

public struct BackButtonToolbarItem<Content: View>: ToolbarContent {
    
    @Binding var isHiddenContent: Bool
    let action: () -> Void
    let content: () -> Content
    
    public init(
        isHiddenContent: Binding<Bool>,
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isHiddenContent = isHiddenContent
        self.action = action
        self.content = content
    }
    
    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            if !isHiddenContent {
                Button(action: action) {
                    content()
                }
                .foregroundStyle(Color.Palette.black)
            }
        }
    }
}

public extension BackButtonToolbarItem where Content == Image {
    init(action: @escaping () -> Void) {
        self._isHiddenContent = .constant(false)
        self.action = action
        self.content = {
            Image(uiImage: UIImage.Icons.arrowLeft01)
                .renderingMode(.template)
        }
    }
}

public extension BackButtonToolbarItem {
    init(
        action: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self._isHiddenContent = .constant(false)
        self.action = action
        self.content = content
    }
}

public extension BackButtonToolbarItem where Content == Image {
    init(
        isHiddenContent: Binding<Bool>,
        action: @escaping () -> Void
    ) {
        self._isHiddenContent = isHiddenContent
        self.action = action
        self.content = {
            Image(uiImage: UIImage.Icons.arrowLeft01)
                .renderingMode(.template)
        }
    }
}

// MARK: - Toolbar Item Background

private struct ToolbarItemBackgroundStyleModifier: ViewModifier {
    let isScrolled: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
        } else {
            content
                .padding(8)
                .background(isScrolled ? Color.Palette.grayQuaternary : Color.Palette.whiteMedium)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

private struct ToolbarItemBackgroundModifier: ViewModifier {
    let isScrolled: Bool
    let action: () -> Void
    
    func body(content: Content) -> some View {
        Button {
            action()
        } label: {
            content
                .toolbarItemBackground(isScrolled: isScrolled)
        }
    }
}

public extension View {
    func toolbarItemBackground(isScrolled: Bool = true) -> some View {
        modifier(ToolbarItemBackgroundStyleModifier(isScrolled: isScrolled))
    }

    func toolbarItemBackground(isScrolled: Bool = true, action: @escaping () -> Void) -> some View {
        modifier(ToolbarItemBackgroundModifier(isScrolled: isScrolled, action: action))
    }
}
