//
//  DiscoverView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import SwiftUI
import AppFoundation

struct DiscoverView: View {
    @ObservedObject var store: StoreOf<DiscoverFeature>
    
    var body: some View {
        Text("Discover")
    }
}
