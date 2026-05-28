//
//  ClubCreateView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import PhotosUI
import ImageIO

struct ClubCreateView: View {
    @ObservedObject var store: StoreOf<ClubCreateFeature>
    
    @State private var isScrolled = false
    @State private var baseHeight: CGFloat = 164
    @State private var selectedLogo: PhotosPickerItem?
    @State private var selectedBgPhoto: PhotosPickerItem?
    @State private var logoImage: UIImage?
    @State private var backgroundImage: UIImage?
    
    var body: some View {
        GeometryReader { proxy in
            mainScrollView(proxy)
                .ignoresSafeArea(edges: .top)
                .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
                    baseHeight = newValue / 4
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible)
        .toolbarBackground(isScrolled ? .automatic : .hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .toolbarItemBackground(
                        isScrolled: isScrolled
                    ) {
                        store.send(.backTapped)
                    }
            }
        }
        .onAppear {
            store.send(.fetchData)
        }
        .onChange(of: selectedLogo) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    store.state.selectedLogo = data
                    logoImage = await downsampleImage(data: data, maxPixelSize: 360)
                }
            }
        }
        .onChange(of: selectedBgPhoto) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    store.state.backgroundPhoto = data
                    backgroundImage = await downsampleImage(data: data, maxPixelSize: 1200)
                }
            }
        }
        .dismissKeyboardOnTap()
        .sheet(
            isPresented: Binding(
                get: { store.state.showCategoryPicker },
                set: { isPresented in
                    if !isPresented {
                        store.send(.dismissCategoryPicker)
                    }
                }
            )
        ) {
            SelectCategoryView(
                sections: $store.state.categorySections,
                onBack: {
                    store.send(.dismissCategoryPicker)
                },
                onDone: {
                    store.send(.categoryPickerDone)
                }
            )
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
                store.send(.continueTapped)
            }
            .disabled(!store.state.isValid)
            .padding(.bottom, min(proxy.safeAreaInsets.bottom, 34))
            .padding(.horizontal)
        }
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
        PhotosPicker(selection: $selectedBgPhoto, matching: .images) {
            CardBackgroundView(cardType: .club) {
                if let backgroundImage {
                    Image(uiImage: backgroundImage)
                        .resizable()
                        .scaledToFill()
                } else if let existingCoverURL = store.state.existingCoverURL {
                    CachedAsyncImage(url: existingCoverURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        EmptyView()
                    }
                }
            }
            .backgroundType(store.state.values.cover(.cover))
            .cornerRadius(.zero)
        }
    }
    
    // MARK: - Logo
    
    private var logoView: some View {
        HStack(alignment: .lastTextBaseline) {
            clubLogo
            Spacer()
            cameraButton
                .padding(.bottom, 60)
                .padding(.trailing)
        }
        .padding(.top, -44)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var clubLogo: some View {
        PhotosPicker(selection: $selectedLogo, matching: .images) {
            ZStack {
                if let logoImage {
                    Image(uiImage: logoImage)
                        .resizable()
                        .scaledToFill()
                } else if let existingLogoURL = store.state.existingLogoURL {
                    CachedAsyncImage(url: existingLogoURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        defaultLogoImage
                    }
                } else {
                    defaultLogoImage
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
    }
    
    private var defaultLogoImage: some View {
        Image(uiImage: UIImage.Icons.user)
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .foregroundStyle(Color.Palette.blackMedium)
            .padding(22)
            .background(Color.Palette.grayQuaternary)
    }
    
    private var cameraButton: some View {
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
    
    // MARK: - Bottom Content
    
    private var fieldView: some View {
        VStack(spacing: 16) {
            Text("Fields marked with * are required.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.appBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16)
            
            ForEach(store.state.clubsCreateSchema) { field in
                FieldSchemaRouter(
                    field: field,
                    values: Binding(
                        get: { store.state.values },
                        set: { store.state.values = $0 }
                    ),
                    selectedCategories: store.state.selectedCategories,
                    isDisabled: store.state.disabledFieldIDs.contains(field.id),
                    onAddCategory: {
                        store.send(.addCategoryTapped)
                    },
                    onRemoveCategory: { id in
                        store.send(.removeCategory(id))
                    }
                )
            }
        }
    }
    
    private func downsampleImage(data: Data, maxPixelSize: CGFloat) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            let options = [kCGImageSourceShouldCache: false] as CFDictionary
            guard let source = CGImageSourceCreateWithData(data as CFData, options) else {
                return nil
            }
            
            let thumbnailOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixelSize
            ] as CFDictionary
            
            guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, thumbnailOptions) else {
                return nil
            }
            
            return UIImage(cgImage: cgImage)
        }.value
    }
}
