//
//  CapsuleSegmentedPicker.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import SwiftUI

public struct CapsuleSegmentedPicker<
    T: Hashable & CaseIterable & RawRepresentable
>: View where T.RawValue == String {

    @Binding private var selection: T

    public init(selection: Binding<T>) {
        self._selection = selection
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(T.allCases), id: \.self) { item in
                Text(item.rawValue)
                    .font(selection == item ? Font.Typography.TextL.bold : Font.Typography.TextL.medium)
                    .foregroundStyle(selection == item ? Color.Palette.blackHigh : Color.Palette.blackDisabled)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(
                        Capsule()
                            .fill(selection == item ? Color.Palette.white : Color.clear)
                    )
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selection = item
                        }
                    }
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Color.Palette.grayQuaternary)
        )
    }
}
