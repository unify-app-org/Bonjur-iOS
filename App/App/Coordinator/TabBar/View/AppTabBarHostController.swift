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
    private let plusButton = UIButton(type: .custom)
    private let dimView = OverlayView()
    private var isMenuOpen = false
    
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHighlightFrame()
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

final class OverlayView: UIView {
    var highlightFrame: CGRect = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var highlightCornerRadius: CGFloat = 0 // Add this property
    
    var onTapGesture: (() -> Void)?
    var allowTapToAdvance: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard allowTapToAdvance else { return }
        
        let location = gesture.location(in: self)
        
        // Check if tap is outside the circular/rounded highlight area
        if !isPointInHighlightArea(location) {
            onTapGesture?()
        }
    }
    
    private func isPointInHighlightArea(_ point: CGPoint) -> Bool {
        let path = UIBezierPath(
            roundedRect: highlightFrame,
            cornerRadius: highlightCornerRadius
        )
        return path.contains(point)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Fill the entire view with dark overlay
        context.setFillColor(UIColor(Color.Palette.blackHigh).withAlphaComponent(0.4).cgColor)
        context.fill(rect)
        
        // Clear the highlight area with rounded corners
        context.setBlendMode(.clear)
        
        let highlightPath = UIBezierPath(
            roundedRect: highlightFrame,
            cornerRadius: highlightCornerRadius
        )
        highlightPath.fill()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Allow touches through the circular/rounded highlight area
        if isPointInHighlightArea(point) {
            return nil
        }
        
        return super.hitTest(point, with: event)
    }
}
