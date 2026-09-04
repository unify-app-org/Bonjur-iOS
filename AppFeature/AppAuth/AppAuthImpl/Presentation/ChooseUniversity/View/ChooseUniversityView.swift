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
            .disabled(store.state.disabled || store.state.uiModel.isEmpty)
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
    
    @ViewBuilder
    private var listView: some View {
        if store.state.uiModel.isEmpty {
            emptyView
        } else {
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

    /// The list is never legitimately empty — a blank screen means the request failed
    /// (or the backend has no communities yet), so the reason and a retry are shown
    /// instead of a dead screen. Mirrors Android `CommunitiesMessage`.
    @ViewBuilder
    private var emptyView: some View {
        switch store.state.phase {
        case .loading:
            Spacer()
        case .loaded, .failed:
            VStack(spacing: 12) {
                Spacer()
                AppEmptyView(
                    model: .init(
                        icon: UIImage.Icons.twoUsers,
                        text: store.state.phase == .failed
                            ? "auth_communities_error".localized
                            : "auth_communities_empty".localized
                    )
                )
                Button("auth_try_again".localized) {
                    store.send(.fetchData)
                }
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.appBlue)
                Spacer()
            }
            .frame(maxWidth: .infinity)
        }
    }
}
