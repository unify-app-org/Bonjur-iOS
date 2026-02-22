//
//  EventCreateView.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import SwiftUI
import AppFoundation

struct EventCreateView: View {
    @ObservedObject var store: StoreOf<EventCreateFeature>
    
    var body: some View {
        Text("EventCreate")
    }
}
