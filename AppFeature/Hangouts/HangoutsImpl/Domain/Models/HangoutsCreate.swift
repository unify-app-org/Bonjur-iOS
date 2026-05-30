//
//  HangoutsCreate.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import Foundation
import AppPresentationModel

enum HangoutsCreate {
    
    struct TagItem: Identifiable, Hashable {
        let id: Int
        var label: String
    }
    
    struct LinkItem: Identifiable, Equatable {
        let id: UUID
        var type: String
        var name: String
        var url: String
        
        init(
            id: UUID = UUID(),
            type: String,
            name: String,
            url: String
        ) {
            self.id = id
            self.type = type
            self.name = name
            self.url = url
        }
    }
    
    struct PrefillData {
        let visibility: AppPresentationModel.AccessType
        let name: String
        let ownerContact: String
        let clubName: String
        let clubOwnerContact: String
        let categories: [TagItem]
        let capacity: String
        let links: [LinkItem]
        let rules: String
        let location: String
        let about: String
        let hangoutDate: Date?
        let endDate: Date?
    }
}
