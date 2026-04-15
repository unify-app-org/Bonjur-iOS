//
//  AppTabBarHostController.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import UIKit
import Discover
import Clubs
import Groups
import Profile

final class AppTabBarHostController: UIViewController {

    private let viewModel: AppTabBarViewModel
    private let discoverModule: DiscoverModule
    private let clubsModule: ClubsModule
    private let groupsModule: GroupsModule
    private let profileModule: ProfileModule

    private lazy var discoverRootViewController: UIViewController = {
        discoverModule.makeDiscover(self) as! UIViewController
    }()

    private lazy var mainNavigationController: UINavigationController = {
        UINavigationController(rootViewController: discoverRootViewController)
    }()
    
    private let dockModel = FloatingDockModel()

    init(
        viewModel: AppTabBarViewModel,
        discoverModule: DiscoverModule,
        clubsModule: ClubsModule,
        groupsModule: GroupsModule,
        profileModule: ProfileModule
    ) {
        self.viewModel = viewModel
        self.discoverModule = discoverModule
        self.clubsModule = clubsModule
        self.groupsModule = groupsModule
        self.profileModule = profileModule
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        embedMainNavigation()
        mainNavigationController.delegate = self
        updateDockMode()
    }

    private func embedMainNavigation() {
        addChild(mainNavigationController)
        view.addSubview(mainNavigationController.view)

        mainNavigationController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainNavigationController.view.topAnchor.constraint(equalTo: view.topAnchor),
            mainNavigationController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainNavigationController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainNavigationController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        mainNavigationController.didMove(toParent: self)
    }
    
    private var isOnDashboard: Bool {
        mainNavigationController.viewControllers.count == 1
    }
    
    private func updateDockMode() {
        dockModel.mode = (isOnDashboard && !dockModel.isActivitiesPresented) ? .home : .away
        print(dockModel.mode)
    }
}

extension AppTabBarHostController: DiscoverModuleDelegate {

    func viewAllClubs() {
        let clubsViewController = clubsModule.makeClubsViewController() as! UIViewController
        mainNavigationController.pushViewController(clubsViewController, animated: true)
    }
}

extension AppTabBarHostController: UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        updateDockMode()
    }
}
