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
    @State private var offset: CGFloat = 0
    @State private var currentCommunitiesPage = 0
    
    private let clubsModule: ClubsModule
    private let eventsModule: EventsModule
    private let hangoutsModule: HangoutsModule
    private let communitiesModule: CommunitiesModule

    init(
        store: StoreOf<DiscoverFeature>,
        offset: CGFloat = 0,
        clubsModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        hangoutsModule: HangoutsModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.offset = offset
        self.store = store
        self.clubsModule = clubsModule
        self.eventsModule = eventsModule
        self.hangoutsModule = hangoutsModule
        self.communitiesModule = communitiesModule
    }

    var body: some View {
        VStack(spacing: 4) {
            filterView
            scrollView
        }
        .onFirstAppear {
            store.send(.fetchData)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                profileButton
            }
            if #available(iOS 26.0, *) {
                ToolbarItem(placement: .title) {
                    greetingView
                }.sharedBackgroundVisibility(.hidden)
            } else {
                ToolbarItem(placement: .topBarLeading) {
                    greetingView
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                bellButton
            }
        }
    }

    @ViewBuilder
    private var profileButton: some View {
        let url = URL(string: store.state.uiModel.user.profileImage ?? "")

        Button{
            store.send(.profileTapped)
        } label: {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .frame(width: 36, height: 36)
                    .scaledToFill()
                    .clipShape(Circle())
            } placeholder: {
                Image(systemName: "person")
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .toolbarItemBackground()
            }
        }
    }

    private var greetingView: some View {
        VStack(alignment: .center, spacing: 2) {
            Text(store.state.uiModel.user.greeting)
                .font(Font.Typography.TextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
            Text(store.state.uiModel.user.name)
                .font(Font.Typography.BodyTextMd.bold)
                .foregroundStyle(Color.Palette.black)
        }
        .fixedSize()
    }

    private var bellButton: some View {
        Image(uiImage: UIImage.Icons.bell)
            .toolbarItemBackground {
                
            }
    }

    private var filterView: some View {
        FilterView(
            model: store.state.uiModel.filters,
            selectedItems: { items in
                store.send(.filtersSelected(items))
            }
        )
        .background(Color.Palette.white)
    }
    
    private var scrollView: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVStack {
                    offsetReader
                    communitiesView(geometry: geometry)
                    clubsView(geometry: geometry)
                    eventsView(geometry: geometry)
                    hangoutsView(geometry: geometry)
                }
                .padding(.bottom, 55)
            }
            .coordinateSpace(name: "EndDetectionScrollView")
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                withAnimation {
                    offset = value
                }
            }
            .refreshable {
                store.send(.fetchData)
            }
            .clipped()
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

    @ViewBuilder
    private func communitiesView(geometry: GeometryProxy) -> some View {
        let communities = store.state.uiModel.communities
        
        activitySection(
            title: "Communities",
            type: .community,
            isEmpty: communities.isEmpty
        ) {
            AppTabView(
                currentPage: $currentCommunitiesPage,
                pageCount: communities.count
            ) {
                ForEach(Array(communities.enumerated()), id: \.element.uuid) { index, item in
                    if let view = communitiesModule.makeCommunityCard(
                        inputData: item,
                        onTap: {
                            store.send(.communityItemOnTap(id: item.id))
                        }
                    ) as? AnyView {
                        view
                            .frame(width: geometry.size.width - 32)
                            .padding(.horizontal)
                            .padding(.vertical)
                            .tag(index)
                            .onAppear {
                                loadMoreIfNeeded(index: index, count: communities.count, type: .community)
                            }
                    }
                }
            }
            .frame(height: 200)
        }
    }

    @ViewBuilder
    private func clubsView(geometry: GeometryProxy) -> some View {
        let clubs = store.state.uiModel.clubs
        
        activitySection(
            title: "Clubs",
            type: .clubs,
            isEmpty: clubs.isEmpty,
            emptyModel: .init(
                icon: UIImage.Icons.twoUsers,
                text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                buttonTitle: "Create a club +"
            )
        ) {
            horizontalCards(
                clubs,
                cardWidth: geometry.size.width - 60
            ) { item, _ in
                if let view = clubsModule.makeCardView(
                    inputData: item,
                    onTap: {
                        store.send(.clubItemOnTap(id: item.id))
                    }
                ) as? AnyView {
                    view
                }
            } onReachedEnd: {
                store.send(.loadMore(.clubs))
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
                icon: icon,
                text: text,
                buttonTitle: buttonTitle
            )
        ) {
            
        }
        .padding()
    }

    @ViewBuilder
    private func eventsView(geometry: GeometryProxy) -> some View {
        let uiModel = store.state.uiModel
        
        activitySection(
            title: "Events",
            type: .events,
            isEmpty: uiModel.events.isEmpty || uiModel.clubs.isEmpty,
            viewAllVisible: !uiModel.events.isEmpty,
            emptyModel: .init(
                icon: UIImage.Icons.twoUsers,
                text: "There are no event for the clubs yet. Be the pioneer and start the very first one now!",
                buttonTitle: "Create events +"
            )
        ) {
            horizontalCards(
                uiModel.events,
                cardWidth: geometry.size.width - 90
            ) { item, _ in
                if let view = eventsModule.makeEventsCard(
                    model: item,
                    onTap: {
                        store.send(.eventItemOnTap(id: item.id))
                    },
                    onButtonTap: {

                    },
                    onClubTap: { clubId in
                        store.send(.clubItemOnTap(id: clubId))
                    }
                ) as? AnyView {
                    view
                }
            } onReachedEnd: {
                store.send(.loadMore(.events))
            }
        }
    }

    @ViewBuilder
    private func hangoutsView(geometry: GeometryProxy) -> some View {
        let hangouts = store.state.uiModel.hangouts
        
        activitySection(
            title: "Hangouts",
            type: .hangOuts,
            isEmpty: hangouts.isEmpty,
            emptyModel: .init(
                icon: UIImage.Icons.twoUsers,
                text: "There are no hangouts for this community yet. Be the pioneer and start the very first one now!",
                buttonTitle: "Create hangouts +"
            )
        ) {
            horizontalCards(
                hangouts,
                cardWidth: geometry.size.width - 90
            ) { item, _ in
                if let view = hangoutsModule.makeHangoutsCard(
                    model: item,
                    onTap: {
                        store.send(.hangoutsItemOnTap(id: item.id))
                    },
                    onButtonTap: {
                        store.send(.joinHangout(id: item.id))
                    }
                ) as? AnyView {
                    view
                }
            } onReachedEnd: {
                store.send(.loadMore(.hangOuts))
            }
        }
    }

    @ViewBuilder
    private func activitySection<Content: View>(
        title: String,
        type: AppUIEntities.ActivityType,
        isEmpty: Bool,
        viewAllVisible: Bool? = nil,
        emptyModel: EmptySectionModel? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        if !isEmpty || emptyModel != nil {
            LazyVStack(spacing: 0) {
                headerTitle(
                    title,
                    viewAllVisible: viewAllVisible ?? !isEmpty,
                    type: type
                )
                
                if isEmpty {
                    if let emptyModel {
                        emptyView(
                            icon: emptyModel.icon,
                            text: emptyModel.text,
                            buttonTitle: emptyModel.buttonTitle,
                            type: type
                        )
                    }
                } else {
                    content()
                }
            }
        }
    }

    private func horizontalCards<Item, Content: View>(
        _ items: [Item],
        cardWidth: CGFloat,
        @ViewBuilder content: @escaping (Item, Int) -> Content,
        onReachedEnd: @escaping () -> Void
    ) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(items.indices, id: \.self) { index in
                    content(items[index], index)
                        .frame(width: cardWidth)
                        .padding(.vertical)
                        .id(index)
                        .onAppear {
                            loadMoreIfNeeded(index: index, count: items.count, onReachedEnd: onReachedEnd)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func loadMoreIfNeeded(
        index: Int,
        count: Int,
        type: AppUIEntities.ActivityType
    ) {
        loadMoreIfNeeded(index: index, count: count) {
            store.send(.loadMore(type))
        }
    }
    
    private func loadMoreIfNeeded(
        index: Int,
        count: Int,
        onReachedEnd: () -> Void
    ) {
        guard count > 0, index == count - 1 else { return }
        onReachedEnd()
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

    private struct EmptySectionModel {
        let icon: UIImage
        let text: String
        let buttonTitle: String
    }
}

struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
