//
//  DiscoverView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct DiscoverView: View {
    @ObservedObject var store: StoreOf<DiscoverFeature>
    @State private var viewHeight: CGFloat = 110
    @State private var offset: CGFloat = 0
    
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
    }
    
    private var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    offsetReader
                    communitiesView(geometry: geometry)
                    clubsView(geometry: geometry)
                    eventsView(geometry: geometry)
                    hangoutsView(geometry: geometry)
                }
            }
            .coordinateSpace(name: "EndDetectionScrollView")
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                withAnimation {
                    offset = value
                }
            }
        }
    }
    
    var offsetReader: some View {
          GeometryReader { proxy in
              Color.clear
                  .preference(
                      key: OffsetPreferenceKey.self,
                      value: proxy.frame(in: .named("EndDetectionScrollView")).maxY
                  )
          }
          .frame(height: 0)
    }
    
    private func communitiesView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if !store.state.uiModel.communities.isEmpty {
                let communities = store.state.uiModel.communities
                headerTitle("Communities")
                AppTabView(
                    currentPage: $store.state.currentCommunitiesPage,
                    pageCount: communities.count
                ) {
                    ForEach(Array(communities.enumerated()), id: \.element.uuid) { index, item in
                        CommunityCardView(model: item) { item in
                            
                        }
                        .frame(width: geometry.size.width - 32)
                        .padding(.horizontal)
                        .padding(.vertical)
                        .tag(index)
                    }
                }
                .frame(height: 200)
            }
        }
    }
    
    private func clubsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if !store.state.uiModel.clubs.isEmpty {
                let clubs = store.state.uiModel.clubs
                headerTitle("Clubs")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(clubs.enumerated()), id: \.element.uuid) { index, item in
                            ClubCardView(model: item) { item in
                                
                            }
                            .frame(width: geometry.size.width - 60)
                            .padding(.vertical)
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private func eventsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if !store.state.uiModel.events.isEmpty {
                let events = store.state.uiModel.events
                headerTitle("Events")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(events.enumerated()), id: \.element.uuid) { index, item in
                            EventsCardView(
                                model: item,
                                onButtonTap: { accessType, requestType in
                                    
                                }, onTap: { item in
                                    
                                }
                            )
                            .frame(width: geometry.size.width - 90)
                            .padding(.vertical)
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private func hangoutsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            if !store.state.uiModel.hangouts.isEmpty {
                let hangouts = store.state.uiModel.hangouts
                headerTitle("Hangouts")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(hangouts.enumerated()), id: \.element.uuid) { index, item in
                            HangoutsCardView(
                                model: item,
                                onButtonTap: { accessType, requestType in
                                    
                                }, onTap: { item in
                                    
                                }
                            )
                            .frame(width: geometry.size.width - 90)
                            .padding(.vertical)
                            .id(index)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
    
    private func headerTitle(_ text: String) -> some View {
        Text(text)
            .font(Font.Typography.TitleSm.semiBold)
            .foregroundStyle(Color.Palette.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .padding(.horizontal)
    }

    @ViewBuilder
    private var topView: some View {
        VStack(spacing: .zero) {
            profileView
                .padding(.horizontal)
            FilterView(
                viewModel: .init(
                    model: store.state.uiModel.filters,
                    selectedItems: { item in
                        // do
                    }
                )
            )
        }
        .onGeometryChange(for: CGFloat.self) { proxy in
            proxy.size.height
        } action: { newValue in
            self.viewHeight = newValue
        }
        .background(Color.Palette.white)
    }
    
    private var profileView: some View {
        HStack {
            let url = URL(string: store.state.uiModel.user.profileImage ?? "")
            Button {
                
            } label: {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 40, height: 40)
                } placeholder: {
                    Image(systemName: "person")
                        .frame(width: 24, height: 24)
                        .padding(12)
                        .foregroundStyle(Color.Palette.black)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            
            VStack(spacing: 4) {
                Text(store.state.uiModel.user.greeting)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.grayPrimary)
                Text(store.state.uiModel.user.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .font(Font.Typography.BodyTextSm.medium)
                    .foregroundStyle(Color.Palette.black)
            }
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.bell)
                    .frame(width: 24, height: 24)
                    .padding(12)
                    .foregroundStyle(Color.Palette.graySecondary)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
