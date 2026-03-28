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
    
    @State private var switchOn = true
    
    let sections: [SettingsSection] = [
        .init(
            title: nil,
            items: [
                .init(
                    icon: UIImage.Icons.bell,
                    title: "Notification",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: true
                ),
                .init(
                    icon: UIImage.Icons.globe01,
                    title: "Language",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    action: .didTapLanguage

                ),
                .init(
                    icon: UIImage.Icons.chatQuestion,
                    title: "Help center",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    action: .didTapHelpCenter
                ),
                .init(
                    icon: UIImage.Icons.clipboardList,
                    title: "Terms and conditions",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    action: .didTapTerms
                ),
                .init(
                    icon: UIImage.Icons.mobilePhone,
                    title: "App version",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    versionText: "1.24.0"
                ),
            ]
        ),
        .init(
            title: nil,
            items: [
                .init(
                    icon: UIImage.Icons.trash,
                    title: "Delete account",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    action: .didTapDeleteAccount
                ),
                .init(
                    icon: UIImage.Icons.logout,
                    title: "Log out",
                    rightIcon: UIImage.Icons.chevronright,
                    isSwitch: false,
                    isDestructive: true,
                    action: .didTapLogOut
                )
            ]
        )
    ]
    
    var body: some View {
        
        //        Text("ProfileSettings")
        //            .onAppear {
        //                store.send(.nesebasilfdi)
        //            }

        NavigationStack {
            Form {
                ForEach(sections) { section in
                    Section {
                        ForEach(section.items) { item in
                            SettingsRowView(item: item, switchOn: $switchOn)
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
        }
    }
}


#Preview {
    ProfileSettingsView(
        store: StoreOf<ProfileSettingsFeature>(
            state: ProfileSettingsViewState() // Bura sənin Feature-nin State-idir
        )
    )
}

