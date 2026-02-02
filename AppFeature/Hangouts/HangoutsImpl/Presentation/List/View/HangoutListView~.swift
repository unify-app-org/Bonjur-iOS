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
        .onAppear {
            store.send(.fetchData)
        }
        .toolbar(.visible)
    }
    
    @ViewBuilder
    private var scrollView: some View {
        let hangouts = store.state.uiModel.hangouts
        if !hangouts.isEmpty {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(hangouts, id: \.uuid) { item in
                        HangoutsCardView(model: item) {
                            
                        } onTap: {
                            
                        }
                    }
                }
                .padding()
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
            Text("Events")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            VStack(spacing: .zero) {
                SearchView(text: .constant(""))
                    .padding(.horizontal)
                FilterView(
                    model: FilterView.Model.mock,
                    selectedItems: { item in
                        // do
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
}


struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
