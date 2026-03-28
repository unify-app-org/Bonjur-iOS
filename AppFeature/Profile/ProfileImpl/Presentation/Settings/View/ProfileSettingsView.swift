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
            store.send(.viewDidLoad)
        }
        .padding(.top, -10)
    }
}




