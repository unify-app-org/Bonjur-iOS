//
//  EditProfileView.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI
import AppUIKit
import PhotosUI
import AppFoundation
import AppPresentationModel

struct EditProfileView: View {
    @ObservedObject var store: StoreOf<EditProfileFeature>
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    avatar
                    staticTextFields
                    dynamicTextFields
                }
            }
            .scrollDismissesKeyboard(.interactively)
            AppButton(
                title: "Save",
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.saveTapped)
            }
            .padding()
        }
        .navigationTitle("Edit profile")
        .onFirstAppear {
            store.send(.fetchData)
        }
        .dismissKeyboardOnTap()
        .dismissDatePickerOnTap(isPresented: $store.state.showDatePicker)
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    store.state.selectedImage = data
                }
            }
        }
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
    
    private var avatar: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            AvatarView(
                image: selectedAvatarImage,
                url: store.state.avatarURL
            ) {
                if let image = UIImage(systemName: "person") {
                    Image(uiImage: image)
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .frame(width: 44, height: 44)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                cameraButton
            }
        }
    }
    
    private var selectedAvatarImage: UIImage? {
        guard let selectedImage = store.state.selectedImage else {
            return nil
        }
        return UIImage(data: selectedImage)
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
    
    private var staticTextFields: some View {
        VStack(spacing: 16) {
            AppTextField(
                text: $store.state.name,
                placeHolder: "Name and surname",
                model: .init(title: "Name and surname")
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.faculty,
                placeHolder: "Faculty",
                model: .init(title: "Faculty")
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.community,
                placeHolder: "University",
                model: .init(title: "University")
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.entry,
                placeHolder: "Entry",
                model: .init(title: "Entry")
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.course,
                placeHolder: "Course",
                model: .init(title: "Course")
            )
            .disabled(true)
        }
        .padding(.horizontal, 16)
    }
    
    private var dynamicTextFields: some View {
        VStack(spacing: 16) {
            TextView(
                text: $store.state.about,
                characterLimit: 150,
                model: .init(title: "About")
            )
            
            genderPicker
            birthdayField
            
            if store.state.showDatePicker {
                datePicker
            }
            
            CategorySelectionField(
                categories: store.state.selectedCategories,
                onAdd: {
                    store.send(.addCategoryTapped)
                },
                onRemove: { id in
                    store.send(.removeCategory(id))
                }
            )
        }
        .padding(.horizontal, 16)
    }
    
    private var genderPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose gender")
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 24) {
                ForEach(AppPresentationModel.GenderModel.all, id: \.id) { item in
                    genderButton(title: item.title, gender: item.type)
                }
            }
        }
    }
    
    private func genderButton(
        title: String,
        gender: AppPresentationModel.Gender
    ) -> some View {
        RadioSelectItemView(
            id: gender.rawValue,
            title: title,
            isSelected: store.state.gender == gender
        ) { id in
            store.send(.selectedGender(gender))
        }
    }
    
    private var birthdayField: some View {
        DatePickerTextField(
            text: store.state.birthDateText
        ) {
            withAnimation {
                store.send(.birthdayTapped)
            }
        }
    }
    
    private var datePicker: some View {
        DatePicker(
            "Select Date",
            selection: Binding(
                get: { store.state.birthDate ?? Date() },
                set: { store.send(.birthDateChanged($0)) }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
    }
}
