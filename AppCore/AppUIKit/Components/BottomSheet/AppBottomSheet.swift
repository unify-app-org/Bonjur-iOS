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

    /// Item-driven variant: presents when `item` is non-nil and passes the
    /// unwrapped value to the content builder. The content may set its own
    /// detents / drag indicator (e.g. the member options sheet).
    func appSheet<Item: Identifiable, SheetContent: View>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> SheetContent
    ) -> some View {
        sheet(item: item, onDismiss: onDismiss) { value in
            content(value)
        }
    }
}
