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
