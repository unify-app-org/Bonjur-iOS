//
//  FieldSchemaRouter.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.02.26.
//

import SwiftUI
import AppUIKit
import AppPresentationModel

// MARK: - TagItem + Hashable

extension ClubsCreate.TagItem: Hashable {
    public static func == (lhs: ClubsCreate.TagItem, rhs: ClubsCreate.TagItem) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Router

struct FieldSchemaRouter: View {
    let field: ClubsCreate.FieldSchema
    @Binding var values: [ClubsCreate.FieldID: ClubsCreate.FieldValue]
    let selectedCategories: [CategoriesChipsView.Model]
    let onAddCategory: () -> Void
    let onRemoveCategory: (Int) -> Void
    
    init(
        field: ClubsCreate.FieldSchema,
        values: Binding<[ClubsCreate.FieldID: ClubsCreate.FieldValue]>,
        selectedCategories: [CategoriesChipsView.Model] = [],
        onAddCategory: @escaping () -> Void = {},
        onRemoveCategory: @escaping (Int) -> Void = { _ in }
    ) {
        self.field = field
        self._values = values
        self.selectedCategories = selectedCategories
        self.onAddCategory = onAddCategory
        self.onRemoveCategory = onRemoveCategory
    }

    var body: some View {
        switch field.type {

        case .coverPicker(let item):
            CoverPickerField(
                field: field,
                item: item,
                selected: values.cover(field.id),
                onChange: { values[field.id] = .cover($0) }
            )

        case .radioGroup(let options):
            RadioGroupField(
                field: field,
                options: options,
                selected: values.radio(field.id),
                onChange: { values[field.id] = .radio($0) }
            )

        case .text(let placeholder):
            TextInputField(
                field: field,
                placeholder: placeholder,
                value: Binding(
                    get: { values.text(field.id) },
                    set: { values[field.id] = .text($0) }
                )
            )

        case .textArea(let placeholder, let maxLength):
            TextAreaField(
                field: field,
                placeholder: placeholder,
                maxLength: maxLength,
                value: Binding(
                    get: { values.text(field.id) },
                    set: { values[field.id] = .text($0) }
                )
            )

        case .chipInput(let placeholder):
            CategorySelectionField(
                title: field.label,
                addTitle: placeholder,
                categories: selectedCategories,
                onAdd: onAddCategory,
                onRemove: onRemoveCategory
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

        case .linkInput(let placeholder):
            AppLinksField(
                title: field.label,
                addTitle: placeholder,
                links: Binding(
                    get: { values.links(field.id).map(\.appLinkItem) },
                    set: { values[field.id] = .links($0.map(\.clubLinkItem)) }
                ),
                maxCount: 4
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 14)
        }
    }
}

// MARK: - Values Dictionary Extensions (get/set per type)

extension Dictionary where Key == ClubsCreate.FieldID, Value == ClubsCreate.FieldValue {

    func text(_ id: ClubsCreate.FieldID) -> String {
        if case .text(let v) = self[id] { return v }
        return ""
    }

    func tags(_ id: ClubsCreate.FieldID) -> [ClubsCreate.TagItem] {
        if case .tags(let v) = self[id] { return v }
        return []
    }

    func links(_ id: ClubsCreate.FieldID) -> [ClubsCreate.LinkItem] {
        if case .links(let v) = self[id] { return v }
        return []
    }

    func cover(_ id: ClubsCreate.FieldID) -> AppUIEntities.BackgroundType {
        if case .cover(let v) = self[id] { return v }
        return .primary
    }

    func radio(_ id: ClubsCreate.FieldID) -> AppPresentationModel.AccessType {
        if case .radio(let v) = self[id] { return v }
        return .public
    }

    func isValid(for schema: [ClubsCreate.FieldSchema]) -> Bool {
        schema.filter { $0.required }.allSatisfy { field in
            switch field.type {
            case .text, .textArea:
                return !text(field.id).trimmingCharacters(in: .whitespaces).isEmpty
            case .chipInput:
                return !tags(field.id).isEmpty
            case .linkInput:
                return !links(field.id).isEmpty
            default:
                return true
            }
        }
    }
}

private extension ClubsCreate.LinkItem {
    var appLinkItem: AppLinkItem {
        AppLinkItem(
            id: id,
            type: type,
            name: name,
            url: url
        )
    }
}

private extension AppLinkItem {
    var clubLinkItem: ClubsCreate.LinkItem {
        ClubsCreate.LinkItem(
            id: id,
            type: type,
            name: name,
            url: url
        )
    }
}

// MARK: - Cover Picker Field

private struct CoverPickerField: View {
    let field: ClubsCreate.FieldSchema
    let item: ClubsCreate.CoverItem
    let selected: AppUIEntities.BackgroundType
    let onChange: (AppUIEntities.BackgroundType) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(Font.Typography.HeadingMd.medium)
                .padding(.horizontal, 16)
            
            Text(item.description)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(Array(item.covers.enumerated()), id: \.offset) { index, cover in
                        CardBackgroundView(cardType: .club) {}
                            .backgroundType(cover)
                            .cornerRadius(12)
                            .frame(width: 114, height: 66)
                            .padding(2)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selected == cover ? Color.Palette.blackHigh : Color.clear,
                                        lineWidth: 2.5
                                    )
                            )
                            .onTapGesture { onChange(cover) }
                            .animation(.spring(response: 0.2), value: selected == cover)
                            .padding(8)
                            .padding(.leading, index == 0 ? 8 : 0)
                    }
                }
            }
        }
        .padding(.bottom, 20)
    }
}

// MARK: - Radio Group Field

private struct RadioGroupField: View {
    let field: ClubsCreate.FieldSchema
    let options: [ClubsCreate.RadioOption]
    let selected: AppPresentationModel.AccessType
    let onChange: (AppPresentationModel.AccessType ) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            FieldLabel(field: field)

            ForEach(options) { option in
                Button(action: { onChange(option.value) }) {
                    HStack(alignment: .top, spacing: 12) {
                        ZStack {
                            Circle()
                                .stroke(
                                    selected == option.value
                                        ? Color.Palette.green900
                                        : Color.Palette.grayTeritary,
                                    lineWidth: 2
                                )
                                .frame(width: 20, height: 20)

                            if selected == option.value {
                                Circle()
                                    .fill(Color.Palette.green900)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.top, 2)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(option.label)
                                .font(Font.Typography.BodyTextMd.semiBold)
                                .foregroundStyle(Color.Palette.blackHigh)

                            Text(option.description)
                                .font(Font.Typography.BodyTextSm.regular)
                                .foregroundStyle(Color.Palette.blackMedium)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }
}

// MARK: - Text Input Field

private struct TextInputField: View {
    let field: ClubsCreate.FieldSchema
    let placeholder: String
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FieldLabel(field: field)
            AppTextField(
                text: $value,
                placeHolder: placeholder
            )
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}

// MARK: - Text Area Field

private struct TextAreaField: View {
    let field: ClubsCreate.FieldSchema
    let placeholder: String
    let maxLength: Int
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FieldLabel(field: field)
            TextView(text: $value, characterLimit: maxLength)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}

// MARK: - Shared Field Label

private struct FieldLabel: View {
    let field: ClubsCreate.FieldSchema

    var body: some View {
        HStack(spacing: 2) {
            Text(field.label)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.blackHigh)

            if field.required {
                Text("*")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
            } else {
                Text("(optional)")
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
            }
        }
    }
}
