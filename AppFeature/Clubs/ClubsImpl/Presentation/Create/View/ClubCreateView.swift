//
//  ClubCreateView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ClubCreateView: View {
    @ObservedObject var store: StoreOf<ClubCreateFeature>
    
    @State private var isScrolled = false
    @State private var baseHeight: CGFloat = 164
    @State private var navBarHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                mainScrollView(proxy)
                navigationOverlay(safeAreaTop: proxy.safeAreaInsets.top)
            }
            .ignoresSafeArea()
            .toolbar(.hidden)
            .enableSwipeBack()
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
                baseHeight = newValue / 4.5
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    // MARK: - Main Components
    
    private func mainScrollView(_ proxy: GeometryProxy) -> some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    stretchableHeader
                    logoView
                    fieldView
                }
            }
            .coordinateSpace(name: "scroll")
            
            AppButton(
                title: "Continue",
                model: .init(
                    contentSize: .fill
                )
            ) {
                
            }
            .disabled(!store.state.isValid)
            .padding(.bottom, proxy.safeAreaInsets.bottom)
            .padding(.horizontal)
        }
    }
    
    private var fieldView: some View {
        VStack(spacing: 16) {
            Text("Fields marked with * are required.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.appBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
            
            ForEach(store.state.clubsCreateSchema, id: \.id) { schema in
                FieldSchemaRouter(
                    field: schema,
                    text: Binding(
                        get: { store.state.text(schema.id) },
                        set: { store.state.setText(schema.id, $0) }
                    ),
                    tags: Binding(
                        get: { store.state.tags(schema.id) },
                        set: { store.state.setTags(schema.id, $0) }
                    ),
                    links: Binding(
                        get: { store.state.links(schema.id) },
                        set: { store.state.setLinks(schema.id, $0) }
                    ),
                    cover: Binding(
                        get: { store.state.cover(schema.id) },
                        set: { store.state.setColor(schema.id, $0) }
                    ),
                    radio: Binding(
                        get: { store.state.radio(schema.id) },
                        set: { store.state.setRadio(schema.id, $0) }
                    )
                )
            }
        }
    }
    
    private func navigationOverlay(safeAreaTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            customNavigationBar(safeAreaTop: safeAreaTop)
                .background(isScrolled ? Color.white : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: .zero))
                .shadow(
                    color: isScrolled ? Color.black.opacity(0.1) : Color.clear,
                    radius: isScrolled ? 4 : 0,
                    x: 0,
                    y: isScrolled ? 2 : 0
                )
        }
        .animation(.easeInOut(duration: 0.2), value: isScrolled)
    }
    
    // MARK: - Navigation Bar
    
    private func customNavigationBar(safeAreaTop: CGFloat) -> some View {
        HStack {
            Button { store.send(.backTapped) } label: {
                navigationBarButton(uiImage: UIImage.Icons.arrowLeft01)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaTop - 5)
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
            navBarHeight = newValue - 20
        }
    }
    
    private func navigationBarButton(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .padding(10)
            .background(isScrolled ? Color.Palette.grayQuaternary : Color.Palette.whiteMedium)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 16)
    }
    
    // MARK: - Header
    
    private var stretchableHeader: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .named("scroll")).minY
            let pullDown = max(minY, 0)
            let height = baseHeight + pullDown
            let scale = 1 + (pullDown / 350)

            headerContent
                .frame(height: height)
                .scaleEffect(scale, anchor: .center)
                .clipped()
                .offset(y: minY > 0 ? -minY : 0)
                .onChange(of: minY) { newValue in
                    withAnimation {
                        isScrolled = newValue < -30
                    }
                }
        }
        .frame(height: baseHeight)
    }
    
    private var headerContent: some View {
        CardBackgroundView(cardType: .club) {}
            .backgroundType(store.state.values.cover)
            .cornerRadius(.zero)
    }
    
    // MARK: - Logo
    
    private var logoView: some View {
        HStack(alignment: .lastTextBaseline) {
            clubLogo
                .onTapGesture {
                    // picker
                }
            Spacer()
        }
        .padding(.top, -44)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var clubLogo: some View {
        ZStack {
            if let selectedLogo = store.state.selectedLogo,
                let image = UIImage(data: selectedLogo) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(uiImage: UIImage.Icons.user)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .foregroundStyle(Color.Palette.blackMedium)
                    .padding(22)
                    .background(Color.Palette.grayQuaternary)
            }
        }
        .frame(width: 88, height: 88)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 3)
        )
        .padding(.horizontal, 16)
        .overlay(alignment: .bottomTrailing) {
            cameraButton
        }
    }
    
    private var cameraButton: some View {
        Button {} label: {
            Image(uiImage: UIImage.Icons.camera)
                .resizable()
                .renderingMode(.template)
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.Palette.blackMedium)
                .padding(7)
                .background(Color.Palette.grayQuaternary)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.Palette.whiteHigh, lineWidth: 2)
                )
        }
    }
    
    // MARK: - Bottom Content
    
    
}
