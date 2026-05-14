//
//  ProfileDetail.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppUIKit
import Clubs
import Events
import Hangouts
import AppPresentationModel

enum ProfileDetail {
    
    struct UIModel {
        let userCardModel: UserCardModel
        let about: String?
        let gender: AppPresentationModel.GenderModel?
        let birthday: String?
        let languages: [SelectableListItemView.Model]?
        let tags: [AppUIEntities.Tags]
    }
}
