//
//  EventsCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Events

extension EventsCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        let name: String
        let coverimageURL: String?
        let memberCount: Int
        let totalCapacity: Int?
        let club: Club
        let tags: [AppUIEntities.Tags]
        let bgType: AppUIEntities.BackgroundType
        let requestType: AppUIEntities.RequestType
        let accessType: AppUIEntities.AccessType
        let role: AppUIEntities.UserActivityRole?
        // Defaults are fallbacks; real values come from the discover feed via `init(from:)`
        let time: String
        let location: String
        let dateDay: String
        let dateMonth: String

        init(
            id: String,
            name: String,
            coverimageURL: String?,
            memberCount: Int,
            totalCapacity: Int?,
            club: Club,
            tags: [AppUIEntities.Tags],
            bgType: AppUIEntities.BackgroundType,
            requestType: AppUIEntities.RequestType,
            accessType: AppUIEntities.AccessType,
            role: AppUIEntities.UserActivityRole? = nil,
            time: String = "18:00",
            location: String = "Campus, Room 204",
            dateDay: String = "14",
            dateMonth: String = "JUN"
        ) {
            self.id = id
            self.name = name
            self.coverimageURL = coverimageURL
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.club = club
            self.tags = tags
            self.bgType = bgType
            self.requestType = requestType
            self.accessType = accessType
            self.role = role
            self.time = time
            self.location = location
            self.dateDay = dateDay
            self.dateMonth = dateMonth
        }

        /// President is treated as the owner of the event's club.
        var isOwner: Bool { role == .president }
        
        var buttonTitle: String {
            switch requestType {
            case .joined:
                return "Participating"
            case .rejected:
                return "Request again"
            case .pending:
                return "Request sent"
            case .none:
                switch accessType {
                case .public:
                    return "Join"
                case .private:
                    return "Request"
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

        var memberCountText: String {
            if let totalCapacity {
                return "count_of".localized(with: memberCount, totalCapacity)
            } else {
                return "count_members".localized(with: memberCount)
            }
        }
    }
    
    struct Club {
        let name: String
        let id: Int
    }
}

extension EventsCardView.Model {
    
    init(from: EventsModuleModel.CardInputData) {
        let parts = Self.dateParts(from: from.eventDate)
        self.init(
            id: from.id,
            name: from.name,
            coverimageURL: from.coverimageURL,
            memberCount: from.memberCount,
            totalCapacity: from.totalCapacity,
            club: .init(
                name: from.club.name,
                id: from.club.id
            ),
            tags: from.tags,
            bgType: from.bgType,
            requestType: from.requestType,
            accessType: from.accessType,
            role: from.role,
            time: parts.time,
            location: from.location,
            dateDay: parts.day,
            dateMonth: parts.month
        )
    }

    /// Split an event date into the badge/meta strings the card renders.
    /// Returns `"-"` placeholders when the date is missing.
    private static func dateParts(
        from date: Date?
    ) -> (day: String, month: String, time: String) {
        guard let date else { return ("-", "-", "-") }
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


extension EventsCardView.Model {
    static let previewMock: [Self] = [
        .init(
            id: UUID().uuidString,
            name: "Fan events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 21,
            totalCapacity: 40,
            club: .init(
                name: "Football club",
                id: 2
            ),
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
            bgType: .primary,
            requestType: .none,
            accessType: .public
        ),
        .init(
            id: UUID().uuidString,
            name: "Messi events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 15,
            totalCapacity: 34,
            club: .init(
                name: "Football club",
                id: 2
            ),
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
            bgType: .secondary,
            requestType: .none,
            accessType: .private
        ),
        .init(
            id: UUID().uuidString,
            name: "Chess events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 15,
            totalCapacity: 34,
            club: .init(
                name: "Chess club",
                id: 2
            ),
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Chess"
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
            bgType: .teritary,
            requestType: .pending,
            accessType: .public
        )
    ]
}
