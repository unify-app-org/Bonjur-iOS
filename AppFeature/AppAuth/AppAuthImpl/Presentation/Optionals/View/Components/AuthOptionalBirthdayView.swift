//
//  AuthOptionalBirthdayView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 27.12.25.
//

import SwiftUI
import AppUIKit
import AppFoundation

struct AuthOptionalBirthdayView: View {
    @State private var selectedDate = Date()
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>

    var body: some View {
        ScrollView {
            VStack(spacing: 36) {
                topView
                datePicker
            }
            .padding(.horizontal)
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Birthday")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Whats your date of birth?")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var datePicker: some View {
        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
            .datePickerStyle(.wheel)
            .labelsHidden()
            .scaleEffect(x: 1.2, y: 1.2)
    }
}
