//
//  CreateView.swift
//  App
//
//  Created by Huseyn Hasanov on 11.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import SwiftUI
import AppUIKit

struct CreateView: View {
    
    let model: [Model] = [
        .init(
            title: "Club",
            icon: .Icons.twoUsers,
            type: .club
        ),
        .init(
            title: "Events",
            icon: .Icons.calendar,
            type: .event
        ),
        .init(
            title: "Hangouts",
            icon: .Icons.chat,
            type: .hangout
        )
    ]
    
    let selectedType: ((CreateType) -> Void)
    
    init(selectedType: @escaping (CreateType) -> Void) {
        self.selectedType = selectedType
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create")
                .font(Font.Typography.HeadingXl.bold)
                .foregroundStyle(Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
            listView
        }
        .padding(.vertical, 24)
        .padding(.leading, 24)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding()
    }
    
    private var listView: some View {
        VStack(spacing: 20) {
            ForEach(model, id: \.id) { item in
                listItem(item: item)
            }
        }
    }
    
    private func listItem(item: Model) -> some View {
        Button {
            selectedType(item.type)
        } label: {
            HStack(spacing: 16) {
                Image(uiImage: item.icon)
                    .padding(12)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                VStack {
                    Text(item.title)
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                        .padding(.top, 8)
                }
                .padding(.top, 8)
            }
        }
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
