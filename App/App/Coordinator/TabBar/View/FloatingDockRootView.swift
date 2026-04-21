//
//  FloatingDockRootView.swift
//  App
//
//  Created by Codex on 15.04.26.
//

import SwiftUI
import UIKit
import AppUIKit

struct FloatingDockRootView: View {
    @ObservedObject var model: FloatingDockModel
    
    let onHomeTap: () -> Void
    let onActivitiesTap: () -> Void
    let makeActivitiesNavigationController: () -> UINavigationController
    let onCreateTap: () -> Void
    let onCreateSelected: (CreateType) -> Void
    
    @State private var activitiesButtonSize = CGSize(width: 120, height: 44)
    @State private var measuredSideButtonSize = CGSize(width: 46, height: 46)
    
    private let sideButtonSize: CGFloat = 46
    private let horizontalSpacing: CGFloat = 12
    
    private let homeSlideAnimation = Animation.spring(duration: 0.3, bounce: 0.4, blendDuration: 0.4)
 
    private let badgeAnimation = Animation.spring(response: 0.34, dampingFraction: 0.68)
    
    private var sideButtonOffset: CGFloat {
        (activitiesButtonSize.width / 2) + horizontalSpacing + (measuredSideButtonSize.width / 2)
    }
    
    private var dockWidth: CGFloat {
        activitiesButtonSize.width + (measuredSideButtonSize.width * 2) + (horizontalSpacing * 2)
    }
    
    private var dockHeight: CGFloat {
        max(activitiesButtonSize.height, measuredSideButtonSize.height)
    }
    
    var body: some View {
        dockContent
        .appSwipeableSheet(
            ignoresSafeArea: true,
            isPresented: $model.isActivitiesPresented
        ) { _ in
            ActivitiesNavigationControllerHost(
                makeNavigationController: makeActivitiesNavigationController
            )
            .ignoresSafeArea()
        } background: {
            Color.Palette.white
                .ignoresSafeArea()
        }
        .appSheet(
            isPresented: $model.isCreatePresented,
            detents: [.fraction(0.4)],
            dragIndicator: .visible
        ) {
            CreateView { type in
                model.isCreatePresented = false
                onCreateSelected(type)
            }
        }
    }
    
    private var dockContent: some View {
        ZStack {
            homeButton
            
            activitiesButton
              
            plusButton
                .offset(x: sideButtonOffset)
                
        }
        .frame(width: dockWidth, height: dockHeight,alignment: .bottom)
        .padding(8)
        .animation(badgeAnimation, value: model.badgeCount)
    }
    
    private var homeButton: some View {
        dockCircleButton(
            image: UIImage.Icons.home,
            action: onHomeTap
        )
        .offset(
            x: model.mode == .away ? -sideButtonOffset : 0,
            y: 0
        )
        .rotationEffect(.degrees(model.mode == .away ? 0 : 8),anchor: .bottomLeading)
        .opacity(model.mode == .away ? 1.0 : 0.0)
        .allowsHitTesting(model.mode == .away)
        .animation(
            homeSlideAnimation,
            value: model.mode
        )
    }
    
    private var plusButton: some View {
        dockCircleButton(
            image: UIImage.Icons.plus,
            action: onCreateTap
        )
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            measuredSideButtonSize = newValue
        }
    }
    
    private var activitiesButton: some View {
        Button(action: onActivitiesTap) {
            HStack(spacing: 10) {
                Image(uiImage: UIImage.Icons.clipboardList)
                    .renderingMode(.template)
                   
                
                Text("My plans")
                    .font(Font.Typography.BodyTextSm.medium)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .fixedSize(horizontal: true, vertical: false)
            .background(Color.Palette.black, in: Capsule())
            .foregroundStyle(Color.Palette.white)
            .overlay(alignment: .topTrailing) {
                if model.badgeCount > 0 {
                    badgeView(count: model.badgeCount)
                        .offset(x: 6, y: -6)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .buttonStyle(.plain)
       
        .onGeometryChange(for: CGSize.self) { proxy in
            proxy.size
        } action: { newValue in
            activitiesButtonSize = newValue
        }
    }

    private func dockCircleButton(
        image: UIImage,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.template)
                .frame(width: 22, height: 22)
                .frame(width: sideButtonSize, height: sideButtonSize)
                .background(Color.Palette.black, in: Circle())
                .foregroundStyle(Color.Palette.white)
             
        }
        .buttonStyle(.plain)
    }
    
    private func badgeView(count: Int) -> some View {
        Text("\(count)")
            .font(Font.Typography.CaptionSm.medium)
            .foregroundStyle(Color.Palette.white)
            .padding(.horizontal, 7)
            .padding(.vertical, 4)
            .background(Color.Palette.cardBgRed, in: Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Palette.white, lineWidth: 1.5)
            )
    }
}

#Preview("Home") {
    let model = FloatingDockModel()
    return ZStack {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
        
        VStack {
            Spacer()
            FloatingDockRootView(
                model: model,
                onHomeTap: {},
                onActivitiesTap: {},
                makeActivitiesNavigationController: { UINavigationController() },
                onCreateTap: {},
                onCreateSelected: { _ in }
            )
        }
        .padding(.bottom, 24)
    }
}

#Preview("Away With Badge") {
    let model = FloatingDockModel()
    model.mode = .away
    model.joinedEventsCount = 2
    model.joinedHangoutsCount = 3
    
    return ZStack {
        LinearGradient(
            colors: [
                Color(.systemYellow).opacity(0.35),
                Color(.systemBackground)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack {
            Spacer()
            FloatingDockRootView(
                model: model,
                onHomeTap: {},
                onActivitiesTap: {},
                makeActivitiesNavigationController: { UINavigationController() },
                onCreateTap: {},
                onCreateSelected: { _ in }
            )
        }
        .padding(.bottom, 24)
    }
}

private struct ActivitiesNavigationControllerHost: UIViewControllerRepresentable {
    let makeNavigationController: () -> UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        makeNavigationController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}
