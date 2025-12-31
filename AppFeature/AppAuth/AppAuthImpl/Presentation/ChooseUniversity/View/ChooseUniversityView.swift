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
                title: "Next",
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
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    private var topView: some View {
        VStack(spacing: 16) {
            Text("Choose \nUniversity")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            Text("In which university are u studiying?")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(store.state.uiModel.enumerated()), id: \.element.uuid) { index, university in
                    SelectableListItemView(model: university)
                        .onTapGesture {
                            withAnimation {
                                store.send(.selectedCell(index))
                            }
                        }
                }
            }
        }
    }
}
