//
//  HangoutsCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import AppFoundation
import AppUIKit
import Hangouts

extension HangoutsCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        let name, description: String
        let memberCount: Int
        let totalCapacity: Int?
        let tags: [AppUIEntities.Tags]
        let accessType: AppUIEntities.AccessType
        let requestType: AppUIEntities.RequestType
        // Backend-driven; nil hides the badge/meta row on the card.
        let dateDay: String?
        let dateMonth: String?
        let time: String?
        let location: String?
        let role: AppUIEntities.UserActivityRole?

        init(
            id: String,
            name: String,
            description: String,
            memberCount: Int,
            totalCapacity: Int?,
            tags: [AppUIEntities.Tags],
            accessType: AppUIEntities.AccessType,
            requestType: AppUIEntities.RequestType,
            dateDay: String? = nil,
            dateMonth: String? = nil,
            time: String? = nil,
            location: String? = nil,
            role: AppUIEntities.UserActivityRole? = nil
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.tags = tags
            self.accessType = accessType
            self.requestType = requestType
            self.dateDay = dateDay
            self.dateMonth = dateMonth
            self.time = time
            self.location = location
            self.role = role
        }
        
        var memberCountText: String {
            if let totalCapacity {
                return "count_of".localized(with: memberCount, totalCapacity)
            } else {
                return "count_members".localized(with: memberCount)
            }
        }

        var buttonTitle: String {
            switch requestType {
            case .joined:
                "Participating"
            case .rejected:
                "Request again"
            case .pending:
                "Request sent"
            case .none:
                switch accessType {
                case .public:
                    "Join"
                case .private:
                    "Request"
                }
            }
        }
        
        var buttonDisabled: Bool {
            switch requestType {
            case .joined, .pending:
                true
            case .none, .rejected:
                false
            }
        }
    }
}

extension HangoutsCardView.Model {
    init(from: HangoutsModuleModel.CardInputData) {
        let parts = Self.dateParts(from: from.hangoutDate)
        self.init(
            id: from.id,
            name: from.name,
            description: from.description,
            memberCount: from.memberCount,
            totalCapacity: from.totalCapacity,
            tags: from.tags,
            accessType: from.accessType,
            requestType: from.requestType,
            dateDay: parts.day,
            dateMonth: parts.month,
            time: parts.time,
            location: from.location,
            role: from.role
        )
    }

    /// Split a hangout date into the badge/meta strings the card renders.
    /// Returns `nil`s when the date is missing so the UI hides those rows.
    static func dateParts(
        from date: Date?
    ) -> (day: String?, month: String?, time: String?) {
        guard let date else { return (nil, nil, nil) }
        let day = String(Calendar.current.component(.day, from: date))
        let monthFormatter = DateFormatter()
        monthFormatter.locale = Locale(identifier: "en_US_POSIX")
        monthFormatter.dateFormat = "MMM"
        let month = monthFormatter.string(from: date).uppercased()
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.dateFormat = "HH:mm"
        let time = timeFormatter.string(from: date)
        return (day, month, time)
    }
}

extension HangoutsCardView.Model {
    
    static let previewMock: [Self] = [
        .init(
            id: UUID().uuidString,
            name: "Study night at cafe",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Football"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            accessType: .public,
            requestType: .none
        ),
        .init(
            id: UUID().uuidString,
            name: "Exam preparation",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Football"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            accessType: .public,
            requestType: .none
        ),
        .init(
            id: UUID().uuidString,
            name: "To find new peoples",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Football"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            accessType: .public,
            requestType: .none
        )
    ]
}
