//
//  AddLinkView.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import SwiftUI

public struct AddLinkView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedType: AppDropdownOption?
    @State private var linkName = ""
    @State private var url = ""
    
    private let title: String
    private let subtitle: String
    private let typeTitle: String
    private let typePlaceholder: String
    private let nameTitle: String
    private let namePlaceholder: String
    private let urlTitle: String
    private let urlPlaceholder: String
    private let confirmTitle: String
    private let typeOptions: [AppDropdownOption]
    private let customTypeID: String
    private let onAdd: (AppLinkItem) -> Void
    
    public init(
        title: String = "Add link",
        subtitle: String = "Add a link for your members to join or learn more. You can add max 4 links.",
        typeTitle: String = "Title link",
        typePlaceholder: String = "Select link",
        nameTitle: String = "Link name",
        namePlaceholder: String = "Enter link name",
        urlTitle: String = "Link",
        urlPlaceholder: String = "https://",
        confirmTitle: String = "Confirm",
        typeOptions: [AppDropdownOption] = AddLinkView.defaultTypeOptions,
        customTypeID: String = "other",
        onAdd: @escaping (AppLinkItem) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.typeTitle = typeTitle
        self.typePlaceholder = typePlaceholder
        self.nameTitle = nameTitle
        self.namePlaceholder = namePlaceholder
        self.urlTitle = urlTitle
        self.urlPlaceholder = urlPlaceholder
        self.confirmTitle = confirmTitle
        self.typeOptions = typeOptions
        self.customTypeID = customTypeID
        self.onAdd = onAdd
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            
            AppDropdownField(
                selection: $selectedType,
                title: typeTitle,
                placeholder: typePlaceholder,
                sheetTitle: typeTitle,
                options: typeOptions
            )
            
            if selectedType?.id == customTypeID {
                AppTextField(
                    text: $linkName,
                    placeHolder: namePlaceholder,
                    model: .init(title: nameTitle)
                )
            }
            
            AppTextField(
                text: $url,
                placeHolder: urlPlaceholder,
                model: .init(title: urlTitle, keyboardType: .URL)
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            
            Spacer(minLength: 8)
            
            AppButton(
                title: confirmTitle,
                model: .init(contentSize: .fill)
            ) {
                addLink()
            }
            .disabled(!canAdd)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Palette.white)
        .dismissKeyboardOnTap()
    }
    
    public static let defaultTypeOptions: [AppDropdownOption] = [
        AppDropdownOption(id: "social_media", title: "Social media"),
        AppDropdownOption(id: "website", title: "Website"),
        AppDropdownOption(id: "other", title: "Other")
    ]
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(Font.Typography.TitleL.extraBold)
                    .foregroundStyle(Color.Palette.blackHigh)
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(uiImage: UIImage.Icons.xmark)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.black)
                        .padding(8)
                        .applyGlassIfAvailable()
                }
                .buttonStyle(ScaleOpacityButtonStyle())
            }
            
            Text(subtitle)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    /// No URL shape validation: members paste handles, deep links and intranet
    /// addresses that no web-URL rule accepts. Whatever they type is stored as-is.
    private var canAdd: Bool {
        guard selectedType != nil else { return false }
        guard !trimmed(url).isEmpty else { return false }
        guard selectedType?.id != customTypeID || !trimmed(linkName).isEmpty else { return false }
        return true
    }
    
    private func addLink() {
        guard let selectedType, canAdd else { return }
        let itemName = selectedType.id == customTypeID ? trimmed(linkName) : selectedType.title
        onAdd(
            AppLinkItem(
                type: selectedType.id,
                name: itemName,
                url: trimmed(url)
            )
        )
        dismiss()
    }
    
    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
