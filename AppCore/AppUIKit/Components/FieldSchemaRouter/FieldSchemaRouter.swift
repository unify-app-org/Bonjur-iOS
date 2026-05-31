//
//  FieldSchemaRouter.swift
//  AppUIKit
//
//  Created by Codex on 31.05.26.
//

import AppPresentationModel
import AppUtils
import SwiftUI
import UIKit

public enum AppFieldSchema {

    public struct FieldID: RawRepresentable, Hashable, ExpressibleByStringLiteral {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: StringLiteralType) {
            self.rawValue = value
        }
    }

    public struct TagItem: Identifiable, Equatable, Hashable {
        public let id: Int
        public var label: String

        public init(id: Int, label: String) {
            self.id = id
            self.label = label
        }
    }

    public struct LinkItem: Identifiable, Equatable, Hashable {
        public let id: UUID
        public var type: String
        public var name: String
        public var url: String

        public var label: String { name }
        public var value: String { url }

        public init(id: UUID = UUID(), value: String, label: String) {
            self.id = id
            self.type = ""
            self.name = label
            self.url = value
        }

        public init(id: UUID = UUID(), type: String, name: String, url: String) {
            self.id = id
            self.type = type
            self.name = name
            self.url = url
        }
    }

    public struct CoverItem {
        public let title: String
        public let description: String
        public let covers: [AppUIEntities.BackgroundType]

        public init(
            title: String,
            description: String,
            covers: [AppUIEntities.BackgroundType]
        ) {
            self.title = title
            self.description = description
            self.covers = covers
        }
    }

    public enum FieldValue: Equatable {
        case text(String)
        case tags([TagItem])
        case links([LinkItem])
        case cover(AppUIEntities.BackgroundType)
        case radio(AppPresentationModel.AccessType)
        case date(Date)
    }

    public enum FieldType {
        case coverPicker(item: CoverItem)
        case radioGroup(options: [RadioOption])
        case text(placeholder: String, keyboardType: UIKeyboardType = .default)
        case textArea(placeholder: String, maxLength: Int)
        case chipInput(placeholder: String)
        case linkInput(placeholder: String)
        case date(placeholder: String)
    }

    public struct RadioOption: Identifiable {
        public let id = UUID()
        public let value: AppPresentationModel.AccessType
        public let label: String
        public let description: String

        public init(
            value: AppPresentationModel.AccessType,
            label: String,
            description: String
        ) {
            self.value = value
            self.label = label
            self.description = description
        }
    }

    public struct Field: Identifiable {
        public var id: FieldID
        public let label: String
        public let type: FieldType
        public var required: Bool

        public init(
            id: FieldID,
            label: String,
            type: FieldType,
            required: Bool = true
        ) {
            self.id = id
            self.label = label
            self.type = type
            self.required = required
        }
    }
}

public extension AppFieldSchema.FieldID {
    static let cover: Self = "cover"
    static let visibility: Self = "visibility"
    static let clubName: Self = "clubName"
    static let hangoutName: Self = "hangoutName"
    static let ownerContact: Self = "ownerContact"
    static let category: Self = "category"
    static let capacity: Self = "capacity"
    static let links: Self = "links"
    static let location: Self = "location"
    static let hangoutDate: Self = "hangoutDate"
    static let rules: Self = "rules"
    static let about: Self = "about"
}

public struct FieldSchemaRouter: View {
    private let field: AppFieldSchema.Field
    @Binding private var values: [AppFieldSchema.FieldID: AppFieldSchema.FieldValue]
    private let selectedCategories: [CategoriesChipsView.Model]
    private let isDisabled: Bool
    private let onAddCategory: () -> Void
    private let onRemoveCategory: (Int) -> Void

    public init(
        field: AppFieldSchema.Field,
        values: Binding<[AppFieldSchema.FieldID: AppFieldSchema.FieldValue]>,
        selectedCategories: [CategoriesChipsView.Model] = [],
        isDisabled: Bool = false,
        onAddCategory: @escaping () -> Void = {},
        onRemoveCategory: @escaping (Int) -> Void = { _ in }
    ) {
        self.field = field
        self._values = values
        self.selectedCategories = selectedCategories
        self.isDisabled = isDisabled
        self.onAddCategory = onAddCategory
        self.onRemoveCategory = onRemoveCategory
    }

