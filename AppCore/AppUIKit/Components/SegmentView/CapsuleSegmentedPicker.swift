//
//  CapsuleSegmentedPicker.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import SwiftUI
import AppLocalization

public struct CapsuleSegmentedPicker<
    T: Hashable & CaseIterable & RawRepresentable
>: View where T.RawValue == String {
    @Binding private var selection: T
    @Namespace private var animation
    /// Overrides the label, e.g. to append a count: "Clubs (2)". Defaults to the
    /// localized raw value.
    private let titleFor: (T) -> String

    public init(
        selection: Binding<T>,
        titleFor: @escaping (T) -> String = { $0.rawValue.localized }
    ) {
        self._selection = selection
        self.titleFor = titleFor
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Text(titleFor(item))
                    .font(selection == item ? Font.Typography.TextL.semiBold : Font.Typography.TextL.regular)
                    .foregroundStyle(selection == item ? Color.Palette.blackHigh : Color.Palette.blackDisabled)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
                    .contentShape(Capsule())
                    .background {
                        if selection == item {
                            Capsule()
                                .fill(Color.Palette.white)
                                .matchedGeometryEffect(id: "selectedBackground", in: animation)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selection = item
                        }
                    }
            }
        }
        .padding(5)
        .background(
            Capsule()
                .fill(Color.Palette.grayQuaternary)
        )
    }
}
