//
//  ProfileSettingsView.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import SwiftUI
import AppFoundation

struct ProfileSettingsView: View {
    @ObservedObject var store: StoreOf<ProfileSettingsFeature>
    
    var body: some View {
        Form {
            ForEach(store.state.sections) { section in
                Section {
                    ForEach(section.items) { item in
                        SettingsRowView(
                            item: item,
                            isOn: store.state.notificationsEnabled
                        )
                        .onTapGesture {
                            if let action = item.action {
                                store.send(action)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .toolbar(.visible)
        .onAppear {
            store.send(.fetchData)
        }
        .padding(.top, -10)
    }
}

struct SettingsRowView: View {
    let item: ProfileSettingsViewState.SettingsModel
    let onToggle: ((Bool) -> Void)?
    @State private var isOn: Bool
    
    init(item: ProfileSettingsViewState.SettingsModel, isOn: Bool = false, onToggle: ((Bool) -> Void)? = nil) {
        self.item = item
        self._isOn = State(initialValue: isOn)
        self.onToggle = onToggle
    }
    
    var body: some View {
        HStack {
            HStack(spacing: 16) {
                Image(uiImage: item.icon.withRenderingMode(.alwaysTemplate))
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
            Toggle("", isOn: Binding(
                get: { isOn },
                set: { newValue in
                    isOn = newValue
                    onToggle?(newValue)
                }
            ))
            .labelsHidden()
        } else if let version = item.versionText {
            Text(version)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        } else {
            Image(uiImage: UIImage.Icons.chevronRight)
        }
    }
}




