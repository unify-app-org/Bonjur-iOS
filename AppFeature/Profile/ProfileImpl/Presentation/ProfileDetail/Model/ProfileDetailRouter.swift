//
//  ProfileDetailRouter.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import UIKit
import Events
import Hangouts
import Clubs
import Groups

enum ProfileDetailRoute {
    case clubsDetails(id: Int)
    case eventsDetails(id: String)
    case hangoutsDetails(id: String)
    case settings
    case activities
    case editProfile(EditProfileInputData)
    case studentCard(StudentCardInputData)
}

protocol ProfileDetailRouterProtocol {
    @MainActor
    func navigate(to route: ProfileDetailRoute)
}

final class ProfileDetailRouter: ProfileDetailRouterProtocol {
    weak var view: UIViewController?
    
    private var eventModule: EventsModule
    private var hangoutModule: HangoutsModule
    private var clubModule: ClubsModule
    private var groupsModule: GroupsModule

    init(
        view: UIViewController? = nil,
        eventModule: EventsModule = resolve(),
        hangoutModule: HangoutsModule = resolve(),
        clubModule: ClubsModule = resolve(),
        groupsModule: GroupsModule = resolve()
    ) {
        self.view = view
        self.eventModule = eventModule
        self.hangoutModule = hangoutModule
        self.clubModule = clubModule
        self.groupsModule = groupsModule
    }
    
    @MainActor
    func navigate(to route: ProfileDetailRoute) {
        switch route {
        case .editProfile(let inputData):
            let vc = EditProfileBuilder(
                inputData: inputData
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .clubsDetails(let clubId):
            let vc = clubModule.makeClubsDetailsVC(clubId: clubId) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .eventsDetails(let id):
            let vc = eventModule.makeEventsDetails(eventId: id) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .hangoutsDetails(let id):
            let vc = hangoutModule.makeHangoutDetails(hangoutId: id) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .settings:
            let vc = ProfileSettingsBuilder(inputData: .init()).build()
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .activities:
            let vc = groupsModule.makeGroups(
                inputData: .init(
                    onDismiss: { [weak view] in
                        view?.navigationController?.popViewController(animated: true)
                    }
                )
            ) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .studentCard(let inputData):
            let studentCardBuilder = StudentCardBuilder(inputData: inputData)
            let vc = studentCardBuilder.build()
            vc.modalPresentationStyle = .fullScreen
            self.view?.navigationController?.present(vc, animated: true)
        }
    }
}
