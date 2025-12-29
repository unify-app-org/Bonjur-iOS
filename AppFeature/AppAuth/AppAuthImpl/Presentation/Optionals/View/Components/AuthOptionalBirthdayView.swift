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
                inputField
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            store.send(.closeKeyboard)
            store.send(.closeDatePicker)
        }
    }
    
    private var inputField: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        store.state.showDatePicker = true
                    }
                    UIApplication.shared.endEditing()
                }
            HStack {
                if let date = store.state.birthDate {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.Palette.blackHigh)
                } else {
                    Text("Date of birth")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.Palette.blackDisabled)
                }
                Image(uiImage: UIImage.Icons.calendar)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 15)
            .overlay(Capsule().stroke(Color.Palette.graySecondary, lineWidth: 0.5))
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
}
