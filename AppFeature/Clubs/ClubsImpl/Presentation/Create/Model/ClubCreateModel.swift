//
//  ClubCreateModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppUIKit
import Combine
import Foundation

// MARK: - ClubCreate input

struct ClubCreateInputData {
}

// MARK: - Side effects

enum ClubCreateSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ClubCreateFeature = UIFeatureDefinition<
    ClubCreateViewState,
    ClubCreateAction,
    ClubCreateSideEffect
>

// MARK: - View State

final class ClubCreateViewState: UIFeatureState {
    @Published var clubsCreateSchema: [ClubsCreate.FieldSchema] = []
    @Published var selectedLogo: Data?
    @Published var values: [ClubsCreate.FieldID: ClubsCreate.FieldValue] = [
        .cover : .cover(.primary),
        .visibility: .radio(.public)
    ]
    
    var isValid: Bool {
        clubsCreateSchema.filter { $0.required }.allSatisfy { field in
            switch field.type {
            case .text, .textArea: return !text(field.id).trimmingCharacters(in: .whitespaces).isEmpty
            case .chipInput: return !tags(field.id).isEmpty
            default: return true
            }
        }
    }
    
    func text(_ key: ClubsCreate.FieldID) -> String {
        if case .text(let s) = values[key] { return s }; return ""
    }
    func tags(_ key: ClubsCreate.FieldID) -> [ClubsCreate.TagItem] {
        if case .tags(let t) = values[key] { return t }; return []
    }
    func links(_ key: ClubsCreate.FieldID) -> [ClubsCreate.LinkItem] {
        if case .links(let l) = values[key] { return l }; return []
    }
    func cover(_ key: ClubsCreate.FieldID) -> AppUIEntities.BackgroundType {
        if case .cover(let c) = values[key] { return c }; return .primary
    }
    func radio(_ key: ClubsCreate.FieldID) -> ClubsCreate.RadioType {
        if case .radio(let r) = values[key] { return r }; return .public
    }
    
    func setText(_ key: ClubsCreate.FieldID, _ v: String) { values[key] = .text(v) }
    func setTags(_ key: ClubsCreate.FieldID, _ v: [ClubsCreate.TagItem]) { values[key] = .tags(v) }
    func setLinks(_ key: ClubsCreate.FieldID, _ v: [ClubsCreate.LinkItem]) { values[key] = .links(v) }
    func setColor(_ key: ClubsCreate.FieldID, _ v: AppUIEntities.BackgroundType) { values[key] = .cover(v) }
    func setRadio(_ key: ClubsCreate.FieldID, _ v: ClubsCreate.RadioType) { values[key] = .radio(v) }
}

// MARK: - Feature Action

enum ClubCreateAction: UIFeatureAction {
    case fetchData
    case backTapped
}

extension Dictionary where Key == ClubsCreate.FieldID, Value == ClubsCreate.FieldValue {

    var cover: AppUIEntities.BackgroundType {
        if case .cover(let value) = self[.cover] {
            return value
        }
        return .primary
    }

    var visibility: ClubsCreate.RadioType {
        if case .radio(let value) = self[.visibility] {
            return value
        }
        return .public
    }

    func text(_ id: ClubsCreate.FieldID) -> String {
        if case .text(let value) = self[id] {
            return value
        }
        return ""
    }
}
