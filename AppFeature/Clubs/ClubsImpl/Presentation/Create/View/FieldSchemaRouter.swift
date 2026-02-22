//
//  FieldSchemaRouter.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.02.26.
//

import SwiftUI
import AppUIKit

// MARK: - TagItem + Hashable

extension ClubsCreate.TagItem: Hashable {
    public static func == (lhs: ClubsCreate.TagItem, rhs: ClubsCreate.TagItem) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - BackgroundType + Equatable

extension AppUIEntities.BackgroundType: Equatable {
    public static func == (lhs: AppUIEntities.BackgroundType, rhs: AppUIEntities.BackgroundType) -> Bool {
        lhs.bgColor == rhs.bgColor
    }
}

// MARK: - Router

struct FieldSchemaRouter: View {
    let field: ClubsCreate.FieldSchema

    // Each field type gets only the binding it actually needs
    @Binding var text: String
    @Binding var tags: [ClubsCreate.TagItem]
    @Binding var links: [ClubsCreate.LinkItem]
    @Binding var cover: AppUIEntities.BackgroundType
    @Binding var radio: ClubsCreate.RadioType
    
    var body: some View {
        switch field.type {

        case .coverPicker(let item):
            CoverPickerField(
                field: field,
                item: item,
                selected: cover,
                onChange: { cover = $0 }
            )

        case .radioGroup(let options):
            RadioGroupField(
                field: field,
                options: options,
                selected: radio,
                onChange: { radio = $0 }
            )

        case .text(let placeholder):
            TextInputField(
                field: field,
                placeholder: placeholder,
                value: $text
            )

        case .textArea(let placeholder, let maxLength):
            TextAreaField(
                field: field,
                placeholder: placeholder,
                maxLength: maxLength,
                value: $text
            )

        case .chipInput(let placeholder):
            ChipInputField(
                field: field,
                placeholder: placeholder,
                tags: $tags
            )

        case .linkInput(let placeholder):
            LinkInputField(
                field: field,
                placeholder: placeholder,
                links: $links
            )
        }
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
    let selected: ClubsCreate.RadioType
    let onChange: (ClubsCreate.RadioType) -> Void

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

// MARK: - Chip Input Field

private struct ChipInputField: View {
    let field: ClubsCreate.FieldSchema
    let placeholder: String
    @Binding var tags: [ClubsCreate.TagItem]

    @State private var inputText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            FieldLabel(field: field)

            if !tags.isEmpty {
                FlowLayout(spacing: 8, items: tags) { (tag: ClubsCreate.TagItem) in
                    CategoriesChipsView(
                        model: .init(
                            id: tag.id,
                            title: tag.label,
                            selected: true
                        )
                    )
                    .onTapGesture {
                        tags = tags.filter { $0.id != tag.id }
                    }
                }
            }

            AppTextField(text: $inputText, placeHolder: placeholder)
                .onSubmit { addChip() }
                .overlay(alignment: .trailing) {
                    Button(action: addChip) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.Palette.blackMedium)
                            .padding(.trailing, 20)
                    }
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    private func addChip() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        let tempId = (tags.map(\.id).min() ?? 0) - 1
        tags = tags + [ClubsCreate.TagItem(id: tempId, label: trimmed)]
        inputText = ""
    }
}

// MARK: - Link Input Field

private struct LinkInputField: View {
    let field: ClubsCreate.FieldSchema
    let placeholder: String
    @Binding var links: [ClubsCreate.LinkItem]

    @State private var inputText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            FieldLabel(field: field)
            
            ForEach($links, id: \.id) { $link in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if !link.label.isEmpty {
                            Text(link.label)
                                .font(Font.Typography.BodyTextSm.regular)
                                .foregroundStyle(Color.Palette.blackMedium)
                        }
                        Text(link.value)
                            .font(Font.Typography.BodyTextMd.regular)
                            .foregroundStyle(Color.Palette.blackHigh)
                            .lineLimit(1)
                    }

                    Spacer()

                    Button {
                        removeLink(id: link.id)
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(Color.Palette.cardBgRed)
                            .padding(8)
                            .background(Color.Palette.cardBgRed.opacity(0.08))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.Palette.grayQuaternary)
                .clipShape(Capsule())
            }

            AppTextField(
                text: $inputText,
                placeHolder: placeholder
            )
            .onSubmit { addLink() }
            .overlay(alignment: .trailing) {
                Button(action: addLink) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.Palette.blackMedium)
                        .padding(.trailing, 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
    }

    private func addLink() {
        let trimmed = inputText.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        var updated = links
        updated.append(ClubsCreate.LinkItem(id: UUID(), value: trimmed, label: ""))
        links = updated
        inputText = ""
    }

    private func removeLink(id: UUID) {
        links = links.filter { $0.id != id }
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
