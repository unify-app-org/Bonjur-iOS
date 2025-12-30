//
//  AuthOptionalUploadPhotoView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 30.12.25.
//
import SwiftUI
import PhotosUI
import AppFoundation
import AppUIKit

struct AuthOptionalUploadPhotoView: View {
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>
    @State private var selectedItem: PhotosPickerItem?

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                topView
                photoUploadView
            }
        }
        .padding()
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    store.state.selectedImage = data
                }
            }
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload your photos")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Upload 1 images to get started")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var photoUploadView: some View {
        ZStack(alignment: store.state.selectedImage != nil ? .bottom : .center) {
            selectedImage
            changeOrAddPhotoButton
        }
        .frame(width: UIScreen.main.bounds.width / 1.5)
        .frame(height: UIScreen.main.bounds.height / 3)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color.Palette.grayTeritary,
                    lineWidth: 1
                )
        )
        .padding(.horizontal, 50)
    }
    
    @ViewBuilder
    private var selectedImage: some View {
        if let data = store.state.selectedImage, let image = UIImage(data: data) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .clipped()
                .frame(width: UIScreen.main.bounds.width / 1.5)
                .frame(height: UIScreen.main.bounds.height / 3)
        }
    }
    
    private var changeOrAddPhotoButton: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            VStack(spacing: 12) {
                if store.state.selectedImage == nil {
                    Image(uiImage: .Icons.emojiSmile)
                }
                HStack {
                    if store.state.selectedImage == nil {
                        Image(uiImage: UIImage.Icons.plus)
                        Text("Add")
                            .foregroundStyle(Color.Palette.black)
                    } else {
                        Image(uiImage: UIImage.Icons.camera)
                        Text("Change")
                            .foregroundStyle(Color.Palette.black)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.Palette.greenLight)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            Color.Palette.grayTeritary,
                            lineWidth: 0.5
                        )
                )
                .padding(.bottom, store.state.selectedImage != nil ? 16 : 0)
            }
        }
    }
}

#Preview {
    AuthOptionalUploadPhotoView()
}
