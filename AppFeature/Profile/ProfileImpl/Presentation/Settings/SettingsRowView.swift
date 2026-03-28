//
//  SettingsRowView.swift
//  AppFeature
//
//  Created by Nahid Askerli on 27.03.26.
//



import SwiftUI

struct SettingsModel: Identifiable {
    let id = UUID()
    let icon: UIImage
    let title: String
    let rightIcon: UIImage
    let isSwitch: Bool
    var isDestructive: Bool = false
    var versionText: String? = nil
    var action: ProfileSettingsAction? = nil
}

struct SettingsSection: Identifiable {
    let id = UUID()
    let title: String?
    let items: [SettingsModel]
}

struct SettingsRowView: View {
    let item: SettingsModel
    @Binding var switchOn: Bool
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(uiImage: item.icon.withRenderingMode(.alwaysTemplate))
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(item.isDestructive ? .red : .black)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(item.title)
                    .foregroundStyle(item.isDestructive ? .red : .primary)
            }
            
            Spacer()
            
            trailingView
        }
    }
    
    
    @ViewBuilder
    private var trailingView: some View {
        if item.isSwitch {
            Toggle("", isOn: $switchOn)
                .labelsHidden()
        } else if let version = item.versionText {
            Text(version)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            Image(uiImage: UIImage.Icons.chevronright)
        }

    }

    
}


