//
//  ClubsCreate.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import Foundation
import AppUIKit

enum ClubsCreate {
    
    struct TagItem: Identifiable, Equatable {
        let id: Int
        var label: String

        init(id: Int, label: String) {
            self.id = id
            self.label = label
        }
    }

    struct LinkItem: Identifiable, Equatable {
        let id: UUID
        var label: String
        var value: String

        init(id: UUID = UUID(), value: String, label: String) {
            self.id = id
            self.value = value
            self.label = label
        }
    }
    
    struct CoverItem {
        let title: String
        let description: String
        let covers: [AppUIEntities.BackgroundType]
    }

    // MARK: - Field Value (sum type keyed by field id)

    enum FieldValue {
        case text(String)
        case tags([TagItem])
        case links([LinkItem])
        case cover(AppUIEntities.BackgroundType)
        case radio(RadioType)
    }

    // MARK: - Field Schema

    enum FieldType {
        case coverPicker(item: CoverItem)
        case radioGroup(options: [RadioOption])
        case text(placeholder: String)
        case textArea(placeholder: String, maxLength: Int)
        case chipInput(placeholder: String)
        case linkInput(placeholder: String)
        
        var id: String {
            switch self {
            case .coverPicker:
                return "cover"
            case .radioGroup:
                return "radio"
            case .text:
                return "text"
            case .textArea:
                return "textarea"
            case .chipInput:
                return "chip"
            case .linkInput:
                return "link"
            }
        }
    }

    struct RadioOption: Identifiable {
        let id = UUID()
        let value: RadioType
        let label: String
        let description: String
    }

    struct FieldSchema: Identifiable {
        var id: FieldID
        let label: String
        let type: FieldType
        var required: Bool = true
    }
    
    enum FieldID: String {
        case cover
        case visibility
        case clubName
        case ownerContact
        case category
        case capacity
        case links
        case location
        case rules
        case about
    }
    
    enum RadioType: String {
        case `public`
        case `private`
    }
}
