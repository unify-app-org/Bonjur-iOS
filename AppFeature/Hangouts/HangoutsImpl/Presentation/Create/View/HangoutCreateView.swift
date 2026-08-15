//
//  HangoutCreateView.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct HangoutCreateView: View {
    @ObservedObject var store: StoreOf<HangoutCreateFeature>

    var body: some View {
        VStack(spacing: .zero) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    topView

                    ForEach(store.state.hangoutsCreateSchema) { field in
                        FieldSchemaRouter(
                            field: field,
                            values: Binding(
                                get: { store.state.values },
                                set: { store.state.values = $0 }
                            ),
                            selectedCategories: store.state.selectedCategories,
                            isDisabled: store.state.disabledFieldIDs.contains(field.id),
                            onAddCategory: {
                                store.send(.addCategoryTapped)
                            },
                            onRemoveCategory: { id in
                                store.send(.removeCategory(id))
                            }
                        )
                    }
                }
                .padding(.top, 20)
                .padding(.bottom, 24)
            }

            AppButton(
                title: "hangouts_continue".localized,
                model: .init(contentSize: .fill)
            ) {
                store.send(.continueTapped)
            }
            .disabled(!store.state.isValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .toolbarItemBackground {
                        store.send(.backTapped)
                    }
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
        .dismissKeyboardOnTap()
        .sheet(
            isPresented: Binding(
                get: { store.state.showCategoryPicker },
                set: { isPresented in
                    if !isPresented {
                        store.send(.dismissCategoryPicker)
                    }
                }
            )
        ) {
            SelectCategoryView(
                sections: $store.state.categorySections,
                onBack: {
                    store.send(.dismissCategoryPicker)
                },
                onDone: {
                    store.send(.categoryPickerDone)
                }
            )
        }
    }

    private var topView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(self.store.state.topTitle)
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.black)

            Text("hangouts_required_hint".localized)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.appBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}
