//
//  CreateView.swift
//  App
//
//  Created by Huseyn Hasanov on 11.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import SwiftUI
import AppUIKit
import AppFoundation

struct CreateView: View {

    let model: [Model] = [
        .init(
            title: "create_club".localized,
            icon: .Icons.twoUsers,
            type: .club
        ),
        .init(
            title: "create_events".localized,
            icon: .Icons.calendar,
            type: .event
        ),
        .init(
            title: "create_hangouts".localized,
            icon: .Icons.chat,
            type: .hangout
        )
    ]
    
    let selectedType: ((CreateType) -> Void)
    
    init(selectedType: @escaping (CreateType) -> Void) {
        self.selectedType = selectedType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleView
            listView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.top, 36)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
        .background(Color.Palette.white)
        .localized()
    }

    private var titleView: some View {
        Text("create_title".localized)
            .font(Font.Typography.HeadingXl.bold)
            .foregroundStyle(Color.Palette.blackHigh)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var listView: some View {
        VStack(spacing: 0) {
            ForEach(Array(model.enumerated()), id: \.element.id) { index, item in
                listItem(
                    item: item,
                    showsDivider: index < model.count - 1
                )
            }
        }
        .background(Color.Palette.white)
    }
    
    private func listItem(item: Model, showsDivider: Bool) -> some View {
        Button {
            selectedType(item.type)
        } label: {
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    Image(uiImage: item.icon)
                        .padding(12)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text(item.title)
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 16)

                if showsDivider {
                    Divider()
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

extension CreateView {
    
    struct Model: Identifiable {
        let id = UUID()
        
        let title: String
        let icon: UIImage
        let type: CreateType
    }
}

enum CreateType {
    case club
    case event
    case hangout
}
