//
//  AppTabBarHostController.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import UIKit
import AppFoundation
import SwiftUICore
import Discover

// MARK: - Controller

final class AppTabBarHostController: UITabBarController {
    
    private let viewModel: AppTabBarViewModel
    private var discoverModule: DiscoverModule
    
    private var isMenuOpen = false
    
    private let plusButton = UIButton(type: .custom)
    private let dimView = OverlayView()

    init(
        viewModel: AppTabBarViewModel,
        discoverModule: DiscoverModule
    ) {
        self.viewModel = viewModel
        self.discoverModule = discoverModule
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
        setupPlusButton()
        setupDimView()
        setUpCreateMenu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHighlightFrame()
    }
    
    private func setUpCreateMenu() {
        let createMenuView = CreateView { [weak self] type in
            guard let self else { return }
            selectedCreateType(type)
        }
        let createMenuUIView = createMenuView.makeUIView()
        dimView.addSubview(createMenuUIView)
        
        createMenuUIView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createMenuUIView.leadingAnchor.constraint(equalTo: dimView.leadingAnchor),
            createMenuUIView.trailingAnchor.constraint(equalTo: dimView.trailingAnchor),
            createMenuUIView.bottomAnchor.constraint(equalTo: plusButton.topAnchor, constant: -16)
        ])
    }
    
    private func setupDimView() {
        dimView.backgroundColor = .clear
        dimView.alpha = 0
        dimView.highlightCornerRadius = 22
        view.addSubview(dimView)
        
        dimView.onTapGesture = { [weak self] in
            guard let self else { return }
            isMenuOpen.toggle()
            animatePlusButtonToPlus()
            hideCreateMenu()
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
        let discover = discoverModule.makeDiscover()
        let clubs = makePlaceholderViewController(title: "Clubs")
        let spacer = UIViewController() // Spacer for the plus button
        let plans = makePlaceholderViewController(title: "My plans")
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
            title: "My plans",
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
        
        view.addSubview(plusButton)
        
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
        hideCreateMenu()
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
            animatePlusButtonToX()
            showCreateMenu()
        } else {
            animatePlusButtonToPlus()
            hideCreateMenu()
        }
    }
    
    private func animatePlusButtonToX() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
            guard let self else { return }
            self.plusButton.backgroundColor = .white
            self.plusButton.tintColor = .black
            self.plusButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
            self.dimView.alpha = 1
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
            self.dimView.alpha = 0
        } completion: { [weak self] _ in
            self?.updateHighlightFrame()
        }
    }
    
    private func updateHighlightFrame() {
        let buttonBounds = plusButton.bounds
        let buttonCenter = CGPoint(
            x: plusButton.frame.midX,
            y: plusButton.frame.midY
        )
        
        let highlightFrame = CGRect(
            x: buttonCenter.x - buttonBounds.width / 2,
            y: buttonCenter.y - buttonBounds.height / 2,
            width: buttonBounds.width,
            height: buttonBounds.height
        )
        
        dimView.highlightFrame = highlightFrame
    }
    
    private func showCreateMenu() {
        
    }
    
    private func hideCreateMenu() {
        dismiss(animated: true)
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
}
