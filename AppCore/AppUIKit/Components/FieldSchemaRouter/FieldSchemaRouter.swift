//
//  FieldSchemaRouter.swift
//  AppUIKit
//
//  Created by Codex on 31.05.26.
//

import AppPresentationModel
import AppLocalization
import AppUtils
import SwiftUI
import UIKit
import UniformTypeIdentifiers

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

    public struct AttachmentItem: Identifiable, Equatable, Hashable {
        public let id: UUID
        public var name: String
        public var url: URL
        public var size: String

        public init(id: UUID = UUID(), name: String, url: URL, size: String = "0 Kb") {
            self.id = id
            self.name = name
            self.url = url
            self.size = size
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
        case reminders([AppPresentationModel.ReminderOption])
        case attachments([AttachmentItem])
    }

    public enum FieldType {
        case coverPicker(item: CoverItem)
        case radioGroup(options: [RadioOption])
        case text(placeholder: String, keyboardType: UIKeyboardType = .default)
        case textArea(placeholder: String, maxLength: Int)
        case chipInput(placeholder: String)
        case linkInput(placeholder: String)
        case date(placeholder: String)
        case reminder(placeholder: String, description: String = "", options: [AppPresentationModel.ReminderOption] = AppPresentationModel.ReminderOption.allCases)
        case attachment(placeholder: String, description: String = "")
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
        /// Note shown under the input, e.g. "you won't be able to change this later".
        ///
        /// Rendered **only while the field is still editable** — see `FieldHint`. A
        /// warning that something will lock is pointless once it has locked, so on the
        /// edit screen (where the field arrives disabled) it disappears on its own.
        public var hint: String?

        public init(
            id: FieldID,
            label: String,
            type: FieldType,
            required: Bool = true,
            hint: String? = nil
        ) {
            self.id = id
            self.label = label
            self.type = type
            self.required = required
            self.hint = hint
        }
    }
}

public extension AppFieldSchema.FieldID {
    static let cover: Self = "cover"
    static let visibility: Self = "visibility"
    static let clubName: Self = "clubName"
    static let hangoutName: Self = "hangoutName"
    static let eventName: Self = "eventName"
    static let ownerContact: Self = "ownerContact"
    static let category: Self = "category"
    static let capacity: Self = "capacity"
    static let links: Self = "links"
    static let location: Self = "location"
    static let hangoutDate: Self = "hangoutDate"
    static let eventDate: Self = "eventDate"
    static let reminder: Self = "reminder"
    static let attachment: Self = "attachment"
    static let club: Self = "club"
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
                isRequired: field.required,
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
                isRequired: field.required,
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

        case .reminder(let placeholder, let description, let options):
            ReminderField(
                field: field,
                placeholder: placeholder,
                description: description,
                options: options,
                selected: Binding(
                    get: { values.reminders(field.id) },
                    set: { values[field.id] = .reminders($0) }
                )
            )

