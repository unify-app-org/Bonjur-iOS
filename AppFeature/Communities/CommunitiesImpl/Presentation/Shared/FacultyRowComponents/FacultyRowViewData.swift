//
//  FacultyRowViewData.swift
//  AppFeature
//
//  Created by aplle on 3/22/26.
//


import Communities

struct FacultyRowViewData: Identifiable, Hashable {
    let id: String
    let title: String
    let accessory: FacultyRowAccessory

    init(
        id: String,
        title: String,
        accessory: FacultyRowAccessory
    ) {
        self.id = id
        self.title = title
        self.accessory = accessory
    }
}

extension FacultyRowViewData {
    init(
        faculty: CommunitiesMemberModuleModel.FacultyRowModel,
        accessory: FacultyRowAccessory
    ) {
        self.init(
            id: faculty.id,
            title: faculty.title,
            accessory: accessory
        )
    }
}
