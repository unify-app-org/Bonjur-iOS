//
//  RegisterView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct RegisterView: View {
    @ObservedObject var store: StoreOf<RegisterFeature>
    
    var body: some View {
        VStack {
            Text("example".localized)
                .font(Font.Typography.TitleXl.extraBold)
                .onFirstAppear {
                    store.send(.fetchData)
                }
        }
    }
}
