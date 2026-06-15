//
//  GroupsListModel.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppFoundation
import Events
import Combine
import Clubs
import Hangouts
import AppNetwork
import SwiftUI

// MARK: - GroupsList input

struct GroupsListInputData {
    let onDismiss: (() -> Void)?
}

// MARK: - Side effects

enum GroupsListSideEffect: UISideEffect {
    case loading(Bool)
    case error(APIError)
}

// MARK: - Feature Definition

typealias GroupsListFeature = UIFeatureDefinition<
    GroupsListViewState,
    GroupsListAction,
    GroupsListSideEffect
>

// MARK: - View State

final class GroupsListViewState: UIFeatureState {
    @Published var uiModel: UIModel = .init(
        events: [],
        clubs: [],
        hangouts: []
    )
    
    @Published var selectedSegment: SegmentType = .clubs
    @Published var searchText: String = ""
    
    func currentPageBinding() -> Binding<Int> {
        Binding { [self] in
            switch selectedSegment {
            case .clubs:
                return 0
            case .events:
                return 1
            case .hangouts:
                return 2
            }
        } set: { [self] newValue in
            switch newValue {
            case 0:
                selectedSegment = .clubs
            case 1:
                selectedSegment = .events
            case 2:
                selectedSegment = .hangouts
            default:
                break
            }
        }
    }
    
    struct UIModel {
        var events: [EventsModuleModel.CardInputData]
        var clubs: [ClubsModuleModel.CardInputData]
        var hangouts: [HangoutsModuleModel.CardInputData]
    }
    
    enum SegmentType: String, CaseIterable, Identifiable {
        case clubs = "Clubs"
        case events = "Events"
        case hangouts = "Hangouts"

        var id: Self { self }

        /// One-line explanation of what this tab lists.
        var caption: String {
            switch self {
            case .clubs:
                return "Clubs you belong to or run. Members organise events and meet up."
            case .events:
                return "Events you've joined or requested. Each one is hosted by a club."
            case .hangouts:
                return "Casual, one-off meetups — no club needed. Anyone can start one."
            }
        }

        /// Copy shown when this tab has no items.
        var emptyText: String {
            switch self {
            case .clubs:
                return "You haven't joined or created any clubs yet. Explore communities or start your own."
            case .events:
                return "No events yet. Join a club to discover its events, or request to attend one."
            case .hangouts:
                return "No hangouts yet. They're casual meetups — start one and invite friends."
            }
        }

        var emptyButtonTitle: String {
            switch self {
            case .clubs: return "Explore clubs"
            case .events: return "Explore events"
            case .hangouts: return "Start a hangout +"
            }
        }
    }
}

// MARK: - Feature Action

enum GroupsListAction: UIFeatureAction {
    case fetchData
    case loadMoreClubs
    case loadMoreHangouts
    case searchChanged(String)
    case clubItemTapped(id: Int)
    case eventItemTapped(id: String)
    case hangoutItemTapped(id: String)
}
