//
//  FilterModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import Foundation

public extension FilterView {
    struct Model: Identifiable, Hashable {
        public let id = UUID()
        let title: String
        let type: String
        var items: [Items]
        
        public init(title: String, type: String, items: [Items]) {
            self.title = title
            self.type = type
            self.items = items
        }
    }
    
    struct Items: Identifiable, Hashable {
        public let uuid = UUID()
        let title: String
        var selected: Bool = false
        public let id: Int
        
        public init(title: String, selected: Bool = false, id: Int) {
            self.title = title
            self.selected = selected
            self.id = id
        }
    }
}

public extension FilterView.Model {
    static var mock: [FilterView.Model] = [
        .init(
            title: "sport",
            type: "SPORT",
            items: [
                .init(
                    title: "Football",
                    id: 1
                ),
                .init(
                    title: "Basketball",
                    id: 2
                ),
                .init(
                    title: "VoleyBall",
                    id: 3
                ),
                .init(
                    title: "Football",
                    id: 4
                ),
                .init(
                    title: "Basketball",
                    id: 5
                ),
                .init(
                    title: "VoleyBall",
                    id: 6
                ),
                .init(
                    title: "Football",
                    id: 7
                ),
                .init(
                    title: "Basketball",
                    id: 8
                ),
                .init(
                    title: "VoleyBall",
                    id: 9
                ),
                .init(
                    title: "Football",
                    id: 10
                ),
                .init(
                    title: "Basketball",
                    id: 11
                ),
                .init(
                    title: "VoleyBall",
                    id: 12
                ),
                .init(
                    title: "Football",
                    id: 13
                ),
                .init(
                    title: "Basketball",
                    id: 14
                ),
                .init(
                    title: "VoleyBall",
                    id: 15
                ),
                .init(
                    title: "Football",
                    id: 16
                ),
                .init(
                    title: "Basketball",
                    id: 17
                ),
                .init(
                    title: "VoleyBall",
                    id: 18
                )
            ]
        ),
        .init(
            title: "fashion",
            type: "FASHION",
            items: [
                .init(
                    title: "Beauty",
                    id: 19
                ),
                .init(
                    title: "Stars",
                    id: 20
                ),
                .init(
                    title: "Celebrities",
                    id: 21
                ),
                .init(
                    title: "Dress",
                    id: 22
                ),
                .init(
                    title: "Beauty",
                    id: 23
                ),
                .init(
                    title: "Stars",
                    id: 24
                ),
                .init(
                    title: "Celebrities",
                    id: 25
                ),
                .init(
                    title: "Dress",
                    id: 26
                ),
                .init(
                    title: "Beauty",
                    id: 27
                ),
                .init(
                    title: "Stars",
                    id: 28
                ),
                .init(
                    title: "Celebrities",
                    id: 29
                ),
                .init(
                    title: "Dress",
                    id: 30
                ),
                .init(
                    title: "Beauty",
                    id: 31
                ),
                .init(
                    title: "Stars",
                    id: 32
                ),
                .init(
                    title: "Celebrities",
                    id: 33
                ),
                .init(
                    title: "Dress",
                    id: 34
                ),
            ]
        ),
        .init(
            title: "study",
            type: "STUDY",
            items: [
                .init(
                    title: "Exams",
                    id: 35
                ),
                .init(
                    title: "Physics",
                    id: 36
                ),
                .init(
                    title: "Math",
                    id: 37
                ),
                .init(
                    title: "Chemistry",
                    id: 38
                ),
                .init(
                    title: "CS",
                    id: 39
                ),
                .init(
                    title: "OG",
                    id: 40
                ),
                .init(
                    title: "CE",
                    id: 41
                ),
                .init(
                    title: "Data science",
                    id: 42
                ),
                .init(
                    title: "Hackhaton",
                    id: 43
                )
            ]
        )
    ]
}
