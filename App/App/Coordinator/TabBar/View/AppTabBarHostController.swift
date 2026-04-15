//
//  AppTabBarHostController.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import UIKit
import SwiftUI
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
    
    private lazy var dockHostingController: UIHostingController<FloatingDockRootView> = {
        let rootView = FloatingDockRootView(
            model: dockModel,
            onHomeTap: { [weak self] in
                self?.handleHomeTap()
            },
            onActivitiesTap: { [weak self] in
                self?.handleActivitiesTap()
            },
            onCreateTap: { [weak self] in
                self?.handleCreateTap()
            }
        )
        let controller = UIHostingController(rootView: rootView)
        controller.view.backgroundColor = .clear
        return controller
    }()

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
        embedDock()
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
    
    private func embedDock() {
        addChild(dockHostingController)
        view.addSubview(dockHostingController.view)
        
        dockHostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dockHostingController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dockHostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            dockHostingController.view.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            dockHostingController.view.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
        
        dockHostingController.didMove(toParent: self)
    }
    
    private var isOnDashboard: Bool {
        mainNavigationController.viewControllers.count == 1
    }
    
    private func updateDockMode() {
        dockModel.mode = (isOnDashboard && !dockModel.isActivitiesPresented) ? .home : .away
    }
    
    private func handleHomeTap() {
        mainNavigationController.popToRootViewController(animated: true)
    }
    
    private func handleActivitiesTap() {
        // Sheet presentation is added in the next step.
    }
    
    private func handleCreateTap() {
        // Native create sheet is added in the next step.
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
