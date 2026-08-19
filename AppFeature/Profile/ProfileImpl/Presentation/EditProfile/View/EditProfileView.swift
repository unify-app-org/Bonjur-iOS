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
                title: "editprofile_save".localized,
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.saveTapped)
            }
            .padding()
        }
        .navigationTitle("editprofile_title".localized)
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
        .sheet(
            isPresented: Binding(
                get: { store.state.showLanguagePicker },
                set: { isPresented in
                    if !isPresented {
                        store.send(.dismissLanguagePicker)
                    }
                }
            )
        ) {
            SelectableListView(
                items: $store.state.languages,
                title: "editprofile_select_spoken".localized,
                subtitle: "editprofile_select_known".localized,
                doneTitle: "editprofile_select".localized,
                onBack: {
                    store.send(.dismissLanguagePicker)
                },
                onDone: {
                    store.send(.languagePickerDone)
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
                placeHolder: "editprofile_name".localized,
                model: .init(title: "editprofile_name".localized)
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.faculty,
                placeHolder: "editprofile_faculty".localized,
                model: .init(title: "editprofile_faculty".localized)
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.community,
                placeHolder: "editprofile_university".localized,
                model: .init(title: "editprofile_university".localized)
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.entry,
                placeHolder: "editprofile_entry".localized,
                model: .init(title: "editprofile_entry".localized)
            )
            .disabled(true)
            
            AppTextField(
                text: $store.state.course,
                placeHolder: "editprofile_course".localized,
                model: .init(title: "editprofile_course".localized)
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
                model: .init(title: "profile_about".localized)
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
            
            SelectionChipsField(
                title: "editprofile_spoken_languages".localized,
                addTitle: "editprofile_add_language".localized,
                items: store.state.selectedLanguages,
                onAdd: {
                    store.send(.addLanguageTapped)
                },
                onRemove: { id in
                    store.send(.removeLanguage(id))
                }
            )
        }
        .padding(.horizontal, 16)
    }
    
    private var genderPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("editprofile_choose_gender".localized)
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
            "editprofile_select_date".localized,
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
