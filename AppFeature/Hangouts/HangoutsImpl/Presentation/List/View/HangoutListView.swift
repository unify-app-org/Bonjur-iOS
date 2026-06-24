//
//  HangoutListView.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct HangoutListView: View {
    @ObservedObject var store: StoreOf<HangoutListFeature>
    @State private var viewHeight: CGFloat = 0

    private var searchTextBinding: Binding<String> {
        Binding(
            get: { store.state.searchText },
            set: { store.send(.searchChanged($0)) }
        )
    }

    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: .zero) {
                Color.clear
                    .frame(height: viewHeight)
                scrollView
            }
            VStack(spacing: .zero) {
                topView
                Spacer()
            }
        }
        .dismissKeyboardOnTap()
        .onAppear {
            store.send(.fetchData)
            store.send(.fetchCategories)
        }
    }
    
    @ViewBuilder
    private var scrollView: some View {
        let hangouts = store.state.uiModel.hangouts
        if !hangouts.isEmpty {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(hangouts.enumerated()), id: \.element.uuid) { index, item in
                        HangoutsCardView(model: item) {
                            
                        } onTap: {
                            store.send(.itemTapped(id: item.id))
                        }
                        .onAppear {
                            loadMoreIfNeeded(index: index, count: hangouts.count)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 55)
            }
        } else {
            AppEmptyView(
                model: .init(
                    icon: UIImage.Icons.twoUsers,
                    text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                    buttonTitle: "Create a club +"
                )
            ) {
                
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var topView: some View {
        VStack(spacing: 24) {
            Text("Hangouts")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            VStack(spacing: .zero) {
                SearchView(text: searchTextBinding)
                    .padding(.horizontal)
                FilterView(
                    model: store.state.uiModel.filters,
                    selectedItems: { items in
                        store.send(.filtersSelected(items))
                    }
                )
            }
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { newValue in
            self.viewHeight = newValue
        }
        .background(Color.Palette.white)
    }

    private func loadMoreIfNeeded(index: Int, count: Int) {
        guard count > 0, index == count - 1 else { return }
        store.send(.loadMore)
    }
}


struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
