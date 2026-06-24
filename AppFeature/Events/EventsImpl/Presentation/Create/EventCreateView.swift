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

    @State private var isScrolled = false
    @State private var baseHeight: CGFloat = 200

    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(.visible)
            .toolbarBackground(isScrolled ? .automatic : .hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(uiImage: UIImage.Icons.arrowLeft01)
                        .toolbarItemBackground(isScrolled: isScrolled) {
                            store.send(.backTapped)
                        }
                }
            }
            .onFirstAppear {
                store.send(.fetchData)
            }
            .enableSwipeBack()
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
                    selectedClubId: store.state.selectedClub?.clubId,
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

    // MARK: - Phase routing

    @ViewBuilder
    private var content: some View {
        switch store.state.clubsPhase {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed:
            centered {
                EventCreateErrorView { store.send(.retryTapped) }
            }
        case .empty:
            centered {
                EventCreateEmptyView(
                    onCreateClub: { store.send(.createClubTapped) },
                    onBrowseClubs: { store.send(.browseClubsTapped) }
                )
            }
        case .loaded:
            formView
        }
    }

    private func centered<Inner: View>(@ViewBuilder _ inner: () -> Inner) -> some View {
        VStack {
            Spacer()
            inner()
                .padding(.horizontal, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Form (eligible clubs available)

    private var formView: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        stretchableHeader
                        fieldView
                            .padding(.top, 20)
                            .padding(.bottom, 24)
                    }
                }
                .coordinateSpace(name: "scroll")

                AppButton(
                    title: "Continue",
                    model: .init(contentSize: .fill)
                ) {
                    store.send(.continueTapped)
                }
                .disabled(!store.state.isValid)
                .padding(.bottom, proxy.safeAreaInsets.bottom)
                .padding(.top)
                .padding(.horizontal)
            }
            .ignoresSafeArea(edges: .top)
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
                baseHeight = newValue / 4
            }
        }
    }

    // MARK: - Cover header (read-only club cover)

    private var stretchableHeader: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .named("scroll")).minY
            let pullDown = max(minY, 0)
            let height = baseHeight + pullDown
            let scale = 1 + (pullDown / 350)

            coverContent
                .frame(height: height)
                .scaleEffect(scale, anchor: .center)
                .clipped()
                .offset(y: minY > 0 ? -minY : 0)
                .onChange(of: minY) { newValue in
                    withAnimation {
                        isScrolled = newValue < -30
                    }
                }
        }
        .frame(height: baseHeight)
    }

    private var coverContent: some View {
        ZStack {
            CardBackgroundView(cardType: .club) {
                if let coverURL = store.state.selectedClub?.backgroundURL {
                    AsyncImage(url: coverURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        EmptyView()
                    }
                }
            }
            .backgroundType(store.state.selectedClub?.background ?? .primary)
            .cornerRadius(.zero)
        }
        .frame(maxWidth: .infinity)
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

            AppSelectorField(
                title: "Choose club",
                isRequired: true,
                imageURL: store.state.selectedClub?.profileURL,
                value: store.state.selectedClub?.clubName ?? "",
                placeholder: "Select club",
                isDisabled: store.state.isEdit,
                onTap: { store.send(.selectClubTapped) }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

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
                // Club + event name are immutable once the event exists.
                .disabled(store.state.isEdit && field.id == .eventName)
            }
        }
    }

}
