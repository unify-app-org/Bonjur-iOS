//
//  StudentCardView.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import SwiftUI
import AppFoundation

struct StudentCardView: View {
    @ObservedObject var store: StoreOf<StudentCardFeature>
    
    var body: some View {
        Text("StudentCard")
    }
}
