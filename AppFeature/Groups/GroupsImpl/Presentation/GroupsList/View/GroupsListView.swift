//
//  GroupsListView.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Hangouts
import Events
import Clubs

struct GroupsListView: View {
    
    // MARK: - Properties
    
    @ObservedObject var store: StoreOf<GroupsListFeature>
    
    private let clubsModule: ClubsModule
    private let eventsModule: EventsModule
    private let hangoutsModule: HangoutsModule
    
    // MARK: - Initialization
    
    init(
        store: StoreOf<GroupsListFeature>,
        clubsModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        hangoutsModule: HangoutsModule = resolve()
    ) {
        self.store = store
        self.clubsModule = clubsModule
        self.eventsModule = eventsModule
        self.hangoutsModule = hangoutsModule
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            topView
            scrollView
        }
        .onAppear {
            store.send(.fetchData)
        }
        .toolbar(.hidden)
    }
    
    // MARK: - Content Views
    
    @ViewBuilder
    private var scrollView: some View {
        switch store.state.selectedSegment {
        case .clubs:
            clubsScrollView
        case .events:
            eventsScrollView
        case .hangouts:
            hangoutsScrollView
        }
    }
    
    // MARK: - Top View
    
    @ViewBuilder
    private var topView: some View {
        VStack(spacing: 24) {
            titleView
            searchAndSegmentView
        }
        .background(Color.Palette.white)
    }
    
    private var titleView: some View {
        VStack {
            Text("Groups")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
    
    private var searchAndSegmentView: some View {
        VStack(spacing: .zero) {
            SearchView(text: .constant(""))
                .padding(.horizontal)
            segmentView
        }
    }
    
    private var segmentView: some View {
        CapsuleSegmentedPicker(
             selection: $store.state.selectedSegment
         )
        .padding(.top)
        .padding(.horizontal)
    }
    
    // MARK: - Scroll Views
    
    @ViewBuilder
    private var clubsScrollView: some View {
        let clubs = store.state.uiModel.clubs
        
        if !clubs.isEmpty {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(clubs, id: \.uuid) { club in
                        if let view = clubsModule.makeCardView(
                            inputData: club,
                            onTap: { }
                        ) as? AnyView {
                            view
                        }
                    }
                }
                .padding()
            }
        } else {
            emptyStateView(for: .clubs)
        }
    }
    
    @ViewBuilder
    private var eventsScrollView: some View {
        let events = store.state.uiModel.events
        
        if !events.isEmpty {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(events, id: \.uuid) { event in
                        if let view = eventsModule.makeEventsCard(
                            model: event,
                            onTap: { },
                            onButtonTap: { }
                        ) as? AnyView {
                            view
                        }
                    }
                }
                .padding()
            }
        } else {
            emptyStateView(for: .events)
        }
    }
    
    @ViewBuilder
    private var hangoutsScrollView: some View {
        let hangouts = store.state.uiModel.hangouts
        
        if !hangouts.isEmpty {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(hangouts, id: \.uuid) { hangout in
                        if let view = hangoutsModule.makeHangoutsCard(
                            model: hangout,
                            onTap: { },
                            onButtonTap: { }
                        ) as? AnyView {
                            view
                        }
                    }
                }
                .padding()
            }
        } else {
            emptyStateView(for: .hangouts)
        }
    }
    
    // MARK: - Empty State
    
    private func emptyStateView(for segmentType: GroupsListViewState.SegmentType) -> some View {
        AppEmptyView(
            model: .init(
                icon: UIImage.Icons.twoUsers,
                text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                buttonTitle: "Create a club +"
            )
        ) { }
        .padding()
    }
}