    public var body: some View {
        switch field.type {
        case .coverPicker(let item):
            CoverPickerField(
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

        case .text(let placeholder, let keyboardType):
            TextInputField(
                field: field,
                placeholder: placeholder,
                keyboardType: keyboardType,
                isDisabled: isDisabled,
                value: Binding(
                    get: { values.text(field.id) },
                    set: { values[field.id] = .text($0) }
                )
            )

        case .textArea(_, let maxLength):
            TextAreaField(
                field: field,
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
                    set: { values[field.id] = .links($0.map(\.fieldLinkItem)) }
                ),
                maxCount: 4
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

        case .date(let placeholder):
            DateInputField(
                field: field,
                placeholder: placeholder,
                value: Binding(
                    get: { values.date(field.id) },
                    set: { values[field.id] = .date($0) }
                )
            )
        }
    }
}

public extension Dictionary where Key == AppFieldSchema.FieldID, Value == AppFieldSchema.FieldValue {

    func text(_ id: AppFieldSchema.FieldID) -> String {
        if case .text(let value) = self[id] { return value }
        return ""
    }

    func tags(_ id: AppFieldSchema.FieldID) -> [AppFieldSchema.TagItem] {
        if case .tags(let value) = self[id] { return value }
        return []
    }

    func links(_ id: AppFieldSchema.FieldID) -> [AppFieldSchema.LinkItem] {
        if case .links(let value) = self[id] { return value }
        return []
    }

    func cover(_ id: AppFieldSchema.FieldID) -> AppUIEntities.BackgroundType {
        if case .cover(let value) = self[id] { return value }
        return .primary
    }

    func radio(_ id: AppFieldSchema.FieldID) -> AppPresentationModel.AccessType {
        if case .radio(let value) = self[id] { return value }
        return .public
    }

    func date(_ id: AppFieldSchema.FieldID) -> Date {
        if case .date(let value) = self[id] { return value }
        return Date()
    }

    func isValid(for schema: [AppFieldSchema.Field]) -> Bool {
        schema.filter(\.required).allSatisfy { field in
            switch field.type {
            case .text, .textArea:
                return !text(field.id).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case .chipInput:
                return !tags(field.id).isEmpty
            case .linkInput:
                return !links(field.id).isEmpty
            case .coverPicker, .radioGroup, .date:
                return true
            }
        }
    }
}

private extension AppFieldSchema.LinkItem {
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
    var fieldLinkItem: AppFieldSchema.LinkItem {
        AppFieldSchema.LinkItem(
            id: id,
            type: type,
            name: name,
            url: url
        )
    }
}

private struct CoverPickerField: View {
    let item: AppFieldSchema.CoverItem
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

private struct RadioGroupField: View {
    let field: AppFieldSchema.Field
    let options: [AppFieldSchema.RadioOption]
    let selected: AppPresentationModel.AccessType
    let onChange: (AppPresentationModel.AccessType) -> Void

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

private struct TextInputField: View {
    let field: AppFieldSchema.Field
    let placeholder: String
    let keyboardType: UIKeyboardType
    let isDisabled: Bool
    @Binding var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FieldLabel(field: field)
            AppTextField(
                text: $value,
                placeHolder: placeholder,
                model: .init(keyboardType: keyboardType)
            )
            .disabled(isDisabled)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}

private struct TextAreaField: View {
    let field: AppFieldSchema.Field
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

private struct DateInputField: View {
    let field: AppFieldSchema.Field
    let placeholder: String
    @Binding var value: Date
    @State private var isPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FieldLabel(field: field)

            Button {
                isPresented = true
            } label: {
                HStack {
                    Text(value.toString(format: .dd_MM_yyyy))
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(Color.Palette.blackHigh)

                    Spacer()

                    Image(uiImage: UIImage.Icons.calendar)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackHigh)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.clear)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        Color.Palette.graySecondary,
                        lineWidth: 0.5
                    )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
        .appSheet(
            isPresented: $isPresented,
            detents: [.height(360)],
            dragIndicator: .visible
        ) {
            DatePicker(
                field.label,
                selection: $value,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.graphical)
            .padding()
        }
    }
}

private struct FieldLabel: View {
    let field: AppFieldSchema.Field

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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