        case .attachment(let placeholder, let description):
            AttachmentField(
                field: field,
                placeholder: placeholder,
                description: description,
                attachments: Binding(
                    get: { values.attachments(field.id) },
                    set: { values[field.id] = .attachments($0) }
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

    func reminders(_ id: AppFieldSchema.FieldID) -> [AppPresentationModel.ReminderOption] {
        if case .reminders(let value) = self[id] { return value }
        return []
    }

    func attachments(_ id: AppFieldSchema.FieldID) -> [AppFieldSchema.AttachmentItem] {
        if case .attachments(let value) = self[id] { return value }
        return []
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
            case .coverPicker, .radioGroup, .date, .reminder, .attachment:
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
            FieldHint(text: field.hint, isDisabled: isDisabled)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }
}

/// Muted note under an input. Hidden once the field is disabled: every hint we show is a
/// heads-up that the field will lock, which stops being useful the moment it has.
struct FieldHint: View {
    let text: String?
    let isDisabled: Bool

    var body: some View {
        if let text, !text.isEmpty, !isDisabled {
            Text(text)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
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
                    Text(value.toString(format: .ddMMyyyyHHmm))
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
            detents: [.height(450)],
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

private struct ReminderField: View {
    let field: AppFieldSchema.Field
    let placeholder: String
    let description: String
    let options: [AppPresentationModel.ReminderOption]
    @Binding var selected: [AppPresentationModel.ReminderOption]
    @State private var isPresented = false

    private var activeSelection: [AppPresentationModel.ReminderOption] {
        selected.filter { $0 != .none }
    }

    private var collapsedLabel: String {
        let active = activeSelection
        return active.isEmpty ? placeholder : active.map(\.label).joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            FieldLabel(field: field)

            if !description.isEmpty {
                Text(description)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
                isPresented = true
            } label: {
                HStack {
                    Text(collapsedLabel)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(
                            activeSelection.isEmpty
                                ? Color.Palette.blackMedium
                                : Color.Palette.blackHigh
                        )
                        .lineLimit(1)

                    Spacer()

                    Image(uiImage: UIImage.Icons.bell)
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
            detents: [.large],
            dragIndicator: .visible
        ) {
            ReminderOptionsList(
                title: field.label,
                description: description,
                options: options,
                selected: $selected,
                isPresented: $isPresented
            )
        }
    }
}

/// Multi-select reminder list. "None" is exclusive: picking it clears the offsets and
/// vice-versa. Confirm commits the selection (empty selection collapses to `.none`).
private struct ReminderOptionsList: View {
    let title: String
    let description: String
    let options: [AppPresentationModel.ReminderOption]
    @Binding var selected: [AppPresentationModel.ReminderOption]
    @Binding var isPresented: Bool

    @State private var draft: Set<AppPresentationModel.ReminderOption> = []

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(Font.Typography.HeadingMd.bold)
                .foregroundStyle(Color.Palette.blackHigh)
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 8)

            if !description.isEmpty {
                Text(description)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
            }

            ScrollView {
                VStack(spacing: 0) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        row(for: option)
                        if index < options.count - 1 {
                            Divider().padding(.horizontal, 24)
                        }
                    }
                }
            }

            AppButton(
                title: "Confirm",
                model: .init(contentSize: .fill)
            ) {
                commit()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
        }
        .onAppear {
            draft = Set(selected.filter { $0 != .none })
        }
    }

    private func row(for option: AppPresentationModel.ReminderOption) -> some View {
        let isChecked = option == .none ? draft.isEmpty : draft.contains(option)
        return Button {
            toggle(option)
        } label: {
            HStack(spacing: 16) {
                checkbox(isChecked: isChecked)
                Text(option.label)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(Color.Palette.blackHigh)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func checkbox(isChecked: Bool) -> some View {
        RoundedRectangle(cornerRadius: 6)
            .fill(isChecked ? Color.Palette.black : Color.Palette.white)
            .frame(width: 24, height: 24)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(
                        isChecked ? Color.Palette.black : Color.Palette.grayTeritary,
                        lineWidth: 1.5
                    )
            )
            .overlay(
                Image(systemName: "checkmark")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(Color.Palette.white)
                    .opacity(isChecked ? 1 : 0)
            )
    }

    private func toggle(_ option: AppPresentationModel.ReminderOption) {
        if option == .none {
            draft.removeAll()
        } else if draft.contains(option) {
            draft.remove(option)
        } else {
            draft.insert(option)
        }
    }

    private func commit() {
        let ordered = options.filter { $0 != .none && draft.contains($0) }
        selected = ordered.isEmpty ? [.none] : ordered
        isPresented = false
    }
}

private struct AttachmentField: View {
    let field: AppFieldSchema.Field
    let placeholder: String
    let description: String
    @Binding var attachments: [AppFieldSchema.AttachmentItem]
    @State private var isImporterPresented = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            FieldLabel(field: field)

            if !description.isEmpty {
                Text(description)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .fixedSize(horizontal: false, vertical: true)
            }

            ForEach(attachments) { item in
                attachmentRow(item)
            }

            addButton
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
        .fileImporter(
            isPresented: $isImporterPresented,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            if case .success(let urls) = result {
                let new = urls.map { url in
                    AppFieldSchema.AttachmentItem(
                        name: url.deletingPathExtension().lastPathComponent,
                        url: url,
                        size: Self.fileSize(of: url)
                    )
                }
                attachments.append(contentsOf: new)
            }
        }
    }

    private func attachmentRow(_ item: AppFieldSchema.AttachmentItem) -> some View {
        HStack(spacing: 16) {
            Image(uiImage: UIImage.Icons.fileAttachment)
                .renderingMode(.template)
                .foregroundStyle(Color.Palette.blackHigh)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(Font.Typography.BodyTextMd.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .lineLimit(1)

                Text(item.size)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
            }

            Spacer(minLength: 0)

            Button {
                attachments.removeAll { $0.id == item.id }
            } label: {
                Image(uiImage: UIImage.Icons.trash)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.cardBgRed)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.Palette.graySecondary, lineWidth: 0.5))
    }

    private var addButton: some View {
        AppButton(
            title: placeholder,
            model: .init(type: .secondary, style: .default, contentSize: .fill)
        ) {
            isImporterPresented = true
        }
    }

    private static func fileSize(of url: URL) -> String {
        let didAccess = url.startAccessingSecurityScopedResource()
        defer { if didAccess { url.stopAccessingSecurityScopedResource() } }
        let values = try? url.resourceValues(forKeys: [.fileSizeKey])
        return "\(values?.fileSize ?? 0)"
    }

    private static func formatSize(_ bytes: Int) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(bytes), countStyle: .file)
    }
}

/// Form-field title with the required `*` / `(optional)` marker.
///
/// Public so the chip and link fields — which draw their own title instead of going
/// through `FieldLabel` — can show the same marker. Without it a required chip field
/// (e.g. category) renders with no `*` and reads as optional.
public struct AppFieldLabel: View {
    private let text: String
    private let isRequired: Bool

    public init(text: String, isRequired: Bool) {
        self.text = text
        self.isRequired = isRequired
    }

    public var body: some View {
        HStack(spacing: 2) {
            Text(text)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.blackHigh)

            if isRequired {
                Text("*")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
            } else {
                Text("field_optional".localized)
                    .font(Font.Typography.BodyTextSm.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct FieldLabel: View {
    let field: AppFieldSchema.Field

    var body: some View {
        AppFieldLabel(text: field.label, isRequired: field.required)
    }
}
