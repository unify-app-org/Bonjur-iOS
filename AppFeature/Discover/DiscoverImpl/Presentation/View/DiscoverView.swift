//
//  DiscoverView.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Clubs
import Events
import Hangouts
import Communities

struct DiscoverView: View {
    @ObservedObject var store: StoreOf<DiscoverFeature>
    @State private var viewHeight: CGFloat = 110
    @State private var offset: CGFloat = 0
    @State private var currentCommunitiesPage = 0
    
    private let clubsModule: ClubsModule
    private let eventsModule: EventsModule
    private let hangoutsModule: HangoutsModule
    private let communitiesModule: CommunitiesModule

    init(
        store: StoreOf<DiscoverFeature>,
        viewHeight: CGFloat = 110,
        offset: CGFloat = 0,
        clubsModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        hangoutsModule: HangoutsModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.offset = offset
        self.viewHeight = viewHeight
        self.store = store
        self.clubsModule = clubsModule
        self.eventsModule = eventsModule
        self.hangoutsModule = hangoutsModule
        self.communitiesModule = communitiesModule
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
                    .padding(.vertical, 8)
                Spacer()
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
        .navigationBarHidden(true)
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
                headerTitle("Communities", type: .community)
                AppTabView(
                    currentPage: $currentCommunitiesPage,
                    pageCount: communities.count
                ) {
                    ForEach(Array(communities.enumerated()), id: \.element.uuid) { index, item in
                        if let view = communitiesModule.makeCommunityCard(
                            inputData: item,
                            onTap: {
                                
                            }
                        ) as? AnyView {
                            view
                                .frame(width: geometry.size.width - 32)
                                .padding(.horizontal)
                                .padding(.vertical)
                                .tag(index)
                        }
                    }
                }
                .frame(height: 200)
            }
        }
    }
    
    private func clubsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            let isEmpty = store.state.uiModel.clubs.isEmpty
            headerTitle("Clubs", viewAllVisible: !isEmpty, type: .clubs)
            if !isEmpty {
                let clubs = store.state.uiModel.clubs
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(clubs.enumerated()), id: \.element.uuid) { index, item in
                            if let view = clubsModule.makeCardView(
                                inputData: item,
                                onTap: {
                                    store.send(.clubItemOnTap(id: item.id))
                                }
                            ) as? AnyView {
                                view
                                    .frame(width: geometry.size.width - 60)
                                    .padding(.vertical)
                                    .id(index)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                emptyView(
                    icon: UIImage.Icons.twoUsers,
                    text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                    buttonTitle: "Create a club +",
                    type: .clubs
                )
                .padding()
            }
        }
    }
    
    private func emptyView(
        icon: UIImage,
        text: String,
        buttonTitle: String,
        type: AppUIEntities.ActivityType
    ) -> some View {
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

    private func eventsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            let uiModel = store.state.uiModel
            if !uiModel.events.isEmpty, !uiModel.clubs.isEmpty {
                let events = store.state.uiModel.events
                headerTitle("Events", type: .events)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(events.enumerated()), id: \.element.uuid) { index, item in
                            if let view = eventsModule.makeEventsCard(
                                model: item,
                                onTap: {
                                    
                                },
                                onButtonTap: {
                                    
                                }
                            ) as? AnyView {
                                view
                                    .frame(width: geometry.size.width - 90)
                                    .padding(.vertical)
                                    .id(index)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }

    private func hangoutsView(geometry: GeometryProxy) -> some View {
        VStack(spacing: 0) {
            let isEmpty = store.state.uiModel.hangouts.isEmpty
            headerTitle(
                "Hangouts",
                viewAllVisible: !isEmpty,
                type: .hangOuts
            )
            
            if !isEmpty {
                let hangouts = store.state.uiModel.hangouts
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(hangouts.enumerated()), id: \.element.uuid) { index, item in
                            if let view = hangoutsModule.makeHangoutsCard(
                                model: item,
                                onTap: {
                                    
                                },
                                onButtonTap: {
                                    
                                }
                            ) as? AnyView {
                                view
                                    .frame(width: geometry.size.width - 90)
                                    .padding(.vertical)
                                    .id(index)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                emptyView(
                    icon: UIImage.Icons.twoUsers,
                    text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                    buttonTitle: "Create a club +",
                    type: .hangOuts
                )
                .padding()
            }
        }
    }
    
    private func headerTitle(
        _ text: String,
        viewAllVisible: Bool = true,
        type: AppUIEntities.ActivityType
    ) -> some View {
        HStack {
            Text(text)
                .font(Font.Typography.TitleSm.semiBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
            if type != .community, viewAllVisible {
                Button {
                    store.send(.viewAllTapped(type))
                } label: {
                    Text("view all")
                        .font(Font.Typography.TextL.regular)
                        .foregroundStyle(Color.Palette.black)
                        .underline()
                }
            }
        }
        .padding(.trailing)
    }

    @ViewBuilder
    private var topView: some View {
        VStack(spacing: .zero) {
            profileView
                .padding(.horizontal)
            FilterView(
                model: store.state.uiModel.filters,
                selectedItems: { item in
                    // do
                }
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
                CachedAsyncImage(url: url) { image in
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
