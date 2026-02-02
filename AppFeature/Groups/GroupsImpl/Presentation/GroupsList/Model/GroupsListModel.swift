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
import SwiftUICore

// MARK: - GroupsList input

struct GroupsListInputData {
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
    }
}

// MARK: - Feature Action

enum GroupsListAction: UIFeatureAction {
    case fetchData
    case clubItemTapped(id: Int)
    case eventItemTapped(id: String)
    case hangoutItemTapped(id: String)
}
