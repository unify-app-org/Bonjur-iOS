//
//  UserCardWidgetPublisher.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import UIKit
import WidgetKit
import AppUIKit
import AppWidgetShared

/// Mirrors the signed-in user's card into the App Group the home-screen widget
/// reads. Called on every own-profile load; the widget itself has no session,
/// so this is the only way its content ever changes.
enum UserCardWidgetPublisher {

    /// Avatar is downscaled before it is written — the widget process has a
    /// hard memory budget and only ever draws it at ~62pt.
    private static let avatarSide: CGFloat = 180

    static func publish(card: UserCardModel, userId: String) {
        UserCardWidgetStore.save(
            .init(
                userId: userId,
                nameSurname: card.nameSurname,
                speciality: card.speciality,
                course: card.course,
                community: card.community,
                degree: card.degree,
                entryYear: card.entryYear,
                email: card.email,
                background: card.backgroundCover?.rawValue
            )
        )
        reload()

        guard let url = RemoteImageURL.resolved(card.imageUrl) else { return }
        Task.detached(priority: .utility) {
            guard let data = await downscaledAvatar(from: url) else { return }
            UserCardWidgetStore.saveAvatar(data)
            reload()
        }
    }

    static func clear() {
        UserCardWidgetStore.clear()
        reload()
    }

    private static func reload() {
        WidgetCenter.shared.reloadTimelines(ofKind: UserCardWidgetStore.widgetKind)
    }

    private static func downscaledAvatar(from url: URL) async -> Data? {
        guard
            let (data, _) = try? await URLSession.shared.data(from: url),
            let image = UIImage(data: data)
        else {
            return nil
        }

        let longestSide = max(image.size.width, image.size.height)
        guard longestSide > avatarSide else { return image.jpegData(compressionQuality: 0.9) }

        let scale = avatarSide / longestSide
        let size = CGSize(
            width: image.size.width * scale,
            height: image.size.height * scale
        )
        // Scale 1: the renderer would otherwise bake in the device's 3x screen
        // scale and write a 3x-larger bitmap than asked for.
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let resized = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        return resized.jpegData(compressionQuality: 0.9)
    }
}
