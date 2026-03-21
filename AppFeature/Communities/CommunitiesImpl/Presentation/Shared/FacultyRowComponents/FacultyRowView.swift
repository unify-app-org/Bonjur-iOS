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

    var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 12) {
                leadingAccessoryView

                Text(data.title)
                    .font(Font.Typography.BodyTextSm.bold)
                    .foregroundStyle(Color.Palette.black)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(uiImage: UIImage.Icons.chevronRight)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .padding(20)
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 0.4)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var leadingAccessoryView: some View {
        switch data.accessory {
        case .disclosure:
            EmptyView()

        case .selectable(let isSelected):
            Image(uiImage: isSelected ? .Icons.selectedCheckBox : .Icons.notSelectedCheckBox)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
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
            onTap: {}
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
                onTap: {}
            )

            FacultyRowView(
                data: .init(
                    id: "2",
                    title: "2002 - Master",
                    accessory: .selectable(isSelected: false)
                ),
                onTap: {}
            )
        }
        .padding()
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
