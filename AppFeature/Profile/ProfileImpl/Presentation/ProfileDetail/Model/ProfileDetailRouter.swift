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

enum ProfileDetailRoute {
    case clubsDetails(id: Int)
    case eventsDetails(id: String)
    case hangoutsDetails(id: String)
    case settings
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
    
    init(
        view: UIViewController? = nil,
        eventModule: EventsModule = resolve(),
        hangoutModule: HangoutsModule = resolve(),
        clubModule: ClubsModule = resolve()
    ) {
        self.view = view
        self.eventModule = eventModule
        self.hangoutModule = hangoutModule
        self.clubModule = clubModule
    }
    
    @MainActor
    func navigate(to route: ProfileDetailRoute) {
        switch route {
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
        case .studentCard(let inputData):
            let studentCardBuilder = StudentCardBuilder(inputData: inputData)
            let vc = studentCardBuilder.build()
            vc.modalPresentationStyle = .fullScreen
            self.view?.navigationController?.present(vc, animated: true)
        }
    }
}
