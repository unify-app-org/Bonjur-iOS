//
//  AppBottomSheet.swift
//  AppFoundation
//
//  Created by aplle on 3/5/26.
//
import SwiftUI

public extension View {
    func appSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        detents: Set<PresentationDetent> = [.medium, .large],
        dragIndicator: Visibility = .visible,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        sheet(isPresented: isPresented, onDismiss: onDismiss) {
            content()
                .presentationDetents(detents)
                .presentationDragIndicator(dragIndicator)
        }
    }
}
