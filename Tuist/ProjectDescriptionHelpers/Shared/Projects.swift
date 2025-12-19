//
//  Projects.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public extension Project {
    enum Projects {
        public static let main: String = "App"
        
        public static let core: String = "AppCore"
        public static let features: String = "AppFeature"
        
        public static var allCases: [String] {
            [
                Projects.main,
                Projects.features,
                Projects.core
            ]
        }
    }
    
    static let projects: [Path] = Projects.allCases.map {
        .init(stringLiteral: $0)
    }
}
