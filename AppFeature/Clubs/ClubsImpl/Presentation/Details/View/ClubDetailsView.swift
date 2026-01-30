//
//  ClubDetailsView.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ClubDetailsView: View {
    @ObservedObject var store: StoreOf<ClubDetailsFeature>
    @State private var isScrolled = false
    @State private var isNameVisible = true
    @State private var isSegmentSticky = false
    private let baseHeight: CGFloat = 164
    private let navBarHeight: CGFloat = 100 // Approximate nav bar height
    
    // Test
    @State private var selectedSegment: SegmentTypes = .about
    
    init(store: StoreOf<ClubDetailsFeature>, isScrolled: Bool = false) {
        self.store = store
        self.isScrolled = isScrolled
        AppFonts()
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: .zero) {
                        stretchableHeader
                        logoView
                        bottomView
                        Color.clear.frame(height: 1000)
                    }
                }
                .coordinateSpace(name: "scroll")
                
                VStack(spacing: 0) {
                    customNavigationBar(safeAreaTop: proxy.safeAreaInsets.top)
                        .background(isScrolled ? Color.white : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: .zero))
                        .shadow(
                            color: isScrolled ? Color.black.opacity(0.1) : Color.clear,
                            radius: isScrolled ? 4 : 0,
                            x: 0,
                            y: isScrolled ? 2 : 0
                        )
                    
                    if isSegmentSticky {
                        segmentViewSticky
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: isScrolled)
                .animation(.easeInOut(duration: 0.2), value: isSegmentSticky)
            }
            .ignoresSafeArea()
            .toolbar(.hidden)
        }
    }
    
    // MARK: - Top Part
    private func customNavigationBar(safeAreaTop: CGFloat) -> some View {
        HStack {
            Button {
                // Back action
            } label: {
                navigationBarButton(uiImage: UIImage.Icons.arrowLeft01)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {
                    // More options action
                } label: {
                    navigationBarButton(uiImage: UIImage.Icons.ellipsis02)
                }
                
                if !isScrolled {
                    Button {
                        // Camera action
                    } label: {
                        navigationBarButton(uiImage: UIImage.Icons.camera)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaTop - 5)
        .overlay(
            Group {
                if !isNameVisible {
                    Text("Football club")
                        .font(Font.Typography.HeadingXl.bold)
                        .lineLimit(1)
                        .padding(.horizontal, 80)
                        .padding(.top, safeAreaTop - 16)
                }
            }
        )
    }
    
    private var stretchableHeader: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .named("scroll")).minY
            let pullDown = max(minY, 0)

            let height = baseHeight + pullDown
            let scale = 1 + (pullDown / 350)

            ZStack(alignment: .bottomLeading) {
                CardBackgroundView(cardType: .club) {
                    
                }
                .cornerRadius(.zero)
                .frame(height: height)
                .scaleEffect(scale, anchor: .center)
                .clipped()
            }
            .onChange(of: minY) { newValue in
                withAnimation {
                    isScrolled = newValue < -30
                }
            }
            .offset(y: minY > 0 ? -minY : 0)
        }
        .frame(height: baseHeight)
    }
    
    private func navigationBarButton(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .padding(10)
            .background(isScrolled ? Color.Palette.grayQuaternary :Color.Palette.whiteMedium)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 16)
    }
    
    private var logoView: some View {
        HStack(alignment: .lastTextBaseline) {
            CachedAsyncImage(url: URL(string: "")) { image in
                image
                    .resizable()
                    .frame(width: 88, height: 88)
            } placeholder: {
                if let image = UIImage(systemName: "person") {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .frame(width: 44, height: 44)
                }
            }
            .frame(width: 88, height: 88)
            .background(Color.Palette.grayQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 3)
            )
            .padding(.horizontal, 16)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    
                } label: {
                    Image(uiImage: UIImage.Icons.camera)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .padding(7)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.Palette.whiteHigh, lineWidth: 2)
                        )
                }
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.penLine)
            }
            .padding(.horizontal)
        }
        .padding(.top, -44)
        .padding(.bottom, 16)
    }
    
    
    // MARK: - Bottom part
    
    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            clubNameAndChipsView
            segmentView
        }
        .padding(.horizontal)
    }
    
    private var clubNameAndChipsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Football club")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    GeometryReader { geo in
                        Color.clear.onChange(of: geo.frame(in: .named("scroll")).minY) { newValue in
                            let isVisible = newValue > 0
                            withAnimation {
                                isNameVisible = isVisible
                            }
                        }
                    }
                )
            HStack(alignment: .center, spacing: 24) {
                let isPrivate = false
                Text(isPrivate ? "Private" : "Public")
                    .font(Font.Typography.TextSm.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundStyle(isPrivate ? Color.Palette.blackHigh : Color.Palette.whiteHigh)
                    .background(isPrivate ? Color.Palette.white : Color.Palette.blackHigh)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.Palette.blackHigh, lineWidth: 1)
                    )
                Button {
                    
                } label: {
                    Text("UFAZ community")
                        .font(Font.Typography.TextL.medium)
                        .foregroundStyle(Color.Palette.appBlue)
                        .underline()
                }
            }
            
            Text("161 members")
                .font(Font.Typography.TextMd.regular)
                .foregroundStyle(Color.Palette.blackHigh)
            
            chipsView
            
            AppButton(
                title: "Create new event +",
                model: .init(
                    type: .secondary,
                    contentSize: .fill
                )
            ) {
                
            }
        }
    }
    
    private var chipsView: some View {
        HStack(spacing: 8) {
            let array = ["test", "messi", "ronaldo", "neymar", "ronaldinho"]
            FlowLayout(items: array) { item in
                Text("#\(item.lowercased())")
                    .font(Font.Typography.TextSm.regular)
                    .lineLimit(1)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(Capsule())
            }
        }
    }
    
    @ViewBuilder
    private var segmentView: some View {
        CapsuleSegmentedPicker(
            selection: Binding(
                get: { selectedSegment },
                set: { newValue in
                    withAnimation(.easeInOut) {
                        selectedSegment = newValue
                    }
                }
            )
        )
        .padding(.top)
        .background(Color.white)
        .opacity(isSegmentSticky ? 0 : 1)
        .background(
            GeometryReader { geo in
                Color.clear.onChange(of: geo.frame(in: .named("scroll")).minY) { newValue in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSegmentSticky = newValue <= navBarHeight
                    }
                }
            }
        )
    }
    
    @ViewBuilder
    private var segmentViewSticky: some View {
        CapsuleSegmentedPicker(
            selection: Binding(
                get: { selectedSegment },
                set: { newValue in
                    withAnimation(.easeInOut) {
                        selectedSegment = newValue
                    }
                }
            )
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Color.white
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 4,
                    x: 0,
                    y: 2
                )
        )
        .mask(
            Rectangle()
                .padding(.bottom, -10)
        )
    }
}

enum SegmentTypes: String, CaseIterable, Identifiable {
    case about = "About"
    case events = "Events"
    case members = "Members"
    
    var id: Self { self }
}

#Preview {
    NavigationStack {
        ClubDetailsView(store: .init(state: .init()))
    }
}
