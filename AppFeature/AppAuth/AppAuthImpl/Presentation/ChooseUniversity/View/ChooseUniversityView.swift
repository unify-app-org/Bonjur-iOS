//
//  ChooseUniversityView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ChooseUniversityView: View {
    @ObservedObject var store: StoreOf<ChooseUniversityFeature>
    
    var body: some View {
        VStack(spacing: 28) {
            topView
            listView
            AppButton(
                title: "auth_next".localized,
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.nextTapped)
            }
            .disabled(store.state.disabled)
        }
        .padding()
        .navigationBarHidden(false)
        .onFirstAppear {
            store.send(.fetchData)
        }
        .appErrorAlert(
            alert: $store.state.error
        )
        .localized()
    }
    
    private var topView: some View {
        VStack(spacing: 16) {
            Text("auth_choose_university_title".localized)
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Text("auth_choose_university_subtitle".localized)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(
                    store.state.uiModel,
                    id: \.uuid
                ) { university in
                    SelectableListItemView(model: university)
                        .onTapGesture {
                            withAnimation {
                                store.send(.selectedCell(university.id))
                            }
                        }
                }
            }
        }
    }
}
