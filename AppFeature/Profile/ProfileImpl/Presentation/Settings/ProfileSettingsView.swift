//
//  ProfileSettingsView.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import SwiftUI
import AppFoundation

struct ProfileSettingsView: View {
    @ObservedObject var store: StoreOf<ProfileSettingsFeature>
    
    var body: some View {
        Text("ProfileSettings")
    }
}


//struct Model: Identifiable {
//    let id = UUID()
//    let icon: String
//    let basliq: String
//    let isSwitch: Bool
//}
//
//struct SettingsView: View {
//    @State private var switchOn = true
//    
//    let siyahı = [
//        Model(icon: "bell.fill", basliq: "Bildirişlər", isSwitch: true),
//        Model(icon: "lock.fill", basliq: "Məxfilik", isSwitch: false),
//        Model(icon: "person.fill", basliq: "Profil", isSwitch: false),
//        Model(icon: "gearshape.fill", basliq: "Ümumi", isSwitch: false)
//    ]
//    
//    var body: some View {
//        NavigationStack {
//            List {
//                ForEach(siyahı) { element in
//                    HStack(spacing: 15) {
//                        Image(systemName: element.icon)
//                            .foregroundColor(.blue)
//                            .frame(width: 30)
//                        
//                        Text(element.basliq)
//                        
//                        Spacer()
//                        if element.isSwitch {
//                            Toggle("", isOn: $switchOn)
//                                .labelsHidden()
//                        } else {
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.gray)
//                                .font(.system(size: 14, weight: .semibold))
//                        }
//                    }
//                    .padding(.vertical, 5)
//                }
//            }
//            NavigationLink("Go to Parent") {
//                ParentView()
//            }
//        }
//        
//    }
//}
//
//
//#Preview {
//    SettingsView()
//}
