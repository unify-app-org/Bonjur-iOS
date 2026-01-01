//
//  AppTabBarView.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import SwiftUI
import AppFoundation

struct AppTabBarView: View {
    @ObservedObject var store: StoreOf<AppTabBarFeature>
    
    var body: some View {
        TabView {
            Text("Tab 1")
                .tabItem {
                    tabItem(
                        "Discover",
                        icon: UIImage.Icons.home
                    )
                }
            
            Text("Tab 2")
                .tabItem {
                    tabItem(
                        "Clubs",
                        icon: UIImage.Icons.usersGroup
                    )
                }
            
            Text("Tab 3")
                .tabItem {
                    tabItem(
                        "My plans",
                        icon: UIImage.Icons.clipboardList
                    )
                }
            
            Text("Tab 4")
                .tabItem {
                    tabItem(
                        "Profile",
                        icon: UIImage.Icons.userIcon
                    )
                }
        }
        .tint(Color.Palette.blackHigh)
    }
    
    private func tabItem(
        _ label: String,
        icon: UIImage
    ) -> some View {
        VStack {
            Image(uiImage: icon)
            Text(label)
        }
    }
}


#Preview {
    AppTabBarView(store: .init(state: .init()))
}
