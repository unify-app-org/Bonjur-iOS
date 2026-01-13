//
//  FilterModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import Foundation

extension FilterView {
    struct Model: Identifiable {
        let id = UUID()
        let title: String
        var hasSelectedItem: Bool = false
        let type: String
        var items: [Items]
        
        static var mock: [Model] = [
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
                        title: "",
                        id: 2
                    )
                ]
            ),
            .init(
                title: "study",
                type: "STUDY",
                items: [
                    .init(
                        title: "",
                        id: 3
                    )
                ]
            )
        ]
    }
    
    struct Items: Identifiable {
        let uuid = UUID()
        let title: String
        var selected: Bool = false
        let id: Int
    }
}
