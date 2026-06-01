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
    @Environment(\.dismiss) var dismiss

    @ObservedObject var store: StoreOf<GroupsListFeature>
    private let onDismiss: (() -> Void)?

    private let clubsModule: ClubsModule
    private let eventsModule: EventsModule
    private let hangoutsModule: HangoutsModule
    
    private var searchTextBinding: Binding<String> {
        Binding(
            get: { store.state.searchText },
            set: { store.send(.searchChanged($0)) }
        )
    }

    // MARK: - Initialization
    
    init(
        store: StoreOf<GroupsListFeature>,
        onDismiss: (() -> Void)? = nil,
        clubsModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        hangoutsModule: HangoutsModule = resolve()
    ) {
        self.store = store
        self.onDismiss = onDismiss
        self.clubsModule = clubsModule
        self.eventsModule = eventsModule
        self.hangoutsModule = hangoutsModule
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            topView
            TabView(selection: store.state.currentPageBinding()) {
                clubsScrollView
                    .tag(0)
                eventsScrollView
                    .tag(1)
                hangoutsScrollView
                    .tag(2)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            store.send(.fetchData)
        }
        .animation(.easeInOut, value: store.state.selectedSegment)
        .navigationTitle("My activities")
        .ignoresSafeArea(edges: .bottom)
        .dismissKeyboardOnTap()
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Image(uiImage: UIImage.Icons.chevronDown02)
                    .toolbarItemBackground(
                        isScrolled: true
                    ) {
                        if let onDismiss {
                            onDismiss()
                        } else {
                            dismiss()
                        }
                    }
            }
        }
    }

    // MARK: - Top View

    @ViewBuilder
    private var topView: some View {
        VStack(spacing: 24) {
            searchAndSegmentView
        }
        .background(Color.Palette.white)
        .padding(.top,12)
    }

    private var searchAndSegmentView: some View {
        VStack(spacing: .zero) {
            SearchView(text: searchTextBinding)
                .padding(.horizontal)
            segmentView
        }
    }
    
    private var segmentView: some View {
        CapsuleSegmentedPicker(
            selection: Binding(
                get: { store.state.selectedSegment },
                set: { newValue in
                    withAnimation(.easeInOut) {
                        store.state.selectedSegment = newValue
                    }
                }
            )
        )
        .padding(.top)
        .padding(.horizontal)
    }
    
    // MARK: - Scroll Views
    
    @ViewBuilder
    private var clubsScrollView: some View {
        let clubs = store.state.uiModel.clubs
        
            ScrollView {
                if !clubs.isEmpty {
                VStack(spacing: 20) {
                    ForEach(Array(clubs.enumerated()), id: \.element.uuid) { index, club in
                        if let view = clubsModule.makeCardView(
                            inputData: club,
                            onTap: {
                                store.send(.clubItemTapped(id: club.id))
                            }
                        ) as? AnyView {
                            view
                                .onAppear {
                                    loadMoreClubsIfNeeded(index: index, count: clubs.count)
                                }
                        }
                    }
                }
                .padding()
            } else {
               emptyStateView(for: .clubs)
           }
        }
    }
    
    @ViewBuilder
    private var eventsScrollView: some View {
        let events = store.state.uiModel.events
        
        ScrollView {
            if !events.isEmpty {
                VStack(spacing: 20) {
                    ForEach(events, id: \.uuid) { event in
                        if let view = eventsModule.makeEventsCard(
                            model: event,
                            onTap: {
                                store.send(.eventItemTapped(id: event.id))
                            },
                            onButtonTap: { }
                        ) as? AnyView {
                            view
                        }
                    }
                }
                .padding()
            } else {
                emptyStateView(for: .events)
            }
        }
    }
    
    @ViewBuilder
    private var hangoutsScrollView: some View {
        let hangouts = store.state.uiModel.hangouts
        
        ScrollView {
            if !hangouts.isEmpty {
                VStack(spacing: 20) {
                    ForEach(Array(hangouts.enumerated()), id: \.element.uuid) { index, hangout in
                        if let view = hangoutsModule.makeHangoutsCard(
                            model: hangout,
                            onTap: {
                                store.send(.hangoutItemTapped(id: hangout.id))
                            },
                            onButtonTap: { }
                        ) as? AnyView {
                            view
                                .onAppear {
                                    loadMoreHangoutsIfNeeded(index: index, count: hangouts.count)
                                }
                        }
                    }
                }
                .padding()
            } else {
                emptyStateView(for: .hangouts)
            }
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
    
    private func loadMoreClubsIfNeeded(index: Int, count: Int) {
        guard count > 0, index == count - 1 else { return }
        store.send(.loadMoreClubs)
    }
    
    private func loadMoreHangoutsIfNeeded(index: Int, count: Int) {
        guard count > 0, index == count - 1 else { return }
        store.send(.loadMoreHangouts)
    }
}
