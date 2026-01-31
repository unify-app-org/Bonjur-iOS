//
//  AppTabBarHostController.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import UIKit
import AppFoundation
import SwiftUICore
import Discover
import Clubs
import Groups

// MARK: - Controller

final class AppTabBarHostController: UITabBarController {
    
    private let viewModel: AppTabBarViewModel
    private var discoverModule: DiscoverModule
    private var clubsModule: ClubsModule
    private var groupsModule: GroupsModule

    private var isMenuOpen = false
    
    private let plusButton = UIButton(type: .custom)
    private var dimView: OverlayView?
    private var createMenuView: CreateView?
    private var createMenuUIView: UIView?

    init(
        viewModel: AppTabBarViewModel,
        discoverModule: DiscoverModule,
        clubsModule: ClubsModule,
        groupsModule: GroupsModule
    ) {
        self.viewModel = viewModel
        self.discoverModule = discoverModule
        self.clubsModule = clubsModule
        self.groupsModule = groupsModule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabs()
        setupAppearance()
        setupPlusButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHighlightFrame()
    }
    
    private func setUpCreateMenu() {
        createMenuView = CreateView { [weak self] type in
            guard let self else { return }
            selectedCreateType(type)
        }
        guard let dimView, let createMenuView else { return }
        let menuUIView = createMenuView.makeUIView()
        self.createMenuUIView = menuUIView
        dimView.addSubview(menuUIView)
        
        menuUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuUIView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            menuUIView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            menuUIView.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: -16)
        ])
    }
    
    private func setupDimView() {
        dimView = OverlayView()
        guard let dimView else { return }
        dimView.backgroundColor = .clear
        dimView.alpha = 0
        dimView.highlightCornerRadius = 22
        view.addSubview(dimView)
        
        dimView.onTapGesture = { [weak self] in
            guard let self else { return }
            isMenuOpen.toggle()
            animatePlusButtonToPlus()
        }
        
        dimView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTabs() {
        let discoverVC = discoverModule.makeDiscover(self) as! UIViewController
        let discover = UINavigationController(rootViewController: discoverVC)
        
        let clubsVC = clubsModule.makeClubsViewController() as! UIViewController
        let clubs = UINavigationController(rootViewController: clubsVC)
        
        let spacer = UIViewController()
        
        let plansVC = groupsModule.makeGroups() as! UIViewController
        let plans = UINavigationController(rootViewController: plansVC)

        let profile = makePlaceholderViewController(title: "Profile")
        
        discover.tabBarItem = makeTabBarItem(
            title: "Discover",
            icon: UIImage.Icons.home
        )
        
        clubs.tabBarItem = makeTabBarItem(
            title: "Clubs",
            icon: UIImage.Icons.usersGroup
        )
        
        spacer.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 0)
        spacer.tabBarItem.isEnabled = false
        
        plans.tabBarItem = makeTabBarItem(
            title: "Groups",
            icon: UIImage.Icons.clipboardList
        )
        
        profile.tabBarItem = makeTabBarItem(
            title: "Profile",
            icon: UIImage.Icons.userIcon
        )
        
        viewControllers = [
            discover,
            clubs,
            spacer,
            plans,
            profile
        ]
    }
    
    private func setupPlusButton() {
        plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        plusButton.backgroundColor = .black
        plusButton.tintColor = .white
        plusButton.layer.cornerRadius = 22
        
        plusButton.addTarget(
            self,
            action: #selector(plusTapped),
            for: .touchUpInside
        )
        
        tabBar.addSubview(plusButton)
        
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: tabBar.centerYAnchor, constant: -16),
            plusButton.widthAnchor.constraint(equalToConstant: 44),
            plusButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func selectedCreateType(_ type: CreateType) {
        isMenuOpen.toggle()
        animatePlusButtonToPlus()
        switch type {
        case .club:
            break
        case .event:
            break
        case .hangout:
            break
        }
    }
    
    @objc
    private func plusTapped() {
        isMenuOpen.toggle()
        
        if isMenuOpen {
            setupDimView()
            setUpCreateMenu()
            animatePlusButtonToX()
        } else {
            animatePlusButtonToPlus()
        }
    }
    
    private func preloadTabViews() {
        viewControllers?.forEach { _ = $0.view }
    }
    
    private func animatePlusButtonToX() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            self.plusButton.backgroundColor = .white
            self.plusButton.tintColor = .black
            self.plusButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
            self.dimView?.alpha = 1
        } completion: { [weak self] _ in
            self?.updateHighlightFrame()
        }
    }
    
    private func animatePlusButtonToPlus() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            self.plusButton.backgroundColor = .black
            self.plusButton.tintColor = .white
            self.plusButton.transform = .identity
            self.dimView?.alpha = 0
        } completion: { [weak self] _ in
            self?.createMenuUIView?.removeFromSuperview()
            self?.dimView?.removeFromSuperview()
            
            self?.createMenuUIView = nil
            self?.createMenuView = nil
            self?.dimView = nil
            
            self?.updateHighlightFrame()
        }
    }
    
    private func updateHighlightFrame() {
        guard let dimView = dimView else { return }
        
        let buttonFrameInDimView = tabBar.convert(plusButton.frame, to: dimView)
        
        let highlightFrame = CGRect(
            x: buttonFrameInDimView.midX - plusButton.bounds.width / 2,
            y: buttonFrameInDimView.midY - plusButton.bounds.height / 2,
            width: plusButton.bounds.width,
            height: plusButton.bounds.height
        )
        
        dimView.highlightFrame = highlightFrame
    }
    
    private func setupAppearance() {
        tabBar.tintColor = UIColor(Color.Palette.blackHigh)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private func makeTabBarItem(title: String, icon: UIImage) -> UITabBarItem {
        UITabBarItem(
            title: title,
            image: icon,
            selectedImage: icon
        )
    }
    
    private func makePlaceholderViewController(title: String) -> UIViewController {
        let vc = UIViewController()
        vc.view.backgroundColor = .white
        
        let label = UILabel()
        label.text = title
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        vc.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        return vc
    }
    
    private func switchToTab(_ index: Int, animated: Bool = true) {
        guard
            let viewControllers,
            index < viewControllers.count,
            index != selectedIndex
        else { return }
        
        if !animated {
            selectedIndex = index
            return
        }
        
        let toIndex = index
        
        selectedIndex = toIndex
        
        UIView.transition(
            with: view,
            duration: 0.25,
            options: [.transitionCrossDissolve, .allowAnimatedContent],
            animations: nil,
            completion: nil
        )
    }
}

extension AppTabBarHostController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {

        guard
            let fromVC = selectedViewController,
            fromVC !== viewController
        else { return false }

        UIView.transition(
            from: fromVC.view,
            to: viewController.view,
            duration: 0.25,
            options: [.transitionCrossDissolve],
            completion: nil
        )

        return true
    }
}

extension AppTabBarHostController: DiscoverModuleDelegate {
    
    func viewAllClubs() {
        switchToTab(1)
    }
}
