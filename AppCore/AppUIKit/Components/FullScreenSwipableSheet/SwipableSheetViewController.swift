//
//  SwipableSheetViewController.swift
//  AppCore
//
//  Created by aplle on 4/19/26.
//
import SwiftUI
import UIKit

class SwipableSheetViewController<Content: View, Background: View>: UIViewController, UIGestureRecognizerDelegate {

    var ignoresSafeArea: Bool
    var content: Content
    var background: Background
    var isPresented: Binding<Bool>

    private var hostingController: UIHostingController<Content>!
    private var backgroundController: UIHostingController<Background>!

    private let containerView = UIView()
    private let backgroundContainer = UIView()

    private var scrollLocked = false
    init(
        ignoresSafeArea: Bool,
        isPresented: Binding<Bool>,
        content: Content,
        background: Background
    ) {
        self.ignoresSafeArea = ignoresSafeArea
        self.isPresented = isPresented
        self.content = content
        self.background = background
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear

        setupBackground()
        setupContent()
        setupGesture()
    }

    // MARK: - Setup Background

    private func setupBackground() {
        backgroundController = UIHostingController(rootView: background)
        backgroundController.view.backgroundColor = .clear

        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(backgroundContainer)
        backgroundContainer.addSubview(backgroundController.view)

        NSLayoutConstraint.activate([
            backgroundContainer.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backgroundController.view.topAnchor.constraint(equalTo: backgroundContainer.topAnchor),
            backgroundController.view.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor),
            backgroundController.view.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor),
            backgroundController.view.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor)
        ])
    }

    // MARK: - Setup Content

    private func setupContent() {
        hostingController = UIHostingController(rootView: content)
        hostingController.view.backgroundColor = .clear

        containerView.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        containerView.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            hostingController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }

    // MARK: - Gesture

    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        pan.delegate = self
        containerView.addGestureRecognizer(pan)
    }
    private func setScrollLocked(_ locked: Bool) {
        guard let root = hostingController?.view else { return }

        findScrollViews(in: root).forEach {
            $0.isScrollEnabled = !locked
            $0.panGestureRecognizer.isEnabled = !locked
        }
    }
    private func findScrollViews(in view: UIView) -> [UIScrollView] {
        var scrollViews = [UIScrollView]()
        var stack = [view] // Iterative stack to avoid recursion overhead
        
        while !stack.isEmpty {
            let currentView = stack.removeLast()
            
            if let scrollView = currentView as? UIScrollView {
                scrollViews.append(scrollView)
            }
            
            // Add subviews to stack to continue searching
            stack.append(contentsOf: currentView.subviews)
        }
        
        return scrollViews
    }
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {

        let translation = min(
            max(gesture.translation(in: view).y, 0),
            view.bounds.height
        )

        let velocity = min(
            max(gesture.velocity(in: view).y, 0),
            view.bounds.height / 2
        )

        let halfHeight = view.bounds.height / 2

        switch gesture.state {

        case .began:
            scrollLocked = true
            setScrollLocked(true)

        case .changed:
            guard scrollLocked else { return }

            let transform = CGAffineTransform(translationX: 0, y: translation)
            containerView.transform = transform
            backgroundContainer.transform = transform

        case .ended, .cancelled, .failed:

            gesture.isEnabled = false // 🔥 same as SwiftUI

            if (translation + velocity) > halfHeight {

                // DISMISS
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                    let transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                    self.containerView.transform = transform
                    self.backgroundContainer.transform = transform
                } completion: { _ in
                    self.isPresented.wrappedValue = false
                }

            } else {

                // RESET
                UIView.animate(
                    withDuration: 0.3,
                    delay: 0,
                    usingSpringWithDamping: 1.0,
                    initialSpringVelocity: 0
                ) {
                    self.containerView.transform = .identity
                    self.backgroundContainer.transform = .identity
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.scrollLocked = false
                    self.setScrollLocked(false)
                    gesture.isEnabled = true
                }
            }

        default:
            break
        }
    }

    // MARK: - Animations

    private func animateDismiss() {
        let height = view.bounds.height

        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            let transform = CGAffineTransform(translationX: 0, y: height)
            self.containerView.transform = transform
            self.backgroundContainer.transform = transform
        } completion: { _ in
            self.isPresented.wrappedValue = false
        }
    }

    private func animateReset() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.85,
            initialSpringVelocity: 0
        ) {
            self.containerView.transform = .identity
            self.backgroundContainer.transform = .identity
        }
    }

    // MARK: - Scroll + Swipe

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool {

        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else { return false }

        let velocity = pan.velocity(in: pan.view).y
        var offset: CGFloat = 0

        if let cv = other.view as? UICollectionView {
            offset = cv.contentOffset.y + cv.adjustedContentInset.top
        } else if let sv = other.view as? UIScrollView {
            offset = sv.contentOffset.y + sv.adjustedContentInset.top
        }

        return Int(offset) <= 1 && velocity > 0
    }
}
