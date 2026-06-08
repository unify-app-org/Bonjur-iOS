//
//  EventCreateView.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct EventCreateView: View {
    @ObservedObject var store: StoreOf<EventCreateFeature>

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        coverHeader
                        fieldView
                            .padding(.top, 20)
                            .padding(.bottom, 24)
                    }
                }

                AppButton(
                    title: "Continue",
                    model: .init(contentSize: .fill)
                ) {
                    store.send(.continueTapped)
                }
                .disabled(!store.state.isValid)
                .padding(.bottom, min(proxy.safeAreaInsets.bottom, 34))
                .padding(.horizontal)
            }
            .ignoresSafeArea(edges: .top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .toolbarItemBackground(isScrolled: true) {
                        store.send(.backTapped)
                    }
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
        .dismissKeyboardOnTap()
        .appSheet(
            isPresented: Binding(
                get: { store.state.showClubPicker },
                set: { if !$0 { store.send(.dismissClubPicker) } }
            ),
            detents: [.large],
            dragIndicator: .visible
        ) {
            SelectClubView(
                clubs: store.state.clubs,
                selectedClubId: store.state.selectedClubId,
                onSelect: { store.send(.selectClub($0)) }
            )
        }
        .sheet(
            isPresented: Binding(
                get: { store.state.showCategoryPicker },
                set: { if !$0 { store.send(.dismissCategoryPicker) } }
            )
        ) {
            SelectCategoryView(
                sections: $store.state.categorySections,
                onBack: { store.send(.dismissCategoryPicker) },
                onDone: { store.send(.categoryPickerDone) }
            )
        }
    }

    // MARK: - Cover header (read-only club cover)

    private var coverHeader: some View {
        ZStack {
            if let coverURL = store.state.coverURL {
                CachedAsyncImage(url: coverURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.Palette.grayQuaternary
                }
            } else {
                Color.Palette.grayQuaternary
            }

            VStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Color.Palette.white)
                    .font(.system(size: 20, weight: .semibold))

                Text("This event will use the official club cover photo.")
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.white)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .clipped()
        .overlay(Color.Palette.black.opacity(store.state.coverURL == nil ? 0 : 0.25))
    }

    // MARK: - Fields

    private var fieldView: some View {
        VStack(spacing: 16) {
            Text(store.state.topTitle)
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            Text("Fields marked with * are required.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.appBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            clubSelector

            ForEach(store.state.schema) { field in
                FieldSchemaRouter(
                    field: field,
                    values: Binding(
                        get: { store.state.values },
                        set: { store.state.values = $0 }
                    ),
                    selectedCategories: store.state.selectedCategories,
                    onAddCategory: { store.send(.addCategoryTapped) },
                    onRemoveCategory: { store.send(.removeCategory($0)) }
                )
            }
        }
    }

    private var clubSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 2) {
                Text("Club")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
                Text("*")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                store.send(.selectClubTapped)
            } label: {
                HStack {
                    Text(store.state.selectedClub?.clubName ?? "Select club")
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(
                            store.state.selectedClub == nil
                                ? Color.Palette.blackMedium
                                : Color.Palette.blackHigh
                        )

                    Spacer()

                    Image(uiImage: UIImage.Icons.chevronDown02)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackHigh)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.Palette.graySecondary, lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}
