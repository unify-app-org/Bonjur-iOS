//
//  AttachmentItemModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit

public extension AttachmentItemView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        let image: UIImage
        let size: String
        let name: String
        let type: AttachmentType = .none
        let canEdit: Bool
        
        public init(
            id: Int,
            image: UIImage = UIImage.Icons.fileAttachment,
            name: String,
            size: String,
            canEdit: Bool = false
        ) {
            self.id = id
            self.image = image
            self.size = size
            self.name = name
            self.canEdit = canEdit
        }
    }
    
    enum AttachmentType {
        case pdf
        case image
        case xlsx
        case docx
        case none
    }
}

public extension AttachmentItemView.Model {
    
    static let previewMock: [Self] = [
        .init(
            id: 1,
            name: "Carear_fair_2025.pdf",
            size: "16 kb"
        ),
        .init(
            id: 1,
            name: "Carear_fair_2025.image",
            size: "14 mb"
        )
    ]
}
