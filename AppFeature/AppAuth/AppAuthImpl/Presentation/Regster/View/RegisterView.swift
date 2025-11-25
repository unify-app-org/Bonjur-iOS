//
//  RegisterView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import SwiftUI
import AppFoundation

struct RegisterView: View {
    @ObservedObject var store: StoreOf<RegisterFeature>
    
    var body: some View {
        Text("RegisterView")
            .onFirstAppear {
                store.send(.fetchData)
            }
    }
}
