//
//  HangoutCreateView.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import AppUtils
import AppPresentationModel

struct HangoutCreateView: View {
    @ObservedObject var store: StoreOf<HangoutCreateFeature>
    @State private var isDatePickerPresented = false
    @State private var isEndDatePickerPresented = false
    
    var body: some View {
        VStack(spacing: .zero) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    topView
                    visibilityField
                    textField("Hangout name", placeholder: "Study night at cafe", text: $store.state.name)
                        .disabled(store.state.disabledName)
                    textField("Owner contact", placeholder: "+994 123 45 67", text: $store.state.ownerContact)
                   
                    categoryField
                    linksField
                    textField(
                        "Capacity",
                        placeholder: "200",
                        text: $store.state.capacity,
                        keyboardType: .numberPad,
                        required: false
                    )
                    textField("Location", placeholder: "Library", text: $store.state.location)
                    dateField
                 
                    textArea("Rules", text: $store.state.rules)
                    textArea("About", text: $store.state.about)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
            
            AppButton(
                title: "Continue",
                model: .init(contentSize: .fill)
            ) {
                store.send(.continueTapped)
            }
            .disabled(!store.state.isValid)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .toolbarItemBackground {
                        store.send(.backTapped)
                    }
            }
        }
        .onAppear {
            store.send(.fetchData)
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
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create new hangouts")
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.black)
            
            Text("Fields marked with * are required.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.appBlue)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var visibilityField: some View {
        VStack(alignment: .leading, spacing: 14) {
            fieldLabel("Who can see your hangout?")
            
            visibilityOption(
                title: "Public",
                description: "This is a Public Hangout. Feel free to use the contact details below to get in touch with the organizers.",
                isSelected: store.state.visibility == .public
            ) {
                store.state.visibility = .public
            }
            
            visibilityOption(
                title: "Private",
                description: "Contact details and group links are only visible to members. Join the hangout to access this information.",
                isSelected: store.state.visibility == .private
            ) {
                store.state.visibility = .private
            }
        }
    }
    
    private var categoryField: some View {
        CategorySelectionField(
            title: "Category",
            addTitle: "Add category",
            categories: store.state.selectedCategories,
            onAdd: {
                store.send(.addCategoryTapped)
            },
            onRemove: { id in
                store.send(.removeCategory(id))
            }
        )
    }
    
    private var linksField: some View {
        AppLinksField(
            title: "Add link(optional)",
            addTitle: "Add link",
            links: $store.state.links,
            maxCount: 4
        )
    }
    
    private var dateField: some View {
        DatePickerTextField(
            title: "Start date",
            text: store.state.hangoutDate.toString(format: .dd_MM_yyyy),
            placeholder: "dd/mm/yyyy"
        ) {
            isDatePickerPresented = true
        }
        .appSheet(
            isPresented: $isDatePickerPresented,
            detents: [.height(360)],
            dragIndicator: .visible
        ) {
            DatePicker(
                "Start date",
                selection: $store.state.hangoutDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
    
   
    
    private func visibilityOption(
        title: String,
        description: String,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) -> some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? Color.Palette.green900 : Color.Palette.grayTeritary,
                            lineWidth: 2
                        )
                        .frame(width: 20, height: 20)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.Palette.green900)
                            .frame(width: 10, height: 10)
                    }
                }
                .padding(.top, 2)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .foregroundStyle(Color.Palette.blackHigh)
                    
                    Text(description)
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .buttonStyle(.plain)
    }
    
    private func textField(
        _ title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        required: Bool = true
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel(title, required: required)
            AppTextField(
                text: text,
                placeHolder: placeholder,
                model: .init(keyboardType: keyboardType)
            )
        }
    }
    
    private func textArea(
        _ title: String,
        text: Binding<String>,
        required: Bool = true
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel(title, required: required)
            TextView(text: text, characterLimit: 500)
        }
    }
    
    private func fieldLabel(
        _ title: String,
        required: Bool = true
    ) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.blackHigh)
            
            if required {
                Text("*")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
            } else {
                Text("(optional)")
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
